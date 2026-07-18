# academy-marketing-ux

## Purpose

Premium marketing experience for Seam Cricket Academy: dark glassmorphism, neon accents, kinetic scroll reveals, and standardized 3D iconography that convert visitors without diluting brand.

## Requirements

### Requirement: Weightless / Kinetic design system
The site SHALL present a dark, glassmorphism UI with neon accents per `DESIGN_SYSTEM.md` (glass panels, neon borders on hover, light tracking headings).

#### Scenario: Primary surfaces use glass + neon
- **WHEN** a visitor views hero, program cards, or feature sections
- **THEN** surfaces use glass-panel styling and neon accent treatment consistent with the design system

### Requirement: Standardized feature iconography
Feature and program icons SHALL be 3D emoji / high-fidelity transparent assets at `w-16 h-16 object-contain` without CSS blend-mode hacks for standard assets.

#### Scenario: Program icon sizing
- **WHEN** a program or feature tile renders an icon image
- **THEN** the image uses `w-16 h-16 object-contain` (or equivalent) and remains uncropped

### Requirement: Scroll-reveal motion
Scroll-driven reveals (GSAP / ScrollReveal) SHALL enhance sections without blocking content accessibility or first paint of critical copy.

#### Scenario: Section enters viewport
- **WHEN** a marked section scrolls into view
- **THEN** a reveal animation runs while content remains readable if motion is reduced or JS is delayed
