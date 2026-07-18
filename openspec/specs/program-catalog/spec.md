# program-catalog

## Purpose

Display academy programs and batches (age groups, timings, featured/new flags) from structured data so prospects can choose a fit and start lead capture.

## Requirements

### Requirement: Structured program data
Programs SHALL be driven from `src/data/programs.ts` (and optional SeamFusion-synced overrides) with title, description, timing, and optional age group / featured / newBatch flags.

#### Scenario: Home programs grid
- **WHEN** a visitor opens the home page programs section
- **THEN** each program tile shows title, description, and timing from the catalog data

### Requirement: Featured and new-batch emphasis
The catalog SHALL visually distinguish featured and new-batch programs when those flags are set.

#### Scenario: New batch flag
- **WHEN** a program has `newBatch: true`
- **THEN** the UI surfaces a new-batch emphasis (badge or equivalent) without hiding other programs
