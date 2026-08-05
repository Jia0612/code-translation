---
name: code-translation
description: "Translate a codebase's core files line by line into simple English, as a beautiful interactive single-page HTML 'translation book'. Use when someone wants a line-by-line plain-language translation of code — trigger on 'translate this repo', 'line-by-line translation', 'code translation', '逐行翻译', '把这个仓库翻译成大白话', or a GitHub link + any 'translate' request. BOUNDARY: if the user asks to 'make a course' / '做成课程' / 'teach me this codebase', use codebase-to-course instead — that skill teaches selected highlights with architecture modules; THIS skill exhaustively translates every non-empty line of user-selected core files. Same look and feel as the -to-course family."
---

# Code-Translation

Turn a GitHub repo (or local folder) into an interactive, scroll-based HTML book that translates the core source files **line by line** into simple English — like a LeetCode solution walkthrough, but for a real codebase. The user picks which files get translated; every non-empty line of a picked file gets exactly one first-person, plain-English explanation.

Output is a **directory** (same architecture as codebase-to-course): pre-built `styles.css` + `main.js` + `extra.css`, per-module HTML files, `build.sh` assembling `index.html`. Opens in a browser with zero setup (only external dependency: Google Fonts CDN).

## First-Run Welcome

If the skill triggers without a target codebase, introduce yourself:

> **I can translate a codebase into simple English, line by line — every line of the core files, explained in plain words.**
>
> Point me at a project:
> - **A GitHub link** — "translate https://github.com/user/repo line by line"
> - **A local folder** — "translate ./my-project"
> - **The current project** — "translate this repo"
>
> I'll analyze the repo, show you which files hold the core logic, let you pick which ones to translate, then build an interactive HTML book: a big-picture overview, then each picked file translated line by line, with syntax cards, tooltips, and small quizzes.

## Audience & Voice

Same learner as codebase-to-course: a vibe coder with zero assumed CS background who wants to *read* code, not write it. Two extra constraints here:

1. **All course content is English**, written for non-native readers — see the Simple English targets in `references/translation-philosophy.md`. (Converse with the user in whatever language they use; only the HTML output is English.)
2. Translations use **first-person voice** — the code speaks: "I prepare an empty notebook, to remember which numbers I have already seen."

The contract with the reader is **exhaustive honesty**: nothing in a picked file is skipped, merged, or hand-waved. `references/translation-philosophy.md` defines the coverage rule precisely — read it before writing any module.

---

## The Process

### Phase 1: Analyze & Pin

