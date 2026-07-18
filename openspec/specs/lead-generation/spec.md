# lead-generation

## Purpose

Convert visitors into academy leads via contact form (Web3Forms + optional SeamFusion pipeline) and context-aware WhatsApp deep links, with safe link validation.

## Requirements

### Requirement: Contact form capture
The contact form SHALL collect prospect details and program interest and submit via the configured Web3Forms (and dual-submit SeamFusion path when configured) without exposing secrets in the client beyond public access keys intended for browser use.

#### Scenario: Successful form submit
- **WHEN** a visitor submits a valid contact form
- **THEN** the form posts to the configured endpoint(s) and shows success feedback

### Requirement: WhatsApp deep links
Floating and inline WhatsApp CTAs SHALL use `https:` links only to `wa.me` or `api.whatsapp.com`, validated before render/use.

#### Scenario: Invalid WhatsApp URL rejected
- **WHEN** a configured WhatsApp URL fails `isValidWhatsApp`
- **THEN** the unsafe URL is not used as an actionable href

### Requirement: Safe dynamic URLs
Email, tel, and external links built from data SHALL pass validation (`isValidEmail`, `isSafeUrl`) before becoming hrefs.

#### Scenario: javascript: protocol blocked
- **WHEN** a dynamic URL uses a disallowed protocol
- **THEN** it is not rendered as a navigable link
