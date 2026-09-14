# D2 undo-boundary diagnosis

Current task follows PR312/main5309829b, preserving game/art/package/vendor pins.
Approved plan: docs/superpowers/plans/2026-09-14-pilot-undo-recurrence.md.
Work mode: bounded tool diagnosis; project routing/contract PASS; Base d830c0f6 read-only,
historical v9.4.3 compatibility unchanged. AgentMemory tools unavailable; current Git
owners, not recalled session claims, supplied authority. Hera status showed urban-legend,
so no unrelated editor was used or changed. Existing isolated Switchy Pilot is the consumer.

## Observed failure and selected approach

PR312 Linux run34851361078 attempt1 failed dirty_undo; attempt2 unchanged passed.
No change to game or Pilot separated those runs. Original failure is retained in PR312
and Downloads/Switchy_Playable_20260914_RouteBook03/ci-pilot-first-failure.
REUSE existing Pilot/receipt pipeline. Compared passive boundary snapshots (selected:
minimal bounded evidence), continuous editor event tracing (defer until boundary evidence
needs finer chronology), external debugger tracing (defer, greater setup/perturbation).
Official sources: https://docs.godotengine.org/en/stable/classes/class_editorundoredomanager.html
and https://docs.godotengine.org/en/stable/classes/class_undoredo.html.
ADOPT scene-specific history readback; REJECT arbitrary waits/history clearing/vendor repin.

## Implementation and tests

Existing plugin now records before/immediate-after/next-frame snapshots around the same
single undo and existing one-frame await. Original success/restore criteria unchanged.
Snapshot includes root/scene/history identity, action/version/count, boolean membership,
disk hash, scan/unsaved states and monotonic times. Early return before undo may contain
only the before snapshot; missing root/history/undo is inferable, not fabricated phases.
No scene text, absolute user path, secrets or extra mutation in snapshots.

Actual runtime test first failed solely because all3 snapshots were absent (RED).
Independent review strengthened all3 key/type/hash/identity/time assertions; no assumed
cross-platform scanning/version values. First instrumented editor PASS had outer
SOURCE_INTEGRITY_FAILURE because the hub was edited during source inventory protection.
That failed run is preserved, not waived. Reran with no source edits: actual test PASS.
Separate durable Windows runner PASS,131/17040 regression, protected346file integrity PASS.
General Python311PASS/1optional skip; actual optional Windows test separately PASS.

receipt.json binds platform/UTC/base+delta hashes and both JSON hashes. windows-runner.json
is the complete successful report. Its legacy source_commit is scene-baseline identity,
not current Git HEAD; its fixed windows_runtime NOT_RUN is not an OS detector. This proves
Windows headless editor, NOT native window/physical input. windows-editor.json is retained
earlier inner PASS only, with outer failure explicitly recorded in companion and raw log.

Windows result: version2→1, action0→-1, immediate original target restoration, root/history/
disk hash stable, scanning=true at all phases. Scanning or unsaved=true alone therefore
does not establish a cause. Original intermittent Linux failure remains NOT_ROOT_CAUSED.
Remote Linux run34854014384 at exact head8ed2748ae106cce3278a52c72c9f5c6c677677a4
also passed the complete runner. Artifact10351722957 is preserved as linux-runner.json,
SHA256 0cdcbdd330a5d2365824b0e3adebe157dc6c0ad2b2b6ce4299fe93afb4127819.
The Linux trace also shows version2→1/action0→-1 and immediate target restoration,
with scanning=true and unsaved=true throughout. Its unchanged scene hash is the LF
canonical hash c5f69f957b462a916d424f4487bfc6025901b9254a5425623619952562623f62;
Windows raw CRLF bytes differ as already bound in receipt.json. These successful
traces establish instrumentation coverage, not a root cause or a flake repair.
Normal final-head CI/merge/readback remain next. Raw pytest padding is preserved
with a whitespace exception scoped only to this evidence directory's logs.

Learning: freeze protected owner files during isolated source-integrity validation;
diagnostic evidence must bind full attempt/source/platform, not only inner PASS.
Project-only learning; no Base promotion or new game assets. Rollback is this scoped diff,
not vendor/history replacement. Existing user changes and other PRs preserved.
