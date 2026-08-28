# SX-INC-062-001 · Package Evidence and Asset-Count Reconciliation

Status: `RESOLVED_FOR_CURRENT_PACKAGE_RECORD · HUMAN_GATES_NOT_RUN`

## Incident

`73` had been repeated as if it were the total image count of a current package. Fresh exact-main inspection instead found 79 tracked product PNGs and 79 product PNG imports in the `main@8bce715b5045afebfb04d38108d2e3f7353e1b10` Candidate 003 PCK.

## Evidence

| Observation | Source | Result |
|---|---|---|
| semantic asset manifests | SX-DEC-053 baseline 39 + SX-DEC-054 RUN 20 + BUILD 8 + VFX 6 | 73 semantic PNGs |
| runtime-presentation set | title, terrain, lesson, T2 lesson, success result, failure result | 6 PNGs outside that semantic subtotal |
| tracked project-local PNGs | exact `git ls-files` inventory | 79 total |
| Candidate 003 PCK | `tools/verify_godot_pck_integrity.py` | 495/495 verified; 79 product PNG imports and 79 referenced CTEX; no missing or orphan reference |
| package proofs | exact Windows Demo Export run `33159213393` | Windows + Android runtime JSON `PASS · parsed_json=27` |

Candidate 002's `73/73` record remains historical package evidence for its own exact bytes. It is not rewritten to represent the later Candidate 003 package.

## Solution

- Keep `73 semantic PNGs` as a valid category label.
- Record `6 runtime-presentation PNGs` and `79 tracked product PNGs total` alongside it whenever the current full package is discussed.
- Bind Candidate 003 to the actual 79/79 PCK crosscheck; do not create assets or change consumers to resolve a documentation category mismatch.

## Secondary validation boundary

The local NoLaunch launcher could not run in this task shell because `Get-FileHash` is unavailable there. Independent downloaded ZIP/EXE/PCK hashes and PCK integrity verification succeeded. GitHub Actions Windows runner run `33161335690` then completed exact Candidate 003 `-NoLaunch` verification with `SX60-POC-ACCEPT-003 PACKAGE VERIFICATION: PASS (NoLaunch)`. This resolves the machine gate without creating any physical, audio, Android, or human evidence.

## Lesson / Base promotion

`NO_BASE_PROMOTION`: the distinction depends on this project's semantic-manifest taxonomy, its six runtime-presentation consumers, and its Godot package contents. The reusable lesson is already covered by the Base requirement to distinguish structured canon from runtime/package evidence; no project-specific count belongs in Base.
