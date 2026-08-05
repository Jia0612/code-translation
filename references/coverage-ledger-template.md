# Coverage Ledger

The quality evidence for "strictly line-by-line". Create at `course-dir/briefs/coverage-ledger.md` BEFORE writing any module HTML; update the Verified column after check.sh passes. One table row per selected file (or file part).

Source: `<github url or local path>`
Commit: `<sha>` (dirty: yes/no · or "not a git repo, generated <date>")

| File | Physical lines | Non-empty lines | Included line range | Excluded within range (generated/vendored, with reason) | Module | Verified |
|---|---|---|---|---|---|---|
| src/sync.js | 310 | 240 | 1–310 | — | 02 | ☐ |
| src/parser.js — Part 1 | 520 | 410 | 1–260 | lines 30–45: auto-generated schema block (noted in module, not translated) | 03 | ☐ |

Rules:
- "Non-empty lines" is the number check.sh will compare against the module's translation-row count. Compute it with: `grep -cve '^[[:space:]]*$' <file>` (restricted to the included range for file parts).
- Any excluded stretch inside an included range must be listed here AND visibly noted in the module ("lines 30–45 are machine-generated; I skip them and say why"). Silent gaps are bugs.
- A file is Verified (☑) only after check.sh confirms row count and order for its module.
