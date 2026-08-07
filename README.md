# Code Translation

**Turn a codebase into an interactive book that explains its core files line by line in simple English.**

## The Problem

Architecture diagrams and summaries can tell you what a project does, but they do not help when you open a real source file and cannot understand the code in front of you. Generic AI explanations often skip lines, merge several ideas together, or assume you already know the syntax.

## The Solution

Code Translation is a [Claude Code](https://claude.com/claude-code) skill that analyzes a GitHub repository or local project, helps you choose the core files, and translates every non-empty line beside the original code.

The result begins with the big picture, then walks through the selected files in source order with plain-English explanations, syntax help, and small quizzes.

![Claude Code](https://img.shields.io/badge/Claude_Code-Skill-D97757?logo=anthropic&logoColor=white) ![HTML](https://img.shields.io/badge/Output-Interactive_HTML-E34F26?logo=html5&logoColor=white) ![Line by Line](https://img.shields.io/badge/Coverage-Line_by_Line-2E8B57)

[![Code Translation demo](docs/code-translation-demo.gif)](docs/code-translation-demo.mp4)

[Watch the full demo video](docs/code-translation-demo.mp4)

---

## Features

- **Line-by-line coverage** — every non-empty line in each selected file gets one explanation
- **Core-file discovery** — shows which files contain the important logic before you choose
- **Big-picture map** — explains how the selected files work together
- **Code ↔ plain English** — keeps the original source beside a first-person explanation
- **Syntax help** — introduces classes, functions, and operators only when they appear
- **Version pinning and checks** — ties the book to one source commit and verifies line coverage before delivery

---

## How It Works

```text
Give it a GitHub repo or local project
                 ↓
Analyze the codebase and suggest core files
                 ↓
Choose the files you want to understand
                 ↓
Translate every non-empty line in source order
                 ↓
Build and verify the interactive HTML book
```

---

## Quick Start

### 1. Install the skill

```bash
git clone https://github.com/Jia0612/code-translation.git ~/.claude/skills/code-translation
```

### 2. Ask Claude Code to translate a project

```text
Translate https://github.com/karpathy/micrograd line by line
```

You can also use a local folder:

```text
Translate ./my-project
```

### 3. Open the result

Open the generated `index.html` directly in your browser.

---

## Project Structure

```text
├── SKILL.md                         # Analysis and translation workflow
├── references/
│   ├── translation-philosophy.md    # Line-coverage and writing rules
│   ├── interactive-elements.md      # Translation rows, quizzes, and diagrams
│   ├── check.sh                     # Source-coverage checks
│   └── styles.css / main.js         # Interactive book shell
└── docs/
    ├── code-translation-demo.gif
    └── code-translation-demo.mp4
```

---

Built by [Riley Xiong](https://github.com/Jia0612)
