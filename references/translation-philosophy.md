# Translation Philosophy (code-translation)

The contract this skill makes with the learner: **every non-empty line of the selected source files gets exactly one honest, simple-English explanation, in order, with nothing skipped.** This file defines that contract precisely, plus the writing style that makes it readable for non-native English speakers.

---

## 1. The Coverage Rule (non-negotiable)

> Every non-empty physical source line must correspond to exactly one translation row, in the same order as the original file. Blank lines are kept as visual separation and need no explanation. Comment lines are kept and their intent is translated. Source lines must never be merged, dropped, reordered, or rewritten.

"Physical line" means a line as it appears in the file — what a text editor numbers. Not a statement, not an expression.

### Edge cases, decided

| Case | Rule |
|---|---|
| Blank line | No row. May end/start a `translation-block`. |
| Comment line | One row. Translate the *intent*: "The author left a note here warning that this order matters." |
| Multi-line function signature | One row per physical line. First line gets the main explanation ("I define a function called X; the next lines list what you must give it"); each continuation line explains its own part ("…this line adds the third input: how long to wait before giving up"). |
| Multi-line string / template literal | One row per line. Explain what that piece of text is for; for long literal text, per-line rows can be short ("…the next part of the same message"). |
| Chained calls across lines | One row per line; each explains its own step of the chain ("…then I keep only the finished items"). |
| Multi-line JSX / HTML tags | One row per line; explain the attribute or child that line contributes. |
| Decorator / annotation | Normal row ("This tag above the function tells the framework to run it on every request"). |
| Class fields, constants, type definitions, config objects | Normal rows, one per line. For config objects, each line says what that setting controls in this app. |
| Module-level initialization | Normal rows ("This line runs once, when the app starts: it opens the database connection everything else will share"). |
| Structural lines: `else`, `catch`, `finally`, lone `}` / `)` / `]` | One row, short control-flow sentence: "If the check above failed, we come here instead." / "This closes the loop; everything inside repeats for each item." |
| Consecutive imports | One row each, and each must say what is *different* about it ("This one brings in the tool that talks to the file system"). Never repeat the same sentence with a swapped name. |

### What a translation row says

Explain **what this line does in this program**, not just what the syntax means. "I check whether this book was already uploaded" — not "This is an if statement." Syntax teaching belongs in syntax cards; the row stays about the program.

First-person voice, as if the code itself is speaking:

> `seen = {}` → "I prepare an empty notebook, to remember which numbers I have already seen and where."

---

## 2. Module Structure

A file module is NOT "one section per function" — real logic lives in classes, top-level code, component templates and config. Organize as:

```
File overview (2–4 sentences: what this file does for the app, and who calls it)
├── Module-level setup   (imports + top-level code, in file order)
├── Class / function / component A
├── Class / function / component B
└── Remaining top-level code
```

Each section = one `.section-header` + a short "what this block does for you" paragraph + its translation rows. Sections follow file order strictly — never group "all the helpers" together if they are not adjacent in the file.

Split files over ~300–400 non-empty lines into `File — Part 1 / Part 2` modules, cut at a class/section boundary, each with a `.part-banner`.

---

## 3. Syntax Cards & Index

- A syntax feature (e.g. `enumerate`, destructuring, `async/await`, list comprehension, optional chaining) gets ONE card in the whole course, placed at the end of the section where it FIRST appears. Card: name + 1–2 sentence what-it-is + 1–3 line mini example + "You just saw it on line N" anchor link.
- Later appearances (any module) get a glossary tooltip only.
- Each file module ends with a syntax index listing only the cards that first appeared in that module, each link resolving to a real card id.
- Track issued cards in `translation-manifest.json` (`syntaxCards`) so later batches never duplicate one.
- Don't card the trivial: `=` assignment, arithmetic, plain function calls need no card. Card the things a beginner would google: unfamiliar keywords, punctuation with hidden meaning (`...`, `?.`, `=>`, `**kwargs`), constructs with non-obvious behavior.

---

## 4. Simple English (targets, not hard rules)

The reader may not be a native English speaker. Aim for:

- Most sentences 8–18 words. One action per sentence.
- Concrete verbs: "saves", "checks", "sends" — not "facilitates", "leverages", "utilizes".
- Skip unnecessary idioms and cultural references. Common phrasal verbs ("set up", "look up", "find out") are fine — avoiding them entirely makes English stiffer.
- Technical term on first use = term + short definition in the same breath: "a *cache* (a place to keep copies so we do not fetch them again)". Then a glossary tooltip.
- Metaphors: small, physical, universal (notebook, shelf, doorway, queue at a counter). Never sports, movies, or wordplay.
- Contractions are fine ("I'm", "doesn't") — they read as friendly, not difficult.

## 5. Quizzes

- **Whole-file questions** (1–2 at module end): test whether the reader kept the plot — "which part notices a failure first?", "what would happen if X ran twice?". Wrong-answer feedback points back to the relevant section, never just "incorrect".
- **In-place question** (exactly one per module, on the hardest function): spot-the-bug pattern — "which line prevents X?", "which line would break Y if deleted?". Place it right after that function's rows.
- Questions test understanding of *this program's behavior*, never syntax trivia.

## 6. Honesty Rules

- Never invent behavior. If a line's purpose is genuinely unclear, say so plainly: "This line looks like a safety check, but the code never explains which case it guards. That is worth asking about."
- If a line is dead code or a likely bug, say that — the reader is here to build judgment.
- Keep terminology identical across all modules and batches: pick one name per concept ("the sync engine", not sometimes "the syncer") and record it in `definedTerms` in the manifest.