1. **Get the source.** GitHub URL → `git clone` into the scratchpad directory. Local path → use in place.
2. **Pin the version immediately:** `git rev-parse HEAD` (note if the tree is dirty; note "not a git repo" + today's date otherwise). This SHA goes into the manifest, the ledger, and Module 1's source pin.
3. **Understand the repo** (read README, entry points, trace the main flow) well enough to write the Module 1 overview and to judge which files are core.
4. **Build the candidate list.** Default-exclude: `node_modules`/`vendor`, lockfiles, generated files, minified bundles, build output, tool-generated migrations, snapshots, fixtures, large data/config blobs. For each remaining candidate record: path, one-sentence "why it's core" (or "supporting"), and non-empty line count (`grep -cve '^[[:space:]]*$' file`).

### Phase 2: Let the User Pick

Present candidates with **AskUserQuestion (multiSelect: true)** — each option = `path (N lines)` with the why-it's-core sentence as description. Put core-logic files first; excluded-by-default categories can be surfaced in a follow-up option ("show me config/generated files too") since some projects' core genuinely lives there.

**Batch limits (quality guardrails, tell the user when they bite):**
- Single batch: **600–800 non-empty lines**. If the selection exceeds this, translate the most important files now and queue the rest as a next batch.
- Single file module: **≤ 300–400 non-empty lines**. Longer files split into `File — Part 1 / Part 2` modules at class/section boundaries.
- Whole project: ~1500 non-empty lines is the suggested ceiling — beyond that, warn that returns diminish and recommend stopping at the true core.

### Phase 3: Set Up the Course Directory

Output dir: `~/Desktop/Codebase/<repo-name>-translation/`.

1. Copy verbatim (Read + Write, never regenerate): `references/styles.css`, `main.js`, `extra.css`, `_footer.html`, `build.sh`.
2. Customize `references/_base.html` → `_base.html`: `COURSE_TITLE`, the four `ACCENT_*` values (pick one palette from its comments), `NAV_DOTS` (one button per module).
3. Create `translation-manifest.json` from `references/manifest-template.json` — source, commit, selected files, planned modules.
4. Create `briefs/coverage-ledger.md` from `references/coverage-ledger-template.md` — one row per file/part with real line counts. This is the number check.sh will enforce.

### Phase 4: Write Modules

Read `references/translation-philosophy.md` (coverage + writing rules) and `references/gotchas.md` first; consult `references/interactive-elements.md` for HTML patterns.

**Module 1 — The Big Picture** (`modules/01-overview.html`):
- What this app/library does, in simple English (3–5 short paragraphs max)
- Source pin (repo + commit SHA + date)
- **Flow animation as table of contents**: stations = the file modules, labeled `file.js · Module N`. 2–8 modules: one station per file; 9+: group by subsystem. No real runtime flow (e.g. a utility library)? Present a call/dependency flow and say so honestly.
- **File-tree map with coverage tags**: translated files link to their module (`ft-tag-translated`), skipped files dimmed with a one-line reason (`ft-skipped`).
- Glossary tooltips on technical terms. **No group-chat animation, no quiz in Module 1.**

**File modules** (`modules/NN-slug.html`, one per picked file or part):
- `<section class="module" id="module-N" data-source-lines="240" data-source-file="src/sync.js" data-source-range="1-310">` — these three data attributes power check.sh's coverage verification. `data-source-lines` = non-empty lines from the ledger; `data-source-range` = physical line range (omit for whole files).
- Structure per `translation-philosophy.md`: file overview → sections in strict file order (module-level setup / each class-function-component / remaining top-level), each with a `.section-header`, an overview paragraph, and translation rows.
- **One row per non-empty source line**, id `m{N}-L{lineNumber}`, line-number span, real indentation, escaped `<` `>` `&`.
- Syntax cards on first appearance (course-wide — consult the manifest's `syntaxCards`), syntax index at module end, tooltips for repeats.
- Quizzes: 1–2 whole-file questions at the end + one in-place question on the hardest function.
- Part modules open with a `.part-banner`.

**Parallel path** (3+ file modules): write a brief per module from `references/module-brief-template.md` into `briefs/`, then dispatch to subagents in batches of up to 3. Each agent gets: its brief (with the complete source slice pasted in), `translation-philosophy.md`, `gotchas.md`, and the `interactive-elements.md` sections its brief lists — never the repo itself. Sequential path for 1–2 modules: just write them in order.

### Phase 5: Assemble & Verify

```bash
cd course-dir && bash build.sh && bash check.sh /path/to/source/checkout
```

(Copy `references/check.sh` into the course dir alongside build.sh during Phase 3.)

check.sh enforces: exact row-count per module vs `data-source-lines` (and vs the real source when the checkout path is passed), ascending unique line ids, nav-dots ↔ module ids, all internal anchors resolve, unique HTML ids, `data-steps` JSON parses, quiz wiring complete, no unescaped tags inside code rows, no leftover placeholders, tooltip-truncation heuristics.

**A red check is a bug — fix the module and re-run until green.** Then mark the file Verified in the coverage ledger. Only after green: open `index.html` in the browser, walk through every module, and present to the user.

### Phase 6: Adding a Batch Later

Never "just append". The manifest drives a rebuild:

1. Read `translation-manifest.json`. Verify the source commit still matches (`git rev-parse HEAD`); if it changed, warn the user and let them decide (re-pin vs translate the old commit).
2. Continue module numbering from `modules`; skip syntax cards in `syntaxCards` and reuse the exact wording of `definedTerms`.
3. Write the new file modules, then **rebuild the shared parts**: `_base.html` nav dots, Module 1's flow animation + file-tree tags (newly translated files flip from skipped to translated), and re-run `build.sh` + `check.sh`.
4. Update manifest + ledger.

---

## Design Identity

Identical to codebase-to-course — warm off-white palette, one bold accent, Bricolage Grotesque + DM Sans + JetBrains Mono, dark IDE-style code blocks, alternating module backgrounds. See `references/design-system.md`. New translation-specific components (line numbers, syntax cards/index, coverage tags, part banners, source pin) are styled in `extra.css` — **never edit `styles.css` or `main.js`; put any new style in `extra.css`.**

## Reference Files

Read only when the phase needs them:

- **`references/translation-philosophy.md`** — the coverage contract (what counts as one line, every edge case), module structure, syntax-card rules, Simple English targets, quiz principles, honesty rules. Read before Phase 4.
- **`references/interactive-elements.md`** — HTML patterns: translation rows, section headers, syntax cards/index, tooltips, quizzes, flow animation, file tree, callouts, banners. Phase 4.
- **`references/gotchas.md`** — known failure points (tooltip quote truncation, data-steps apostrophes, double-spacing). Phases 4–5.
- **`references/design-system.md`** — visual tokens. Phase 4.
- **`references/module-brief-template.md`**, **`manifest-template.json`**, **`coverage-ledger-template.md`** — Phase 3/4 scaffolding.
- **`references/check.sh`** — copied into every course dir; run in Phase 5.
