# Native exit isolation plan

Parent main: 97ea477b80e4be4002f5ba5d2fbbfbab12685b83 (PR299 merged, five CI checks green).
Scope: diagnose the existing intermittent Windows access violation; no engine upgrade,
provider migration, gameplay change, or automatic retry-as-success policy.

## Observations and hypothesis

- Postmerge full run terminated with -1073741819 after first_session_end_to_end PASS,
  before responsive_accessibility PASS. No final summary: UNVERIFIED full run.
- Same bytes with existing SWITCHY_TEST_TRACE=1: 129 cases, 16039 assertions, exit0.
  This is a successful subsequent observation, NOT a crash fix.
- Local historical dump PID8436: exception C0000005, Godot executable offset321E44B.
  No symbols/debugger available. This module address does not identify a source function.
- Hypotheses to distinguish: isolated responsive test lifecycle versus cumulative suite
  state versus native environmental/timing behavior. Do not infer any from test adjacency alone.

## Research / feasibility

Godot primary issue https://github.com/godotengine/godot/issues/122367 documents a
native lifetime failure pattern, not a diagnosis of this project. ADOPT object lifetime
inspection; REJECT assuming all access violations share that issue's cause.
Existing runner provides trace and existing tests are synchronous RefCounted cases.
Use a bounded diagnostic runner for only the two adjacent test scripts, retaining
all original assertions. No change to the full acceptance runner or product semantics.

## Steps

- [x] Run each adjacent case alone repeatedly, then the pair; log begin/end and exit code.
- [ ] Compare evidence before a source correction. A passing isolated run is not proof
  of a fix and never replaces the full regression.
- [x] Preserve failed full-run log and exact successful trace; keep private dumps local.
- [x] Inspect all validated findings across consumer/lifecycle, scope, layout,
  provenance and evidence-ceiling passes; independent review before any delivery.
- [x] Recheck actual editor separately from synthetic/headless evidence (live run10).
- [ ] Recheck exact Windows executable; editor startup is not exported-package proof.
- [x] Update current context with observed result and next safe investigation.

No runtime fix is proposed yet. Existing user files and unrelated PRs remain untouched.
