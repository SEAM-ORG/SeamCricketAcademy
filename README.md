# Seam Cricket Academy 🏏

> **Train Hard. Play Smart. Rise Higher.**

Official website for Seam Cricket Academy, Bengaluru's premier cricket coaching academy with over 60 years of combined coaching experience.

![Astro](https://img.shields.io/badge/Astro-5.8-BC52EE?style=flat&logo=astro&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-4.0-38B2AC?style=flat&logo=tailwind-css&logoColor=white)
![License](https://img.shields.io/badge/License-Private-red)


## Agent OS

Architect↔Agent operating contract: root [`AGENTS.md`](AGENTS.md).  
Architect states product intent; agent owns technical execution, hooks, and GitOps.  
Spec-driven memory: [`openspec/`](openspec/) (sole SDD SoT). Docs map: [`docs/INDEX.md`](docs/INDEX.md).

## ✨ Features

- **Modern Dark Theme** - Premium glassmorphism aesthetic with neon accents
- **Responsive Design** - Optimized for all devices from mobile to desktop
- **Auto-Scrolling Gallery** - Smooth carousel with fullscreen expand
- **GSAP Animations** - Smooth scroll-triggered reveal effects
- **Snap Scrolling** - Section-based navigation experience
- **WhatsApp Integration** - Floating chat button for quick contact
- **Christmas Theme** - Seasonal decorations (Dec 2024)

## 🛠️ Tech Stack

| Technology                                | Purpose               |
| ----------------------------------------- | --------------------- |
| [Astro 7](https://astro.build)            | Static site generator |
| [Tailwind CSS 4](https://tailwindcss.com) | Utility-first styling |
| [GSAP](https://greensock.com/gsap/)       | Animation library     |
| [Web3Forms](https://web3forms.com)        | Form submission       |

## 📁 Project Structure

```
html-seamcricketacademy/
├── astro-revamp/           # Main Astro project
│   ├── src/
│   │   ├── components/     # Reusable components
│   │   │   ├── Navbar.astro
│   │   │   ├── Hero.astro
│   │   │   ├── Programs.astro
│   │   │   ├── Coaches.astro
│   │   │   ├── Gallery.astro
│   │   │   ├── ContactForm.astro
│   │   │   └── ...
│   │   ├── layouts/        # Page layouts
│   │   ├── pages/          # Route pages
│   │   ├── styles/         # Global CSS
│   │   └── data/           # JSON data files
│   └── public/             # Static assets
├── assets/                 # Legacy assets
└── backup-legacy/          # Legacy HTML & Backups
```

## 🚀 Getting Started

### Prerequisites

- Node.js 18+
- npm or pnpm

### Installation

```bash
# Clone the repository
git clone https://github.com/seamcricketacademy/html-seamcricketacademy.git

# Navigate to project
cd html-seamcricketacademy/astro-revamp

# Install dependencies
npm install

# Start development server
npm run dev
```

The site will be available at `http://localhost:4321`

### Build for Production

```bash
npm run build
```

Output will be in the `dist/` folder.

## 📝 Key Components

| Component                | Description                                                                 |
| ------------------------ | --------------------------------------------------------------------------- |
| `Navbar.astro`           | Transparent navbar with Christmas theme, tagline, and smooth hide on scroll |
| `Hero.astro`             | Full-screen hero with background image and CTA                              |
| `Programs.astro`         | 2-column grid of all coaching programs                                      |
| `Coaches.astro`          | 3-column grid of coach profiles with glass cards                            |
| `Gallery.astro`          | Auto-scrolling media carousel with fullscreen expand                        |
| `ContactForm.astro`      | Registration form with Web3Forms integration                                |
| `FloatingWhatsApp.astro` | Context-aware WhatsApp button (shows on contact section)                    |

## 🎨 Design System

### Colors

| Token     | Value                    | Usage          |
| --------- | ------------------------ | -------------- |
| `void`    | `#030305`                | Background     |
| `depth`   | `#0A0A0F`                | Cards/Surfaces |
| `neon`    | `#4285F4`                | Accent/CTAs    |
| `surface` | `rgba(255,255,255,0.03)` | Glass panels   |

### Typography

- **Font**: Inter (Google Fonts)
- **Weights**: 300 (Light), 400 (Regular), 600 (Semi-bold), 800 (Extra-bold)

## 📞 Contact

- **Website**: [seamcricketacademy.com](https://www.seamcricketacademy.com)
- **WhatsApp**: +91 89511 91375
- **Email**: seamcricketacademy@gmail.com
- **Location**: Bengaluru, Karnataka

---

© 2026 Seam Cricket Academy. All rights reserved.
