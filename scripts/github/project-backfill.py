#!/usr/bin/env python3
"""GraphQL paginated Project V2 backfill — Work Type, Priority Level, labels, milestones.

Usage (from product repo, or with env):
  BF_OWNER=SEAM-ORG BF_PNUM=8 BF_REPO=SEAM-ORG/SeamFusionServices \\
    python3 project-backfill.py [--dry-run] [--skip-content] [--max N]

Or via project-backfill.sh wrapper.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import time


def run(args: list[str]) -> subprocess.CompletedProcess:
    return subprocess.run(args, capture_output=True, text=True)


def gh_json(args: list[str]):
    r = run(["gh", *args])
    if r.returncode != 0:
        return None, r.stderr or r.stdout
    try:
        return json.loads(r.stdout), None
    except Exception as e:
        return None, str(e)


def infer_type(title: str, labels: list[str]) -> str:
    t = (title or "").lower()
    lc = " ".join(labels or []).lower()
    if "security" in lc or "security" in t or "ssrf" in t or "cve" in t:
        return "Security"
    if (
        "agent-infra" in lc
        or "agent os" in t
        or "gitops" in t
        or "session-end" in t
        or "project v2" in t
        or "chore(os)" in t
        or "chore(agents)" in t
        or re.search(r"\b(hooks?|bootstrap|preflight)\b", t)
    ):
        return "Infra"
    if "bug" in lc or t.startswith("fix:") or t.startswith("fix(") or "regression" in t:
        return "Bug"
    if (
        "enhancement" in lc
        or t.startswith("feat:")
        or t.startswith("feat(")
        or t.startswith("feature:")
        or t.startswith("enhancement:")
    ):
        return "Feature"
    if "documentation" in lc or t.startswith("docs:") or t.startswith("doc:"):
        return "Chore"
    if "chore" in lc or t.startswith("chore:") or t.startswith("chore(") or t.startswith("ops:"):
        if any(k in t for k in ("github", "hook", "agent", " os", "release protocol")):
            return "Infra"
        return "Chore"
    return "Chore"


def want_label(type_name: str) -> str:
    return {
        "Security": "security",
        "Bug": "bug",
        "Feature": "enhancement",
        "Infra": "agent-infra",
    }.get(type_name, "chore")


def list_milestones(repo: str) -> list[dict]:
    out = []
    for state in ("open", "closed"):
        r = run(["gh", "api", f"repos/{repo}/milestones?state={state}&per_page=100"])
        if r.returncode == 0:
            try:
                out.extend(json.loads(r.stdout or "[]"))
            except Exception:
                pass
    return out


def resolve_milestone_title(repo: str, title: str, type_name: str, infra_ms: str, want_hint: str) -> str:
    """Map a desired milestone to an existing repo milestone when possible."""
    existing = list_milestones(repo)
    titles = [(ms.get("title") or "") for ms in existing]
    if want_hint in titles:
        return want_hint
    # Phase N → prefer longest matching "Phase N..." existing title
    m = re.match(r"^Phase\s+(\d+(?:\.\d+)?[A-Za-z]?)$", want_hint)
    if m:
        prefix = f"Phase {m.group(1)}"
        matches = [t for t in titles if t == prefix or t.startswith(prefix + ":") or t.startswith(prefix + " ")]
        if matches:
            matches.sort(key=len, reverse=True)
            return matches[0]
    if type_name == "Infra" and infra_ms in titles:
        return infra_ms
    if "Product Delivery" in titles:
        return "Product Delivery"
    return want_hint


def infer_milestone(title: str, type_name: str, infra_ms: str) -> str:
    """Choose a milestone title for items that have none."""
    if type_name == "Infra":
        return infra_ms
    t = title or ""
    # Prefer explicit phase markers in title (Phase 20, phase-7, Phase 12.5)
    m = re.search(r"[Pp]hase[\s\-]*(\d+(?:\.\d+)?[A-Za-z]?)", t)
    if m:
        return f"Phase {m.group(1)}"
    # Durable catch-all for historical shipped product work
    return "Product Delivery"


def ensure_milestone(repo: str, title: str) -> bool:
    """Create milestone if missing. Returns True if it exists or was created."""
    for ms in list_milestones(repo):
        if (ms.get("title") or "") == title:
            # reopen if closed so assign works
            if (ms.get("state") or "") == "closed" and ms.get("number"):
                run(["gh", "api", "-X", "PATCH", f"repos/{repo}/milestones/{ms['number']}", "-f", "state=open"])
            return True
    r2 = run([
        "gh", "api", "-X", "POST", f"repos/{repo}/milestones",
        "-f", f"title={title}",
        "-f", f"description=Auto-created by project-backfill for board hygiene",
    ])
    return r2.returncode == 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--skip-content", action="store_true")
    ap.add_argument("--max", type=int, default=0, help="max items to process (0=all)")
    args = ap.parse_args()

    owner = os.environ.get("BF_OWNER") or ""
    pnum = os.environ.get("BF_PNUM") or ""
    repo_default = os.environ.get("BF_REPO") or ""
    type_field = os.environ.get("BF_TYPE_FIELD") or "Work Type"
    prio_field = os.environ.get("BF_PRIO_FIELD") or "Priority Level"
    infra_ms = os.environ.get("BF_INFRA_MS") or "Agent OS & Tooling"
    if not owner or not pnum:
        print("BF_OWNER and BF_PNUM required", file=sys.stderr)
        return 2

    proj, err = gh_json(["project", "view", str(pnum), "--owner", owner, "--format", "json"])
    if not proj:
        print("project view failed", err, file=sys.stderr)
        return 1
    pid = proj["id"]
    print(f"project={owner}/{pnum} id={pid} dry={args.dry_run}", flush=True)

    fields, err = gh_json(["project", "field-list", str(pnum), "--owner", owner, "--format", "json"])
    fl = fields if isinstance(fields, list) else (fields or {}).get("fields", [])
    fid, opts = {}, {}
    for f in fl:
        name = f.get("name") or ""
        if name in (type_field, prio_field, "Status"):
            fid[name] = f.get("id")
            opts[name] = {(o.get("name") or ""): o.get("id") for o in (f.get("options") or [])}
    print(f"fields type={list(opts.get(type_field,{}).keys())} prio={list(opts.get(prio_field,{}).keys())}", flush=True)

    def set_select(item_id: str, field_name: str, option_name: str) -> bool:
        field_id = fid.get(field_name)
        option_id = (opts.get(field_name) or {}).get(option_name)
        if not field_id or not option_id:
            print(f"  WARN missing {field_name}={option_name}", file=sys.stderr, flush=True)
            return False
        if args.dry_run:
            print(f"  [dry] {field_name}={option_name}", flush=True)
            return True
        r = run([
            "gh", "project", "item-edit",
            "--project-id", pid,
            "--id", item_id,
            "--field-id", field_id,
            "--single-select-option-id", option_id,
        ])
        err_blob = ((r.stderr or "") + (r.stdout or "")).lower()
        if r.returncode != 0 and ("rate limit" in err_blob or "secondary rate" in err_blob):
            # Wait for GraphQL primary reset when exhausted; otherwise short secondary backoff
            for attempt in range(4):
                wait = 90
                rr = run(["gh", "api", "rate_limit"])
                if rr.returncode == 0:
                    try:
                        data = json.loads(rr.stdout)
                        g = (data.get("resources") or {}).get("graphql") or {}
                        rem = int(g.get("remaining") or 0)
                        reset = int(g.get("reset") or 0)
                        now = int(time.time())
                        if rem <= 5 and reset > now:
                            wait = min(reset - now + 15, 3700)
                        else:
                            wait = 45 + attempt * 30
                    except Exception:
                        wait = 90 + attempt * 30
                print(f"  rate-limit backoff {wait}s (attempt {attempt+1}/4)…", flush=True)
                time.sleep(wait)
                r = run([
                    "gh", "project", "item-edit",
                    "--project-id", pid,
                    "--id", item_id,
                    "--field-id", field_id,
                    "--single-select-option-id", option_id,
                ])
                if r.returncode == 0:
                    break
        if r.returncode != 0:
            print(f"  WARN edit {field_name}: {(r.stderr or '')[:100]}", file=sys.stderr, flush=True)
            return False
        return True

    query = """
    query($id: ID!, $cursor: String) {
      node(id: $id) {
        ... on ProjectV2 {
          items(first: 50, after: $cursor) {
            pageInfo { hasNextPage endCursor }
            nodes {
              id
              content {
                __typename
                ... on PullRequest {
                  number title url state
                  repository { nameWithOwner }
                  labels(first: 20) { nodes { name } }
                  milestone { title }
                }
                ... on Issue {
                  number title url state
                  repository { nameWithOwner }
                  labels(first: 20) { nodes { name } }
                  milestone { title }
                }
              }
              fieldValues(first: 25) {
                nodes {
                  ... on ProjectV2ItemFieldSingleSelectValue {
                    name
                    field { ... on ProjectV2SingleSelectField { name } }
                  }
                }
              }
            }
          }
        }
      }
    }
    """

    cursor = None
    stats = {"seen": 0, "type_set": 0, "prio_set": 0, "type_ok": 0, "prio_ok": 0, "label": 0, "ms": 0, "err": 0}
    page = 0
    while True:
        page += 1
        payload = {"query": query, "variables": {"id": pid, "cursor": cursor}}
        r = run(["gh", "api", "graphql", "--input", "-"])
        # use input via env file
        r = subprocess.run(
            ["gh", "api", "graphql", "--input", "-"],
            input=json.dumps(payload),
            capture_output=True,
            text=True,
        )
        if r.returncode != 0:
            print("GraphQL failed", r.stderr or r.stdout, file=sys.stderr, flush=True)
            # retry once
            time.sleep(5)
            r = subprocess.run(
                ["gh", "api", "graphql", "--input", "-"],
                input=json.dumps(payload),
                capture_output=True,
                text=True,
            )
            if r.returncode != 0:
                stats["err"] += 1
                break
        data = json.loads(r.stdout)
        items_conn = (((data.get("data") or {}).get("node") or {}).get("items") or {})
        nodes = items_conn.get("nodes") or []
        page_info = items_conn.get("pageInfo") or {}
        print(f"page={page} nodes={len(nodes)} hasNext={page_info.get('hasNextPage')}", flush=True)

        for node in nodes:
            if args.max and stats["seen"] >= args.max:
                break
            stats["seen"] += 1
            item_id = node.get("id")
            content = node.get("content") or {}
            # Draft items may have null content
            if not content or not content.get("number"):
                continue
            title = content.get("title") or ""
            number = content.get("number")
            repo = ((content.get("repository") or {}) or {}).get("nameWithOwner") or repo_default
            ctype = content.get("__typename") or ""
            state = content.get("state") or ""
            labels = [n.get("name") for n in ((content.get("labels") or {}).get("nodes") or []) if n.get("name")]
            mst = ((content.get("milestone") or {}) or {}).get("title") or ""

            fv = {}
            for v in (node.get("fieldValues") or {}).get("nodes") or []:
                if not v:
                    continue
                fname = ((v.get("field") or {}) or {}).get("name")
                if fname and v.get("name"):
                    fv[fname] = v["name"]

            cur_type = fv.get(type_field) or ""
            cur_prio = fv.get(prio_field) or ""
            type_name = cur_type or infer_type(title, labels)
            prio_name = cur_prio or ("P3" if state in ("CLOSED", "MERGED") or fv.get("Status") == "Done" else "P2")
            if not cur_prio and fv.get("Status") == "Done":
                prio_name = "P3"

            need_type = not cur_type
            need_prio = not cur_prio
            print(
                f"[{stats['seen']}] #{number} {ctype} type={cur_type or '∅→'+type_name} prio={cur_prio or '∅→'+prio_name} labels={labels or '∅'} ms={mst or '∅'} | {title[:60]}",
                flush=True,
            )

            if need_type:
                if set_select(item_id, type_field, type_name):
                    stats["type_set"] += 1
                else:
                    stats["err"] += 1
            else:
                stats["type_ok"] += 1

            if need_prio:
                if set_select(item_id, prio_field, prio_name):
                    stats["prio_set"] += 1
                else:
                    stats["err"] += 1
            else:
                stats["prio_ok"] += 1

            if args.skip_content or not number or not repo:
                continue

            # labels
            if not labels:
                lab = want_label(type_name)
                if args.dry_run:
                    print(f"  [dry] +label {lab}", flush=True)
                    stats["label"] += 1
                else:
                    if ctype == "PullRequest":
                        rr = run(["gh", "pr", "edit", str(number), "-R", repo, "--add-label", lab])
                        if type_name == "Infra":
                            run(["gh", "pr", "edit", str(number), "-R", repo, "--add-label", "chore"])
                    else:
                        rr = run(["gh", "issue", "edit", str(number), "-R", repo, "--add-label", lab])
                    if rr.returncode != 0:
                        run(["gh", "label", "create", lab, "-R", repo, "--color", "ededed"])
                        if ctype == "PullRequest":
                            rr = run(["gh", "pr", "edit", str(number), "-R", repo, "--add-label", lab])
                        else:
                            rr = run(["gh", "issue", "edit", str(number), "-R", repo, "--add-label", lab])
                    if rr.returncode == 0:
                        stats["label"] += 1
                        print(f"  +label {lab}", flush=True)
                    time.sleep(0.12)

            # Milestone: infra → Agent OS; product → Phase N from title or Product Delivery
            if not mst:
                want_hint = infer_milestone(title, type_name, infra_ms)
                want_ms = resolve_milestone_title(repo, title, type_name, infra_ms, want_hint)
                if args.dry_run:
                    print(f"  [dry] +milestone {want_ms}", flush=True)
                    stats["ms"] += 1
                else:
                    ensure_milestone(repo, want_ms)
                    if ctype == "PullRequest":
                        rr = run(["gh", "pr", "edit", str(number), "-R", repo, "--milestone", want_ms])
                    else:
                        rr = run(["gh", "issue", "edit", str(number), "-R", repo, "--milestone", want_ms])
                    if rr.returncode != 0:
                        ensure_milestone(repo, want_ms)
                        if ctype == "PullRequest":
                            rr = run(["gh", "pr", "edit", str(number), "-R", repo, "--milestone", want_ms])
                        else:
                            rr = run(["gh", "issue", "edit", str(number), "-R", repo, "--milestone", want_ms])
                    if rr.returncode == 0:
                        stats["ms"] += 1
                        print(f"  +milestone {want_ms}", flush=True)
                    else:
                        print(f"  WARN milestone failed #{number} → {want_ms}", file=sys.stderr, flush=True)
                        stats["err"] += 1
                    time.sleep(0.12)

        if args.max and stats["seen"] >= args.max:
            break
        if not page_info.get("hasNextPage"):
            break
        cursor = page_info.get("endCursor")
        time.sleep(0.5)

    print("=== stats ===", flush=True)
    print(json.dumps(stats, indent=2), flush=True)
    return 0 if stats["err"] == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
