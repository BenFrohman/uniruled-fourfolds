#!/usr/bin/env python3
# Copyright (c) 2026 Benjamin Stanley Frohman. Licensed under Apache-2.0.
"""Truth Gate static checks (see TRUTH_GATE.md). Exit code 0 only if every check passes.
 0. The lock is certifying.
 1. TRUTH_GATE.lock parses and names existing files.
 2. The lock region of the semantics file declares formal_claim_X, paper_claim_X and
    intended_correspondence_X for every claim X; no correspondence is proved by rfl; no
    paper_* definition mentions a formal_claim or a repository Prop listed in the lock.
 3. The lock region sha256 equals the recorded hash (the claims are fixed).
 4. The paper sha256 equals the recorded hash, every quoted block occurs verbatim
    (whitespace-normalised) in the paper and in TRUTH_GATE.md.
 5. Whole paper: every theorem/proposition/lemma/corollary label of the paper is covered by a
    claim, and every claim names a label that exists in the paper.
 6. No sorry / admit / native_decide / axiom declaration in ANY tracked .lean file
    (git ls-files; comments and string literals ignored). No file is exempt."""
import hashlib, json, os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(ROOT)
FAIL = []

def fail(msg):
    FAIL.append(msg); print("TRUTH GATE FAIL: " + msg)

def norm(s):
    return re.sub(r"\s+", " ", s).strip()

def strip_comments_strings(src):
    out, i, n, depth = [], 0, len(src), 0
    while i < n:
        if depth > 0:
            if src.startswith("/-", i): depth += 1; i += 2; continue
            if src.startswith("-/", i): depth -= 1; i += 2; continue
            if src[i] == "\n": out.append("\n")
            i += 1; continue
        if src.startswith("/-", i): depth = 1; i += 2; continue
        if src.startswith("--", i):
            j = src.find("\n", i); i = n if j < 0 else j; continue
        if src[i] == '"':
            j = i + 1
            while j < n and src[j] != '"':
                j += 2 if src[j] == "\\" else 1
            out.append('""'); i = j + 1; continue
        out.append(src[i]); i += 1
    return "".join(out)

if not os.path.isfile("TRUTH_GATE.lock"):
    fail("TRUTH_GATE.lock missing"); sys.exit(1)
lock = json.load(open("TRUTH_GATE.lock", encoding="utf-8"))
need = ["semantics_file", "semantics_module", "audit_file", "paper_path", "paper_sha256", "claims",
        "main_theorems", "paper_labels", "paper_forbidden_names", "lock_region_sha256", "certifying"]
for k in need:
    if k not in lock: fail(f"TRUTH_GATE.lock lacks key {k}")
if FAIL: sys.exit(1)
if lock["certifying"] is not True:
    fail("the lock is not certifying")
if not lock["claims"] or len(lock["claims"]) != len(lock["main_theorems"]):
    fail("claims and main_theorems must be non-empty and of equal length")

for k in ["semantics_file", "audit_file", "paper_path"]:
    if not os.path.isfile(lock[k]): fail(f"{k} {lock[k]} missing")
if FAIL: sys.exit(1)

src = open(lock["semantics_file"], encoding="utf-8").read()
m = re.search(r"^-- TRUTH-GATE LOCK BEGIN\n(.*?)^-- TRUTH-GATE LOCK END\n", src, re.S | re.M)
if not m:
    fail("lock region markers missing"); sys.exit(1)
region = m.group(1)
code = strip_comments_strings(region)
TRIVIAL = {"Iff.rfl", "rfl", "by rfl", "by exact Iff.rfl", "by exact rfl", "by apply Iff.rfl",
           "by constructor <;> exact id", "⟨id, id⟩", "Iff.intro id id", "by exact ⟨id, id⟩",
           "by simp", "by decide", "by trivial", "by tauto"}
for c in lock["claims"]:
    for decl in [rf"def\s+formal_claim_{c}\s*:\s*Prop\s*:=", rf"def\s+paper_claim_{c}\s*:\s*Prop\s*:=",
                 rf"theorem\s+intended_correspondence_{c}\s*:\s*formal_claim_{c}\s*↔\s*paper_claim_{c}\s*:="]:
        if not re.search(decl, code): fail(f"lock region lacks `{decl}`")
    cm = re.search(rf"theorem\s+intended_correspondence_{c}\s*:\s*formal_claim_{c}\s*↔\s*paper_claim_{c}\s*:=(.*?)(?=^(?:theorem|def|lemma)\b|\Z)", code, re.S | re.M)
    if cm:
        body = norm(cm.group(1))
        if body in TRIVIAL or re.fullmatch(r"(by\s+)?(exact\s+)?(Iff\.)?rfl", body) or \
           (re.search(r"(?<![\w.'])(Iff\.rfl|rfl)(?![\w'])", body) and len(body) < 40):
            fail(f"intended_correspondence_{c} is proved trivially (`{body}`)")
