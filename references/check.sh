#!/bin/bash
# check.sh — deterministic structure & coverage checks for a code-translation course.
# Run from the course directory AFTER build.sh:   bash check.sh [path/to/source/checkout]
# Exit code 0 = all green. Any FAIL line = fix before showing the user.
#
# Coverage contract: every <section class="module"> for a file module MUST carry
# data-source-lines="N" (N = non-empty source lines from the coverage ledger).
# If a source checkout path is passed as $1, counts are also re-derived from the
# real files via data-source-file / data-source-range attributes when present.

set -u
SRC_DIR="${1:-}"

python3 - "$SRC_DIR" <<'PYEOF'
import json, re, sys, os, glob
from html.parser import HTMLParser

src_dir = sys.argv[1] if len(sys.argv) > 1 else ""
fails, warns = [], []

def fail(msg): fails.append(msg)
def warn(msg): warns.append(msg)

if not os.path.exists("index.html"):
    print("FAIL: index.html not found — run build.sh first, from the course directory")
    sys.exit(1)
html = open("index.html", encoding="utf-8").read()

# ---------- 1. leftover template placeholders (ignore HTML comments — they don't render) ----------
html_no_comments = re.sub(r"<!--.*?-->", "", html, flags=re.S)
for ph in ["COURSE_TITLE", "ACCENT_COLOR", "ACCENT_HOVER", "ACCENT_LIGHT",
           "ACCENT_MUTED", "NAV_DOTS", "MODULE_N_NAME", "MODULE_1_NAME"]:
    if ph in html_no_comments:
        fail(f"placeholder '{ph}' still present in index.html")

# ---------- 2. module files contain only <section class="module"> ----------
for mf in sorted(glob.glob("modules/*.html")):
    body = open(mf, encoding="utf-8").read().strip()
    if not re.match(r'<section\s[^>]*class="[^"]*\bmodule\b', body):
        fail(f"{mf}: does not start with <section class=\"module\">")
    if not body.endswith("</section>"):
        fail(f"{mf}: does not end with </section>")
    for bad in ["<html", "<head", "<body", "<style", "<script", "<!DOCTYPE"]:
        if bad in body:
            fail(f"{mf}: contains forbidden tag '{bad}'")

