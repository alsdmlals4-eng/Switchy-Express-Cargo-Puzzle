# Exported PCK twelve-stage completion verification

## Scope, plan and authority

2026-09-13 continuation, baseline main9525f734fe18d16368712af30262c7460941575f.
Work Mode: bounded verification improvement. Project router/design and Base review
modes: contract-check, runtime-validation, regression, claim-and-intent-verification.
Compatibility v9.4.3 retained; observed Base main d830c0f6967678eed3c208ac6b24f9cd1b262ec3.
Current AGENTS/Decisions/Active Context and real consumers override historical Candidate010.
Protected PR174/254/281 read-only; 216 pre-existing local tracked changes preserved.

Plan presented before implementation: reuse the existing Main/Product completion driver,
make its authored test input available externally, run all twelve stages against unchanged
PR305 PCK, reject no-pickup, compare package hashes, review and regress, normal PR/main readback.
No new product rules, assets, scenes, export settings, provider migration or release decision.
The user requested no routine approval stops within approved implementation/verification scope.

## Research / feasibility comparison

- ADOPT: existing authored witnesses and actual Main -> book selection -> BUILD -> START ->
  LOAD/AUTO/BOARD_CELL commands. Keep speed2.0, accelerated0.05 steps, 5,000-step bound,
  real RESULT/SUCCESS/cargo/next-action/terminal-HUD assertions; never inject the outcome.
- ADAPT: [Godot command-line documentation](https://docs.godotengine.org/en/latest/tutorials/editor/command_line_tutorial.html)
  permits an absolute external script and main pack. Resolve only authored fixture beside
  the runner; production Main/catalog/definition/maps/resources stay res:// in mounted PCK.
- ADAPT: [FileAccess export guidance](https://docs.godotengine.org/en/4.6/classes/class_fileaccess.html)
  warns that exported resources can be converted. Hash the whole PCK, external test inputs
  and readable runtime map JSON; do not invent hashes for absent source GDScript/scene text.
- REJECT: embedding tests in shipping export or overlaying product resources. No overlay,
  copied game code, new solution UI, source asset or additional game content was introduced.
- New genre research NOT_MATERIAL: no design/balance/player behavior changes in this unit.

Initial pack check-only exit1 reproduced missing res://tests fixture/test-class preloads.
After adaptation, pack check-only exit0. This is tooling dependency RED->GREEN, not a
new game defect. Later identity diagnostic exposed empty pack_path: the engine consumed
--main-pack before script argument inspection. Explicit caller identity replaced that
assumption. An intermediate chat attributed this to a hash typo; that explanation was
withdrawn after instrumentation. No product repair or hash mismatch was demonstrated.

## Exact launch and identity

PowerShell, cwd C:/Users/user/Downloads/Switchy_Playable_20260913_PR305:

```powershell
$pack = 'C:/Users/user/Downloads/Switchy_Playable_20260913_PR305/SwitchyExpressVerticalSlice.pck'
$hash = (Get-FileHash $pack).Hash.ToLower()
$runner = 'C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle/.worktrees/codex-core-preserved-replan-20260910/tests/runtime/route_book_completion_window_runner.gd'
& 'C:/Users/user/Downloads/Godot_v4.7.1-stable_win64.exe/Godot_v4.7.1-stable_win64_console.exe' --main-pack $pack --script $runner -- "pack-sha256=$hash" "pack-path=$pack"
# Same launch with trailing no-pickup is the semantic negative control.
```

PCK57885664bytes SHA256:
`3bd6993fba9dc52d27ea310fee9e2e7140832cf1a848cb1b36babc7220fb25cd`.
Same before/after. Package product source remains PR305/a6f6fb2; prior artifact provenance
is in ../pilot-byte-contract-20260913/READBACK.md. This task never rebuilds/rewrites it.
The identity assertion is caller-supplied: receipt alone cannot authenticate mounted bytes.
Recorded --main-pack and pack-path are the SAME absolute path, with direct OS hash readback.

## Observed verification

- positive.json / positive.log: editor-mounted exported PCK twelve SUCCESS, exit0,
  actual960x540 OpenGL rendering, all cargo resolved, proper next-button boundaries.
- RB01-result.png through RB12-result.png are actual final-run captures, not generated art.
- negative.json / negative.log: same pack, no-pickup -> RB01 FAILURE; expected SUCCESS and
  cargo-resolution assertions fail; nonzero exit1. This is expected rejection, not PASS gameplay.
- checkout.json: unchanged driver use through --path . and res:// runner still twelve SUCCESS,
  exit0; separate CHECKOUT_MAIN evidence and output directory.
- Wrong hash: nonzero1/package identity failure. Missing identity: nonzero1/consumer mismatch.
- Checkout falsely labelled pack: nonzero1/consumer mismatch. Headless: nonzero1/window required,
  preventing indefinite frame_post_draw wait in an unsupported renderer.
- Full Python with GODOT_BINARY:309passed1skipped. The optional GODOT_BIN test stays skipped;
  an earlier tests/python-only invocation without engine env was280passed3skipped, not the full run.
- Project operating contract PASS. Full Godot129cases/16133assertions, failed0, exit0.
  All twelve retained capture hashes matched positive.json after copying into this owner.

## Five-pass review and independent review

1. Scope/consumer: only test driver changed; production res:// source stays mounted pack.
2. Rule/input: original witnesses, speed, command path, finite outcomes and negative control retained.
3. Visual/provenance: actual captures at960x540; no new image candidate or approval; no absent-source hashes.
4. Failure/compatibility: checked RED missing dependencies, wrong/missing identity, checkout mismatch,
   headless rejection, normal pack and normal checkout, bounded simulation and before/after hash.
5. Evidence/cleanup: pack vs checkout vs EXE vs human separated; protected changes excluded;
   receipt/launch pairing mandatory, no claim of final release. No deletion or Base promotion.

Independent read-only reviewer: Critical0/Important0/Minor0, exact runner raw SHA
ba2b396b99bcfa513a41984f363980f79f9b431b327e4b20ad24dc09f443da97.
Reviewed catalog ordering/fixture dependencies/guards/real command flow/hash boundaries.
Reviewer did not run runtime; the parent executed the runs recorded above.

## Evidence ceiling / remaining risk

This closes the pack BUILD-only vs checkout SUCCESS gap for these exact twelve authored
witnesses. It is EDITOR_MOUNTED_EXPORTED_PCK, not twelve-stage native template EXE play,
human-paced difficulty/UX/listening approval, physical accessibility or public release.
Existing Linux Pilot transient and separate frame-shutdown warning observations are unchanged.
No new approved product implementation gap identified by this bounded check.
Rollback: revert only this test-driver/evidence delta through a normal PR; package unchanged.
Current required runtime captures are retained; incidental logs already reside in the
user-delete holding folder, with no automatic deletion or unknown worktree cleanup.

Normal integration and post-merge readback owner:
[PR308](https://github.com/alsdmlals4-eng/Switchy-Express-Cargo-Puzzle/pull/308).
Only that PR's exact-head required checks and merged/main readback establish integration;
the local runtime records above do not independently claim a merge.
