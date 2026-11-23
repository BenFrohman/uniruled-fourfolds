#!/usr/bin/env python3
# Copyright (c) 2026 Benjamin Stanley Frohman. Licensed under Apache-2.0.
"""Read every line of a full `lake build` log and FAIL on:
  - an empty log (a check that read nothing is not a check);
  - any line containing `sorry` (e.g. "declaration uses 'sorry'", sorryAx) or `error:`;
  - any built module of a tracked .lean file (git ls-files; .olean present after the build)
    that the log does not show as built in this run, so an up-to-date no-op log cannot pass.
There is no exclusion list. Usage: check_build_log.py <build.log>"""
import os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(ROOT)
if len(sys.argv) != 2:
    sys.exit("usage: check_build_log.py <build.log>")
lines = open(sys.argv[1], encoding="utf-8", errors="replace").read().splitlines()
bad = [f"{sys.argv[1]}:{i}: {l.strip()}" for i, l in enumerate(lines, 1)
       if re.search(r"sorry", l, re.I) or re.search(r"\berror:", l)]
if not lines:
    bad.append("empty build log (vacuous check)")
built = set(m.group(1) for l in lines for m in [re.search(r"Built ([\w.«»]+)", l)] if m)
mods = []
for f in subprocess.check_output(["git", "ls-files", "*.lean"]).decode().splitlines():
    rel = f[:-5]
    if os.path.isfile(os.path.join(".lake/build/lib/lean", rel + ".olean")):
        mods.append(rel.replace("/", "."))
if not mods:
    bad.append("no tracked .lean file has a built module (vacuous check)")
for m in mods:
    if m not in built:
        bad.append(f"module {m} is not shown as built in this log")
if bad:
    print("BUILD LOG FAIL:\n" + "\n".join(bad)); sys.exit(1)
print(f"BUILD LOG PASS: read all {len(lines)} lines; 0 sorry, 0 errors; {len(mods)} modules built in this run: {', '.join(sorted(mods))}")
