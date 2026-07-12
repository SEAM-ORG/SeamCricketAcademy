# Project Migration & Setup Guide

This guide ensures you can get the **Seam Cricket Academy** project up and running on any new machine (Mac or Windows) in minutes using the Antigravity agent.

## 🚀 The "Single Prompt" Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/seamcricketacademy-png/html-seamcricketacademy.git
   cd html-seamcricketacademy
   ```

2. **Open in IDE**
   - Open the folder in VS Code (with Antigravity installed).

3. **Run the Agent Prompt**
   Open the Agent chat and type:

   > **"I just cloned this repo. Please run /setup to initialize the environment."**

   The agent will automatically:
   - Check your Node.js & Git versions.
   - Install dependencies (`npm ci`).
   - Run a production build to verify everything works.
   - Confirm the project is ready.

---

## 💻 OS-Specific Prerequisites

### 🍎 Mac (macOS)
1. **Install Node.js**:
   - Recommended via Homebrew: `brew install node`
   - Or download [Node.js LTS](https://nodejs.org/) (v20+).
2. **Git**: usually pre-installed. Run `git --version` to check.

### 🪟 Windows
1. **Install Node.js**:
   - Download [Node.js LTS](https://nodejs.org/) (v20+).
2. **Git**:
   - Install [Git for Windows](https://git-scm.com/download/win).
3. **PowerShell**:
   - Antigravity uses PowerShell by default. No special config needed usually, but if scripts fail, you might need: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`.

---

## 🛠 Manual Setup (Fallback)

If you prefer to run commands yourself without the agent:

1. **Install Dependencies**
   ```bash
   npm ci
   ```

2. **Start Dev Server**
   ```bash
   npm run dev
   ```
   > Opens at `http://localhost:4321`

3. **Build for Production**
   ```bash
   npm run build
   ```

## 🤖 Agent Configuration
The agent configuration is **built-in** to the repository in the `.agent/` directory. You do **not** need to copy any files or configure settings manually.

- **Rules**: `.agent/rules/` (Loaded automatically)
- **Workflows**: `.agent/workflows/` (Available immediately)

## Agent OS

See root [`AGENTS.md`](AGENTS.md) for Architect↔Agent contract. One-sentence objectives are enough once OS is installed.
