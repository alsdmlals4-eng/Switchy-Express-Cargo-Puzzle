# Windows native exit isolation — NOT_FIXED

Product source: merged main97ea477b80e4be4002f5ba5d2fbbfbab12685b83.
Engine: Windows Godot4.7.1 official a13da4feb; console launcher.
Current216 local dirty imports/settings are preserved. This is a linked-checkout
observation, not a claim that every local file equals a clean export.

## Executed sequence

| Log | Diagnostic source state | Observation / process exit |
| --- | --- | --- |
| hud-complete-postmerge.log | merged source | stops after first_session_end_to_end PASS; -1073741819; no summary |
| native-trace-20260913.log | same source, SWITCHY_TEST_TRACE=1 |129/16039 summary; exit0 |
| native-responsive-isolated.log | new bounded runner, original case bytes |10 repeats/2380 assertions; exit0 |
| native-pair-isolated.log | same runner, original case bytes |4 pairs complete; iteration5 responsive begins then -1073741819 |
| native-e2e-isolated.log | same runner, original case bytes |iteration1 completes; iteration2 begins then -1073741819 |
| native-e2e-phase.log | same runner, finer trace-only E2E case instrumentation |10 repeats/210 assertions; exit0; NOT a fix |

Exit codes were read from the launching shell, not inferred from truncated logs.
The original end-to-end case bytes are available at the product source above;
the current git diff adds only conditional trace markers. Logging changes timing,
so the later passing run cannot be treated as an identical-condition experiment.

Each repetition reuses one SceneTree in one process; there is no intervening frame.
This mirrors the synchronous acceptance runner's style, not ordinary player timing
or independent process startups. All original case assertions remain intact.
The bounded runner accepts only end_to_end/responsive/pair and1..30 repeats.
It is NOT wired as an acceptance substitute and does not retry a failed process.

## Native / editor observations

Historical local PID8436 minidump: exceptionC0000005 at executable module offset321E44B.
This is NOT the newly reproduced process's dump. No source symbols/call stack were
available; a module address does not identify the faulting source function.
Private memory dumps remain local and are not uploaded or embedded in GitHub.
Official4.7.1 release asset inventory has Android native symbols, no Windows PDB asset.
No engine replacement, debugger installation, permission or registry change was made.

Correct Switchy editor session restarted autosave=false, live run10/no launch errors.
Game readback: res://game/main/main.tscn, TITLE, ko, exact linked project path.
This startup observation is separate from native reliability, screenshot/UX and release.

## Five review passes and independent review

1. Consumer/lifecycle: only two actual existing tests; no mocked gameplay or product fix.
   Latest BEGIN/END boundaries are observations, not proven faulting functions.
2. Scope: no core, asset, persistence, provider or unrelated PR mutation.
3. Presentation: trace instrumentation only; prior HUD screenshot evidence is unchanged.
4. Provenance: original failed logs retained; old dump distinguished; no private dump upload.
5. Evidence: successful repeat never overwrites failure; logs with no summary remain UNVERIFIED.

Independent read-only reviewer reviewed diagnostic source and selected isolation log records, found no blocking
diagnostic implementation issue, and required the instrumentation/timing and
same-process caveats above. Reviewer did not rerun Godot concurrently.

## Next safe investigation

Reduce tutorial lifecycle reproduction further with source-bound per-stage traces;
compare frame-boundary cleanup to the synchronous harness as a diagnostic variable,
not an unproven production fix. Obtain a faulting stack if a suitable local free
debugger is available. Continue package and product-speed stage checks separately.
Whole game NOT_COMPLETE; native cause NOT_IDENTIFIED; human/release NOT_RUN.
