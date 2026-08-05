# Interactive Elements Reference (code-translation)

HTML patterns for every element used in a translation course. This is a trimmed, adapted version of the codebase-to-course reference: group-chat animations, layer toggles, pattern cards and other course-only elements are intentionally absent — do NOT add them.

> **Architecture note:** All CSS and JS live in `styles.css` + `main.js` (copied verbatim) and `extra.css` (translation-specific additions). When writing module HTML, use only the HTML patterns below — never inline `<style>` or `<script>` tags. Engines in `main.js` auto-initialize by scanning class names and `data-*` attributes.

## Module Skeleton (required)

Every module file is exactly one `<section>` whose contents sit inside a `.module-content` wrapper (it provides the max-width column — without it, content spans the full window):

```html
<section class="module" id="module-N" data-source-lines="240" data-source-file="src/sync.js">
  <div class="module-content">
    <div class="module-header">
      <span class="module-number">02</span>
      <h1 class="module-title">sync.js</h1>
      <p class="module-subtitle">One line about what this file does.</p>
    </div>
    <!-- overview paragraphs, then screens -->
    <div class="screen"> ... </div>
  </div>
</section>
```

Wrap each code section in `<div class="screen">`; headings inside a module use `<h2 class="screen-heading">`.

## Table of Contents
1. [Translation Rows (the main element)](#translation-rows)
2. [Section Headers](#section-headers)
3. [Syntax Cards](#syntax-cards)
4. [Syntax Index](#syntax-index)
5. [Glossary Tooltips](#glossary-tooltips)
6. [Multiple-Choice Quizzes](#multiple-choice-quizzes)
7. [Spot-the-Bug-Style Comprehension Question](#spot-the-bug-style-comprehension-question)
8. [Flow Animation (Module 1 only)](#flow-animation)
9. [Visual File Tree with Coverage Tags (Module 1 only)](#visual-file-tree-with-coverage-tags)
10. [Callout Boxes](#callout-boxes)
11. [Part Banner & Source Pin](#part-banner--source-pin)

---

## Translation Rows

The core of the whole course. A 2-column grid whose direct children alternate `<pre class="tl-code">` and `<p class="tl-text">`. Grid auto-placement keeps each pair on one row, so code and its translation always line up.

**In this skill, one row = ONE non-empty physical source line** (see translation-philosophy.md for the exact coverage rules). Each row carries:
- an `id` for anchor links: `m{module}-L{lineNumber}`, e.g. `m2-L14`
- a line-number span `.tl-ln` as the first thing inside `<code>`

```html
<div class="translation-block animate-in">
  <span class="tl-label tl-label-code">CODE</span>
  <span class="tl-label tl-label-text">PLAIN ENGLISH</span>

  <pre class="tl-code" id="m2-L12"><code><span class="tl-ln">12</span><span class="code-keyword">const</span> response = <span class="code-keyword">await</span> <span class="code-function">fetch</span>(url, {</code></pre>
  <p class="tl-text">I send a request to the URL and wait for the answer. The next two lines describe the request.</p>

  <pre class="tl-code" id="m2-L13"><code><span class="tl-ln">13</span>  <span class="code-property">method</span>: <span class="code-string">'POST'</span>,</code></pre>
  <p class="tl-text">This line says I am sending data, not just asking for data.</p>

  <pre class="tl-code" id="m2-L14"><code><span class="tl-ln">14</span>  <span class="code-property">headers</span>: { <span class="code-string">'Authorization'</span>: apiKey }</code></pre>
  <p class="tl-text">This line attaches my API key, so the server knows who is asking.</p>

  <pre class="tl-code" id="m2-L15"><code><span class="tl-ln">15</span>});</code></pre>
  <p class="tl-text">This closes the request. Everything above is now sent as one package.</p>
</div>
```

**Formatting rules:**
- One `<pre class="tl-code">` per source line. Never merge lines into one `<pre>`.
- Preserve the source's real indentation as literal spaces, AFTER the `.tl-ln` span.
- Escape `<`, `>`, `&` in source code (`&lt;` `&gt;` `&amp;`) — mandatory for JSX/HTML/generics.
- Syntax-highlight spans (`.code-keyword`, `.code-string`, `.code-function`, `.code-property`, `.code-comment`) are inline and safe anywhere.
- Split long files into several `translation-block`s — one per section (see Section Headers). Do not build one giant block for a whole file.
- Blank source lines: do NOT create a row. End the current `translation-block` there if the blank line separates logical groups, or just continue — blank lines are visual separation only.

---

## Section Headers

One before each code section of a file module (module-level setup, each function/class/component, remaining top-level code).

```html
<div class="section-header" id="m2-sec-syncbooks">
  <span class="sh-kind">function</span>
  <span class="sh-name">syncBooks()</span>
  <span class="sh-lines">lines 42–98</span>
</div>
```

`sh-kind` values: `imports`, `setup`, `function`, `class`, `method`, `component`, `config`, `top-level`. Follow each header with a 1–3 sentence plain-English overview paragraph ("what this block does for you") before the translation rows.

---

## Syntax Cards

Appears once, right after the section where a syntax feature shows up for the FIRST time in the whole course. Never repeat a card for the same feature.

```html
<div class="syntax-card" id="syntax-enumerate">
  <div class="syntax-card-head">
    <span class="syntax-card-badge">Syntax</span>
    <span class="syntax-card-name">enumerate()</span>
  </div>
  <div class="syntax-card-body">
    <p>A Python helper that walks through a list and hands you two things at once: the position and the item at that position.</p>
    <pre class="syntax-card-example">for i, name in enumerate(names):
    print(i, name)   # 0 Alice, 1 Bob, ...</pre>
    <p class="syntax-card-context">You just saw it on <a href="#m2-L43">line 43</a>.</p>
  </div>
</div>
```

- `id` must be `syntax-{slug}` — the syntax index links to it.
- The context link points at the `tl-code` row id where the feature first appeared.
- Keep the explanation to 1–2 short sentences + a 1–3 line mini example.

---

## Syntax Index

At the end of each file module, list every syntax card that first appeared in THAT module. Cards from earlier modules are not repeated here.

```html
<div class="syntax-index">
  <h3 class="syntax-index-title">Syntax that first appeared in this file</h3>
  <ul>
    <li><a href="#syntax-enumerate">enumerate()</a> <span class="si-desc">— walk a list with positions</span></li>
    <li><a href="#syntax-fstring">f-strings</a> <span class="si-desc">— build text with values inside</span></li>
  </ul>
</div>
```

Every `href` must resolve to a real `syntax-card` id (check.sh verifies this).

---

## Glossary Tooltips

Wrap every technical term on FIRST use per module. Second and later uses of a syntax feature also get a tooltip instead of a new card.

```html
<p>The extension uses a
  <span class="term" data-definition="A service worker is a background script that keeps running even when you are not looking at the page.">service worker</span>
  to handle API calls.
</p>
```

> **⚠️ Straight double quotes inside `data-definition` truncate the tooltip.** The attribute is delimited by `"`, so an inner `"` ends it early and the tooltip silently shows only the first half. Use curly quotes (“ ”), rephrase, or `&quot;`. Check every definition before shipping.

Rules: 1–2 everyday-language sentences; a small metaphor is welcome; don't mark the same term twice in one module.

---

## Multiple-Choice Quizzes

Used for the 1–2 whole-file questions at the end of each file module. `main.js` exposes `selectOption(btn)`, `checkQuiz(id)`, `resetQuiz(id)`.

```html
<div class="quiz-container" id="quiz-module2">
  <div class="quiz-question-block"
       data-correct="option-b"
       data-explanation-right="Exactly — the retry loop in syncBooks() is what notices the failure first."
       data-explanation-wrong="Not quite. Scroll back to the retry loop in syncBooks() and check what it watches for.">
    <h3 class="quiz-question">If the server stops answering, which part of this file notices first?</h3>
    <div class="quiz-options">
      <button class="quiz-option" data-value="option-a" onclick="selectOption(this)">
        <div class="quiz-option-radio"></div>
        <span>The import section</span>
      </button>
      <button class="quiz-option" data-value="option-b" onclick="selectOption(this)">
        <div class="quiz-option-radio"></div>
        <span>The retry loop in syncBooks()</span>
      </button>
      <button class="quiz-option" data-value="option-c" onclick="selectOption(this)">
        <div class="quiz-option-radio"></div>
        <span>The config object at the top</span>
      </button>
    </div>
    <div class="quiz-feedback"></div>
  </div>

  <button class="quiz-check-btn" onclick="checkQuiz('quiz-module2')">Check Answers</button>
  <button class="quiz-reset-btn" onclick="resetQuiz('quiz-module2')">Try Again</button>
</div>
```

Quiz container ids must be unique across the whole course (`quiz-module2`, `quiz-module2-b`, ...).

> **⚠️ main.js prefixes feedback with "Exactly!" / "Not quite."** — so never begin `data-explanation-right` with "Exactly"/"Right" or `data-explanation-wrong` with "Not quite", or the user sees "Exactly! Exactly. …". Start explanations directly with the substance.

---

## Spot-the-Bug-Style Comprehension Question

The single in-place question for the hardest function of a module. Reuse the bug-challenge pattern, but the question can be broader than a literal bug: "which line would break X if deleted?", "which line makes this safe to run twice?".

```html
<div class="bug-challenge">
  <h3>Which line stops the same book from being uploaded twice?</h3>
  <div class="bug-code">
    <div class="bug-line" onclick="checkBugLine(this, false)">
      <span class="line-num">51</span>
      <code>for (const book of books) {</code>
    </div>
    <div class="bug-line bug-target" onclick="checkBugLine(this, true)">
      <span class="line-num">52</span>
      <code>  if (uploaded.has(book.id)) continue;</code>
    </div>
    <div class="bug-line" onclick="checkBugLine(this, false)">
      <span class="line-num">53</span>
      <code>  await upload(book);</code>
    </div>
  </div>
  <div class="bug-feedback" id="bug-feedback-m2"></div>
</div>
```

Give each `.bug-feedback` a unique id. Escape `<` `>` `&` in the `<code>` content.

---

## Flow Animation

Module 1 only — the course "table of contents in motion". Each station corresponds to one file module (2–8 modules: one station per file; 9+: group by subsystem). If the project has no runtime data flow (e.g. a utility library), present it honestly as a call/dependency flow, not a "data flow".

`main.js` auto-initializes every `.flow-animation`. Steps go in `data-steps` as JSON; actor ids must be `flow-actor-1`, `flow-actor-2`, ...

> **⚠️ Single quotes in step labels break parsing.** `data-steps='[...]'` is delimited by single quotes; an apostrophe inside a label terminates the attribute and the whole animation dies silently. Avoid apostrophes or use `&apos;`.

```html
<div class="flow-animation" data-steps='[
  {"highlight":"flow-actor-1","label":"The CLI reads your command"},
  {"highlight":"flow-actor-2","label":"parser.js turns it into a task","packet":true,"from":"actor-1","to":"actor-2"},
  {"highlight":"flow-actor-3","label":"runner.js does the work","packet":true,"from":"actor-2","to":"actor-3"}
]'>
  <div class="flow-actors">
    <div class="flow-actor" id="flow-actor-1"><div class="flow-actor-icon">⌨️</div><span>cli.js · Module 2</span></div>
    <div class="flow-actor" id="flow-actor-2"><div class="flow-actor-icon">🔍</div><span>parser.js · Module 3</span></div>
    <div class="flow-actor" id="flow-actor-3"><div class="flow-actor-icon">⚙️</div><span>runner.js · Module 4</span></div>
  </div>
  <div class="flow-packet" id="flow-packet"></div>
  <div class="flow-step-label" id="flow-label">Click "Next Step" to begin</div>
  <div class="flow-controls">
    <button class="btn flow-next-btn">Next Step</button>
    <button class="btn flow-reset-btn">Restart</button>
    <span class="flow-progress"></span>
  </div>
</div>
```

Label each actor with its file name AND its module number, so the animation doubles as the table of contents.

---

## Visual File Tree with Coverage Tags

Module 1 only — the repository map. Translated files get a tag linking them to their module; skipped files are dimmed with a reason.

```html
<div class="file-tree">
  <div class="ft-folder open">
    <span class="ft-name">src/</span>
    <span class="ft-desc">All the real logic lives here</span>
    <div class="ft-children">
      <div class="ft-file">
        <span class="ft-name">sync.js</span><span class="ft-tag ft-tag-translated">Module 2</span>
        <span class="ft-desc">The heart: keeps local and cloud data equal</span>
      </div>
      <div class="ft-file ft-skipped">
        <span class="ft-name">constants.js</span><span class="ft-tag ft-tag-skipped">skipped</span>
        <span class="ft-desc">Just a list of fixed values — nothing to explain</span>
      </div>
    </div>
  </div>
  <div class="ft-file ft-skipped">
    <span class="ft-name">package.json</span><span class="ft-tag ft-tag-skipped">skipped</span>
    <span class="ft-desc">The project&#8217;s shopping list of tools</span>
  </div>
</div>
```

---

## Callout Boxes

Max 2 per module. Use for universal CS insights that this file happens to demonstrate.

```html
<div class="callout callout-accent">
  <div class="callout-icon">💡</div>
  <div class="callout-content">
    <strong class="callout-title">Key Insight</strong>
    <p>This file never trusts its input. Checking data before using it is called "validation", and it is why this app rarely crashes.</p>
  </div>
</div>
```

Variants: `callout-accent` (insights), `callout-info` (good to know), `callout-warning` (common mistakes).

---

## Part Banner & Source Pin

**Part banner** — at the top of each module that covers a slice of a split file:

```html
<span class="part-banner">sync.js — Part 2 of 2 · lines 241–480</span>
```

**Source pin** — in Module 1, pin the exact version the course was built from:

```html
<p class="source-pin">Built from <code>github.com/user/repo</code> at commit <code>a1b2c3d</code> · 2026-08-03</p>
```
