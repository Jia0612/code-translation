# Module Brief — [NN]-[slug]

Write one brief per file module at `course-dir/briefs/NN-slug.md` when dispatching modules to parallel subagents. The brief must let an agent write the module WITHOUT reading the repository.

## Identity
- Module id: `module-N` · Output file: `modules/NN-slug.html`
- Source file: `src/whatever.js` (Part X of Y, lines A–B) — commit `<sha>`
- Non-empty line count for this module (agent must produce exactly this many translation rows): **NNN**

## File overview (2–4 sentences the agent can adapt)
What this file does for the app, who calls it, where it sits in the Module 1 flow ("you are here").

## Section plan (in file order)
1. `imports` — lines 1–12
2. `function` `syncBooks()` — lines 14–75 · **hardest function: yes → gets the in-place question**
3. `top-level` — lines 77–90

## Source (choose ONE)
- **Path form (preferred when the checkout is on local disk):** absolute path to the source file + included line range. The agent Reads exactly that file, nothing else in the repo.
  `Source file path: /abs/path/to/checkout/src/whatever.js · lines 1–310`
- **Paste form (when agents can't reach the checkout):** the COMPLETE included range, verbatim with line numbers. Never summarize it.
```
1  import { db } from './db.js'
2  ...
```

## Syntax cards to issue in this module
- `syntax-asyncawait` — async/await — first appears line 14
(Cards already issued in earlier modules — tooltip only, do NOT re-card): `syntax-import`, ...

## Terms already defined in earlier modules (tooltip only, keep identical wording)
- "the sync engine" = ...

## Quizzes
- Whole-file question idea(s): ...
- In-place question (hardest function): which line / what behavior to ask about

## Neighbors (for transitions)
- Previous module covers: ... · Next module covers: ...

## References the writing agent needs
- `translation-philosophy.md` (all)
- `interactive-elements.md`: sections Translation Rows, Section Headers, Syntax Cards, Syntax Index, Glossary Tooltips, Multiple-Choice Quizzes, Spot-the-Bug, Callouts
- `gotchas.md`
