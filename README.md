# Code Translation

**Turn any codebase into an interactive, line-by-line translation book—so you can read real code without a computer science background.**

## The Problem

Architecture diagrams and high-level summaries can tell you what a project does, but they do not help when you open a real source file and cannot understand the code in front of you. Generic AI explanations often skip lines, merge several ideas together, or assume you already know the syntax.

## The Solution

Code Translation is a [Claude Code](https://claude.com/claude-code) skill that turns the core files of a GitHub repository or local project into an interactive HTML book. You choose the files, and the skill translates **every non-empty line** into simple, first-person English beside the original code.

It begins with the big picture, then walks through each selected file in order with syntax cards, glossary tooltips, small quizzes, and automated coverage checks. The result is a self-contained learning experience that opens directly in your browser.

![Claude Code](https://img.shields.io/badge/Claude_Code-Skill-D97757?logo=anthropic&logoColor=white) ![HTML](https://img.shields.io/badge/Output-Interactive_HTML-E34F26?logo=html5&logoColor=white) ![Zero Setup](https://img.shields.io/badge/Translation_Book-Zero_Setup-2E8B57)

[![Code Translation demo](docs/code-translation-demo.gif)](docs/code-translation-demo.mp4)

[Watch the full demo video](docs/code-translation-demo.mp4)

---

## Features

- **Line-by-line translation** — every non-empty line in each selected file gets one plain-English explanation
- **Code that speaks for itself** — translations use first-person language, such as “I store the actual number inside myself”
- **Core-file discovery** — analyzes the repository and explains which files contain the important logic before you choose
- **Big-picture map** — starts with the project flow and shows how the selected files work together
- **Code ↔ plain English view** — keeps the original source and its explanation side by side
- **Just-in-time syntax help** — introduces classes, functions, operators, and other concepts only when they appear
- **Interactive learning** — includes flow animations, glossary tooltips, syntax cards, and small quizzes
- **Version pinning** — records the exact source commit so every explanation stays tied to the code it describes
- **Coverage verification** — checks line counts, ordering, links, IDs, quiz wiring, and unresolved placeholders before the book ships
- **Static output** — produces a standalone HTML folder with no build step or server required

---

## How It Works

### User Flow

```text
Give Code Translation a GitHub repo or local folder
                         ↓
         Analyze the project and pin its version
                         ↓
      Review the core files and choose what to read
                         ↓
  Translate every non-empty line into simple English
                         ↓
 Build and verify the interactive translation book
                         ↓
              Open index.html and learn
```

### The Translation Pipeline

| Phase | What It Does |
|---|---|
| **1 — Analyze** | Reads the repository, traces the main flow, pins the source commit, and identifies the core files. |
| **2 — Select** | Shows each candidate file with its line count and role so you can choose what gets translated. |
| **3 — Translate** | Creates a big-picture overview, then explains every non-empty line of the selected files in strict source order. |
| **4 — Teach** | Adds syntax cards, glossary tooltips, flow animations, and quizzes for a zero-background reader. |
| **5 — Verify** | Runs automated checks against the original source to confirm coverage and interaction integrity. |

---

## Quick Start

### 1. Install the skill

Clone this repository into your Claude Code skills directory:

```bash
git clone https://github.com/Jia0612/code-translation.git ~/.claude/skills/code-translation
```

### 2. Ask Claude Code to translate a project

Use a GitHub repository:

```text
Translate https://github.com/karpathy/micrograd line by line
```

Use a local project:

```text
Translate ./my-project
```

Or translate the current repository:

```text
Translate this repo
```

### 3. Choose the files

Code Translation analyzes the project and presents the core files with their roles and line counts. Select the files you want to understand.

### 4. Open the result

The generated book is saved under:

```text
~/Desktop/Codebase/<repo-name>-translation/
```

Open `index.html` directly in your browser. No installation, server, or build command is required.

---

## What the Generated Book Contains

```text
<repo-name>-translation/
├── index.html                    # Complete interactive translation book
├── styles.css                    # Shared visual system
├── main.js                       # Navigation, quizzes, and interactions
├── extra.css                     # Translation-specific components
├── translation-manifest.json     # Source commit, selected files, and modules
├── briefs/
│   └── coverage-ledger.md        # Line counts and verification status
└── modules/
    ├── 01-overview.html          # Big picture and project flow
    ├── 02-<core-file>.html       # First translated file
    └── ...
```

---

## Translation Rules

Code Translation follows a strict coverage contract:

1. Every non-empty source line gets exactly one translation row.
2. Files are translated in their original order.
3. Code is never silently skipped, merged, or paraphrased away.
4. Explanations use simple English written for non-native readers.
5. The code speaks in first person so each line clearly states what it does.
6. Generated examples and quizzes never replace the original source.
7. Automated checks compare the output with the pinned checkout before completion.

---

## Code Translation vs. a Codebase Course

A codebase course teaches selected architectural ideas and important code highlights. Code Translation serves a different purpose: it helps you **read the source itself** by exhaustively translating every non-empty line of the files you selected.

Use a course when you want the main concepts. Use Code Translation when you want to open a real file and understand what each line is doing.

---

## Honest Limits

- You choose the files to translate; the skill does not translate an entire large repository by default.
- A single batch is limited to roughly 600–800 non-empty lines to protect explanation quality.
- Very long files are split into multiple modules at logical boundaries.
- Generated translation books are written in English, although you can talk to Claude Code in any language.
- The generated pages work offline except for optional Google Fonts.

---

## Project Structure

```text
├── SKILL.md                         # Complete workflow and operating rules
├── references/
│   ├── translation-philosophy.md    # Coverage contract and writing rules
│   ├── interactive-elements.md      # Reusable HTML component patterns
│   ├── design-system.md             # Visual tokens and layout rules
│   ├── gotchas.md                   # Known failure modes
│   ├── check.sh                     # Automated source-coverage checks
│   ├── build.sh                     # Assembles the final HTML book
│   └── styles.css / main.js         # Prebuilt course shell
└── docs/
    ├── code-translation-demo.gif
    └── code-translation-demo.mp4
```

---

Built by [Riley Xiong](https://github.com/Jia0612)
