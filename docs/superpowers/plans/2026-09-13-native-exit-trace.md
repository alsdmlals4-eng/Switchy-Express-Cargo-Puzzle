# Native full-run exit: bounded diagnostic plan

Source product main853a635; documentation PR294 independently pending.
Observed repeated0xc0000005, no summary, last PASS first_session_end_to_end.
Windows faults share executable offset0x321e44b; minidumps exist but symbol-level
cause is unknown. Do not infer a gameplay/renderer fix from this offset.

## Research and feasibility

Official Godot debugging documentation recommends debugger-backed diagnosis:
https://docs.godotengine.org/en/stable/engine_details/development/debugging/
Command-line --headless / --log-file already preserve per-invocation output.
ADOPT exact logs and failure boundaries. ADAPT opt-in GDScript traces for the
existing custom full runner. REJECT engine replacement, disabling tests, automatic
retry-as-PASS, provider migration, or unproven Container lifecycle changes.

## Ordered implementation

1. Preserve current failure invocation as RED evidence of incomplete observability.
2. Add opt-in SWITCHY_TEST_TRACE=1 records before/after each existing suite and
   within responsive/accessibility scene lifecycle phases. Trace only; no await,
   branch/order/assertion/timeout changes and no environment value dumping.
3. Execute the existing full runner serially with trace and exact log.
   A successful run does not fix a native failure; a failed run's last boundary
   narrows investigation. Reproduce before any corrective runtime patch.
4. Verify default trace remains off and all assertions/tests remain registered.
   Review scope/lifetime/semantic/diagnostic/evidence risks; document exact results.
5. Normal branch PR/checks/merge; preserve separate PRs and existing user changes.

Next decisions depend on actual trace evidence. Native root cause remains open
until proven; core, assets, engine/provider pins and release gates are unchanged.

## Execution result

Two enabled full runs and one default-off run each completed127 cases/15,701
assertions/0 failures. Enabled runs produce127 BEGIN/END pairs; default produces0.
Five-pass independent review found no blocking delta. Trace can affect timing;
native cause remains unresolved, so no speculative runtime fix was attempted.
Exact logs/limitations: evidence/validation/native-exit-20260913/README.md.
