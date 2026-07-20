#!/usr/bin/env bash
# Portable compact-command helper for Architect↔Agent OS.
# Runs a command after '--', captures stdout/stderr, and prints compact structured digest.
set -euo pipefail

LABEL="command"
MAX_LINES=40
MAX_BYTES=8000

usage_error() {
  echo "Error: $1" >&2
  echo "Usage: $0 [--label TEXT] [--max-lines N] [--max-bytes N] -- command [args...]" >&2
  exit 2
}

HAS_DASH_DASH=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --label)
      [[ $# -gt 1 ]] || usage_error "--label requires a value"
      LABEL="$2"
      shift 2
      ;;
    --label=*)
      LABEL="${1#*=}"
      shift
      ;;
    --max-lines)
      [[ $# -gt 1 ]] || usage_error "--max-lines requires a value"
      MAX_LINES="$2"
      shift 2
      ;;
    --max-lines=*)
      MAX_LINES="${1#*=}"
      shift
      ;;
    --max-bytes)
      [[ $# -gt 1 ]] || usage_error "--max-bytes requires a value"
      MAX_BYTES="$2"
      shift 2
      ;;
    --max-bytes=*)
      MAX_BYTES="${1#*=}"
      shift
      ;;
    --)
      HAS_DASH_DASH=1
      shift
      break
      ;;
    -*)
      usage_error "Unknown option '$1'"
      ;;
    *)
      usage_error "Positional argument '$1' found before '--'"
      ;;
  esac
done

if [[ "$HAS_DASH_DASH" -ne 1 ]]; then
  usage_error "Missing '--' separator before command"
fi

if [[ $# -eq 0 ]]; then
  usage_error "No command specified after '--'"
fi

if ! [[ "$MAX_LINES" =~ ^[1-9][0-9]*$ ]]; then
  usage_error "--max-lines must be a positive integer"
fi

if ! [[ "$MAX_BYTES" =~ ^[1-9][0-9]*$ ]]; then
  usage_error "--max-bytes must be a positive integer"
fi

TMP_OUT="$(mktemp)"
trap 'rm -f "$TMP_OUT"' EXIT INT TERM

set +e
"$@" > "$TMP_OUT" 2>&1
EXIT_CODE=$?
set -e

EXPORT_LABEL="$LABEL" \
EXPORT_EXIT_CODE="$EXIT_CODE" \
EXPORT_MAX_LINES="$MAX_LINES" \
EXPORT_MAX_BYTES="$MAX_BYTES" \
EXPORT_TMP_OUT="$TMP_OUT" \
python3 - <<'PY'
import os
import re
import sys

label = os.environ.get("EXPORT_LABEL", "command")
exit_code = int(os.environ.get("EXPORT_EXIT_CODE", "0"))
max_lines = int(os.environ.get("EXPORT_MAX_LINES", "40"))
max_bytes = int(os.environ.get("EXPORT_MAX_BYTES", "8000"))
tmp_out_path = os.environ.get("EXPORT_TMP_OUT", "")

status = "SUCCESS" if exit_code == 0 else "FAILED"

raw_bytes = b""
if tmp_out_path and os.path.isfile(tmp_out_path):
    with open(tmp_out_path, "rb") as f:
        raw_bytes = f.read()

output_bytes_len = len(raw_bytes)
content_str = raw_bytes.decode("utf-8", errors="replace")
lines = content_str.splitlines()
output_lines_len = len(lines)

if output_lines_len == 0:
    digest_lines = []
elif output_lines_len <= max_lines:
    digest_lines = lines
else:
    if exit_code == 0:
        digest_lines = lines[-max_lines:]
    else:
        err_regex = re.compile(r"error|fail|fatal|exception", re.IGNORECASE)
        matching_indices = [
            i for i, line in enumerate(lines) if err_regex.search(line)
        ]

        if not matching_indices:
            digest_lines = lines[-max_lines:]
        else:
            max_err_count = max(1, max_lines // 2)
            selected_err_indices = matching_indices[:max_err_count]

            tail_count = max(0, max_lines - len(selected_err_indices))
            tail_indices = list(range(max(0, output_lines_len - tail_count), output_lines_len))

            combined_indices = sorted(set(selected_err_indices + tail_indices))

            elements = []
            prev_idx = None
            for idx in combined_indices:
                if prev_idx is not None and idx > prev_idx + 1:
                    omitted = idx - prev_idx - 1
                    elements.append(('gap', omitted, prev_idx, idx))
                elements.append(('line', idx, lines[idx]))
                prev_idx = idx

            while len(elements) > max_lines:
                dropped = False
                for k in range(len(elements) - 1, -1, -1):
                    kind, item_idx, *rest = elements[k]
                    if kind == 'line' and item_idx not in selected_err_indices:
                        elements.pop(k)
                        dropped = True
                        break
                if not dropped:
                    elements.pop()

                new_elements = []
                last_line_idx = None
                for elem in elements:
                    if elem[0] == 'line':
                        cur_idx = elem[1]
                        if last_line_idx is not None and cur_idx > last_line_idx + 1:
                            omitted = cur_idx - last_line_idx - 1
                            new_elements.append(('gap', omitted, last_line_idx, cur_idx))
                        new_elements.append(elem)
                        last_line_idx = cur_idx
                elements = new_elements

            digest_lines = []
            for elem in elements:
                if elem[0] == 'gap':
                    digest_lines.append(f"... [{elem[1]} lines omitted] ...")
                else:
                    digest_lines.append(elem[2])

            if len(digest_lines) > max_lines:
                digest_lines = digest_lines[:max_lines]

digest_str = "\n".join(digest_lines)

if digest_str:
    d_lines = digest_str.splitlines()
    while d_lines:
        cur_str = "\n".join(d_lines) + "\n"
        if len(cur_str.encode("utf-8")) <= max_bytes:
            digest_str = "\n".join(d_lines)
            break
        if len(d_lines) == 1:
            line_b = d_lines[0].encode("utf-8")
            allowed = max(0, max_bytes - 1)
            d_lines[0] = line_b[:allowed].decode("utf-8", errors="ignore")
            digest_str = d_lines[0]
            break
        d_lines.pop(0)
    else:
        digest_str = ""

print(f"STATUS: {status}")
print(f"LABEL: {label}")
print(f"EXIT_CODE: {exit_code}")
print(f"OUTPUT_LINES: {output_lines_len}")
print(f"OUTPUT_BYTES: {output_bytes_len}")
print("DIGEST:")
if digest_str:
    print(digest_str)
PY

exit "$EXIT_CODE"