# ---------- parse index.html ----------
class P(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.ids = []                 # (id, approx line)
        self.hrefs = []               # internal #anchors
        self.nav_targets = []
        self.section_ids = []
        self.sections = []            # dicts: id, source_lines, file, range
        self.cur_section = None
        self.tl_rows = 0
        self.datasteps = []
        self.quiz_containers = {}     # id -> {"blocks":[(correct, [values])], "check_ids":[]}
        self.cur_quiz = None
        self.cur_block = None
        self.in_pre_depth = 0
        self.bad_attrs = []
        self.defs = []                # data-definition values

    def handle_starttag(self, tag, attrs):
        d = dict(attrs)
        line = self.getpos()[0]
        for (k, v) in attrs:
            if not re.fullmatch(r"[a-zA-Z][a-zA-Z0-9:._-]*", k or ""):
                self.bad_attrs.append(f"line {line}: suspicious attribute name '{k}' on <{tag}> (broken quoting?)")
        cls = (d.get("class") or "").split()
        if "id" in d:
            self.ids.append((d["id"], line))
        href = d.get("href") or ""
        if href.startswith("#") and len(href) > 1:
            self.hrefs.append((href[1:], line))
        if "nav-dot" in cls and d.get("data-target"):
            self.nav_targets.append(d["data-target"])
        if tag == "section" and "module" in cls:
            self.cur_section = {"id": d.get("id", "?"), "line": line,
                                "source_lines": d.get("data-source-lines"),
                                "file": d.get("data-source-file"),
                                "range": d.get("data-source-range"),
                                "rows": 0, "row_ids": []}
            self.sections.append(self.cur_section)
            self.section_ids.append(d.get("id", "?"))
        if tag == "pre" and "tl-code" in cls:
            self.in_pre_depth = 1
            if self.cur_section is not None:
                self.cur_section["rows"] += 1
                if "id" in d:
                    self.cur_section["row_ids"].append(d["id"])
        elif self.in_pre_depth:
            if tag not in ("code", "span", "a"):
                self.bad_attrs.append(f"line {line}: unexpected <{tag}> inside tl-code (unescaped source?)")
        if d.get("data-steps") is not None:
            self.datasteps.append((d["data-steps"], line))
        if "quiz-container" in cls:
            qid = d.get("id")
            if not qid:
                fail_local = f"line {line}: quiz-container without id"
                self.bad_attrs.append(fail_local)
            self.cur_quiz = {"blocks": [], "check_ids": []}
            self.quiz_containers[qid or f"?line{line}"] = self.cur_quiz
        if "quiz-question-block" in cls and self.cur_quiz is not None:
            self.cur_block = {"correct": d.get("data-correct"), "values": [], "line": line}
            self.cur_quiz["blocks"].append(self.cur_block)
        if "quiz-option" in cls and self.cur_block is not None:
            self.cur_block["values"].append(d.get("data-value"))
        oc = d.get("onclick") or ""
        m = re.search(r"checkQuiz\('([^']+)'\)", oc)
        if m and self.cur_quiz is not None:
            self.cur_quiz["check_ids"].append(m.group(1))
        if d.get("data-definition") is not None:
            self.defs.append((d["data-definition"], line))

    def handle_endtag(self, tag):
        if tag == "pre" and self.in_pre_depth:
            self.in_pre_depth = 0

p = P()
p.parse_error = None
p.feed(html)

# ---------- 3. unique ids ----------
seen = {}
for i, line in p.ids:
    if i in seen:
        fail(f"duplicate HTML id '{i}' (lines {seen[i]} and {line})")
    else:
        seen[i] = line

# ---------- 4. nav dots <-> module sections ----------
if sorted(p.nav_targets) != sorted(p.section_ids):
    fail(f"nav-dot targets {sorted(p.nav_targets)} != module section ids {sorted(p.section_ids)}")

# ---------- 5. internal anchors resolve ----------
idset = set(seen)
for anchor, line in p.hrefs:
    if anchor not in idset:
        fail(f"line {line}: link '#{anchor}' has no matching id")

# ---------- 6. data-steps JSON ----------
for s, line in p.datasteps:
    try:
        json.loads(s)
    except Exception as e:
        fail(f"line {line}: data-steps is not valid JSON ({e}) — check for single quotes in labels")

# ---------- 7. quizzes ----------
for qid, q in p.quiz_containers.items():
    for b in q["blocks"]:
        if not b["correct"]:
            fail(f"quiz '{qid}' (line {b['line']}): question block missing data-correct")
        elif b["correct"] not in b["values"]:
            fail(f"quiz '{qid}' (line {b['line']}): data-correct '{b['correct']}' matches no option data-value")
    if q["check_ids"] and qid not in q["check_ids"]:
        fail(f"quiz '{qid}': checkQuiz targets {q['check_ids']}, not this container's id")

# ---------- 8. suspicious attributes / unescaped code ----------
for msg in p.bad_attrs:
    fail(msg)

# ---------- 9. tooltip truncation heuristic ----------
for text, line in p.defs:
    if len(text.strip()) < 15:
        warn(f"line {line}: data-definition suspiciously short ('{text[:40]}') — truncated by an inner straight quote?")

# ---------- 10. coverage: rows vs source lines, order ----------
for s in p.sections:
    label = f"section '{s['id']}'"
    if s["source_lines"] is None:
        if s["rows"] > 0:
            warn(f"{label}: has {s['rows']} translation rows but no data-source-lines attr — coverage not verifiable")
        continue
    expected = int(s["source_lines"])
    if s["rows"] != expected:
        fail(f"{label}: {s['rows']} translation rows, expected {expected} (data-source-lines)")
    nums = []
    for rid in s["row_ids"]:
        m = re.fullmatch(r"m\d+[a-z]?-L(\d+)", rid)
        if m: nums.append(int(m.group(1)))
    if nums != sorted(nums):
        fail(f"{label}: translation row line numbers are not in ascending order")
    if len(set(nums)) != len(nums):
        fail(f"{label}: duplicate line numbers in row ids")
    # re-derive from real source when available
    if src_dir and s["file"]:
        path = os.path.join(src_dir, s["file"])
        if not os.path.exists(path):
            warn(f"{label}: source file {path} not found — skipped re-derivation")
        else:
            lines = open(path, encoding="utf-8", errors="replace").read().splitlines()
            if s["range"]:
                a, b = s["range"].split("-"); lines = lines[int(a)-1:int(b)]
            nonempty = sum(1 for l in lines if l.strip())
            if nonempty != expected:
                fail(f"{label}: data-source-lines={expected} but source actually has {nonempty} non-empty lines")

# ---------- report ----------
for w in warns: print("WARN:", w)
if fails:
    for f_ in fails: print("FAIL:", f_)
    print(f"\n{len(fails)} failure(s), {len(warns)} warning(s).")
    sys.exit(1)
print(f"All checks passed ({len(p.sections)} modules, {sum(s['rows'] for s in p.sections)} translation rows). {len(warns)} warning(s).")
PYEOF