for pm in re.finditer(r"^def\s+(paper_\w+)\b(.*?)(?=^(?:theorem|def|lemma|abbrev)\b|\Z)", code, re.S | re.M):
    pbody = pm.group(2)
    if re.search(r"(?<![\w.'])([\w.]*\.)?formal_claim\w*(?![\w'])", pbody):
        fail(f"{pm.group(1)} mentions a formal_claim (vacuous alias)")
    for fn in lock["paper_forbidden_names"]:
        if re.search(rf"(?<![\w'])([\w]+\.)*{re.escape(fn)}(?![\w'])", pbody):
            fail(f"{pm.group(1)} names the repository Prop {fn} instead of transcribing the paper")
got = hashlib.sha256(region.encode("utf-8")).hexdigest()
if got != lock["lock_region_sha256"]:
    fail(f"lock region sha256 {got} != locked {lock['lock_region_sha256']} (a new lock needs the author's sign-off)")

pp = lock["paper_path"]
h = hashlib.sha256(open(pp, "rb").read()).hexdigest()
if h != lock["paper_sha256"]: fail(f"paper sha256 {h} != locked {lock['paper_sha256']}")
for tag in [f"PAPER_SHA256: {lock['paper_sha256']}", f"PAPER_PATH: {pp}"]:
    if tag not in src: fail(f"semantics file does not record `{tag}`")
if not re.search(r"^PAPER_SECTION: \S", src, re.M): fail("semantics file lacks PAPER_SECTION:")
tg = open("TRUTH_GATE.md", encoding="utf-8").read() if os.path.isfile("TRUTH_GATE.md") else ""
if not tg: fail("TRUTH_GATE.md missing")
elif lock["paper_sha256"] not in tg or pp not in tg: fail("TRUTH_GATE.md does not record the paper path and sha256")
tex = open(pp, encoding="utf-8", errors="replace").read()
paper = norm(tex)
quotes = re.findall(r"PAPER_QUOTE_BEGIN\n(.*?)\nPAPER_QUOTE_END", src, re.S)
if not quotes: fail("no PAPER_QUOTE_BEGIN/END block")
for q in quotes:
    if norm(q) not in paper: fail("quote not verbatim in the paper: " + norm(q)[:100])
    if norm(q) not in norm(tg): fail("quote not verbatim in TRUTH_GATE.md: " + norm(q)[:100])

# 5. whole paper
envs = re.findall(r"\\begin\{(theorem|proposition|lemma|corollary)\}(.*?)\\end\{\1\}", tex, re.S)
labels = set()
for kind, body in envs:
    lm = re.search(r"\\label\{([^}]*)\}", body)
    if not lm: fail(f"a {kind} environment of the paper has no label, so no claim can cover it"); continue
    labels.add(lm.group(1))
    if not any(norm(body) in norm(q) for q in quotes): fail(f"{kind} {lm.group(1)} is not quoted in the semantics file")
covered = set(lock["paper_labels"].get(c, "") for c in lock["claims"])
for l in sorted(labels - covered): fail(f"paper statement {l} is not covered by any locked claim (partial lock)")
for l in sorted(covered - labels): fail(f"locked label {l} does not occur in the paper")
print(f"TRUTH GATE STATIC: {len(envs)} paper statements {sorted(labels)}; {len(lock['claims'])} claims {lock['claims']}")

# 6. forbidden tokens in every tracked Lean file
files = [f for f in subprocess.check_output(["git", "ls-files", "*.lean"]).decode().splitlines() if f]
if not files: fail("git ls-files lists no .lean file (vacuous scan)")
tok = re.compile(r"(?<![\w.'])(sorry|admit|native_decide)(?![\w'])|^\s*(?:@\[[^\]]*\]\s*)?(?:(?:private|protected|public|noncomputable|unsafe)\s+)*axiom\s", re.M)
bad = 0
for f in files:
    c2 = strip_comments_strings(open(f, encoding="utf-8").read())
    for mm in tok.finditer(c2):
        fail(f"forbidden token `{mm.group(1) or 'axiom'}` at {f}:{c2.count(chr(10), 0, mm.start()) + 1}"); bad += 1
print(f"TRUTH GATE STATIC: scanned {len(files)} tracked .lean files (git ls-files, none exempt); {bad} forbidden tokens")

if FAIL:
    print(f"TRUTH GATE STATIC FAIL ({len(FAIL)} problems)"); sys.exit(1)
print("TRUTH GATE STATIC PASS")
