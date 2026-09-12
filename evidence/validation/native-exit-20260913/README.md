# Native exit diagnostic observability

Source product853a635; Blueprint mergedae79bdc64dfc2bb10ab68160b83eb06274911c7e.
Plan: docs/superpowers/plans/2026-09-13-native-exit-trace.md.
Only tests/run_tests.gd and the responsive/accessibility test gain opt-in traces.
No product, test selection/order, assertion, clock, frame, watchdog or cleanup changes.

## Exact invocations

Godot4.7.1 a13da4feb, Windows console, existing full tests/run_tests.gd, serial.

| Log | Trace setting | Exit / result |
| --- | --- | --- |
| pretrace-failed.log | unset |0xc0000005; no summary; last PASS first_session_end_to_end|
| trace-01.log |SWITCHY_TEST_TRACE=1|0;127 cases/15,701 assertions/0 failures|
| trace-02.log |SWITCHY_TEST_TRACE=1|0;127 cases/15,701 assertions/0 failures|
| default.log |unset|0;127 cases/15,701 assertions/0 failures; no trace records|

Each enabled run has127 BEGIN and127 END records; default has neither.
Test registrations match priorHEAD exactly. END means run() returned, not all
deferred engine destruction or frames finished. Logging and formatting can affect
timing; none of these passes prove native root cause or repair.

## Investigation and five-pass review

1. Repeated Windows exception0xc0000005 with earlier event offset0x321e44b;
   local minidumps exist. Dumps stay local, not uploaded or treated as source proof.
2. No debugger executable found on PATH or the installed Windows Kits Debuggers/x64
   directory (only four DLLs). No dependency install/engine or provider replacement.
3. Independent reviewer confirmed unchanged suite ordering/assertions/lifecycle,
   opt-in exact flag, no environment values disclosed, and trace maturity boundaries.
4. Verified candidate causes are only investigation leads: synchronous suite chain,
   queued gameplay cleanup, immediate scene frees, forced layout notifications.
   Existing exit cleanup does exist; no speculative cleanup rewrite.
5. Default-off invocation and two enabled complete invocations verify observability,
   not a fix. Native failure not reproduced while trace enabled in these two runs.

Next: retain opt-in trace for the next recurrence; narrow the last phase or acquire
matching native debug evidence before changing lifecycle code. Human/device/release
NOT_RUN. Project-specific diagnosis is not promoted to Base.
