# coach-profiles

## Purpose

Showcase academy coaches and related social proof (e.g. player of the month) so visitors trust coaching quality.

## Requirements

### Requirement: Coach roster display
The site SHALL render coach profiles (name, role/bio, photo when available) from academy data (`academy.json` trainers and/or SeamFusion coaches section).

#### Scenario: Coaches section on home
- **WHEN** a visitor views the coaches section
- **THEN** coaches are listed with identifying name and supporting copy or image

### Requirement: Player spotlight
When player-of-the-month (or equivalent) content exists in academy data, the site SHALL surface it as a distinct spotlight section.

#### Scenario: Player feature present
- **WHEN** `playerFeature` (or equivalent) content is available
- **THEN** the spotlight section renders that content without breaking layout if fields are sparse
