# seamfusion-api-sync

## Purpose

Build-time fetch of public academy data from SeamFusion Cloud Functions so marketing content can be CMS-driven, with hard fallback to static JSON/TS when the API is unavailable.

## Requirements

### Requirement: Build-time public academy fetch
`src/lib/seamfusion-api.ts` SHALL fetch public academy sections (`coaches`, `programs`, `branding`, `gallery`, `content`) when `PUBLIC_API_URL` and `PUBLIC_ACADEMY_ID` are set.

#### Scenario: Env configured
- **WHEN** both env vars are present at build time
- **THEN** the client requests `getPublicAcademyData` with `academyId` and optional `sections`

### Requirement: Fail-soft fallback
API failures, timeouts, missing env, or non-OK responses SHALL return null and never throw; callers MUST fall back to static `academy.json` / `programs.ts` (or equivalent) so the site still builds and serves.

#### Scenario: API unreachable
- **WHEN** the Cloud Function is down or times out
- **THEN** fetch helpers return null and the static site build completes using local data

### Requirement: Per-build content cache
Repeated `fetchWebsiteContent` calls within one build SHALL share a single in-memory cache to avoid duplicate network requests.

#### Scenario: Multiple components request content
- **WHEN** several Astro components call `fetchWebsiteContent` during one build
- **THEN** at most one network fetch is performed for content
