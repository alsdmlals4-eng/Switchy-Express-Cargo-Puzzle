# Route Book result truth and localization

Observed in actual consumer demo_flow_controller._update_result_copy:
non-tutorial/Route Book failure always says time expired, ignoring ROUTE_END,
and result summary/action labels are partly hardcoded Korean.
Current finite summary already exposes the true failure reason and remaining cargo.

Research: ADAPT Microsoft's primary error-message guidance (do not use one generic
message for known distinct causes), and XAG115 clear nature of errors. These inform
feedback, not certification or a new game rule.
https://learn.microsoft.com/en-us/windows/win32/debug/error-message-guidelines
https://learn.microsoft.com/en-us/gaming/accessibility/xbox-accessibility-guidelines/115
Preserve Trainyard-style self-discovery: disclose actual failure facts, not a solver.

Chosen structure: reuse existing FirstSessionCopy common result keys for outcome,
remaining cargo and Retry/Edit. Add only missing metric/unknown-reason labels to
that same owner in four locales. A Route Book-specific presentation path retains
existing time/cost/unload facts and never applies tutorial edit-lock policy.
Unknown failure must remain generic failure, not fabricated time expiry.
No scoring, outcome priority, map, timer, cost or save schema changes.

1. RED test Route Book ROUTE_END/TIME_EXPIRED/SUCCESS/unknown in all four locales,
   retained metrics and Retry/Edit visibility, plus standalone fallback ROUTE_END.
2. Implement localized factual result projection from existing summary/controller.
3. Full regression; actual no-pickup route-end run and localized result captures;
   repeat preview source-bound QA after consumer change.
4. Five-pass review/correction; update current owners and derived Blueprint;
   normal PR/checks/merge/post-merge. Native diagnostic remains separate.

Execution: shared non-first-session fallback is the scoped consumer, not a new
Route Book subsystem. TitleButton locale and actual T2→book Edit restoration added
after independent review. RED128/1/15835; final GREEN128/0/15850 exit0.
Actual4-locale no-pickup RB08 and preview144/3 regression PASS; Python305/1skip.
Native failure logs retained; no engine fix. PDF74 pages with current result capture.
