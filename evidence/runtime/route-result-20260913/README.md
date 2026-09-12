# Route Book result truth — 2026-09-13

Problem: the non-tutorial result path mislabeled ROUTE_END as time expiry and
hardcoded Korean summary/actions. Common FirstSessionCopy now projects exact
reason/count/time/cost/history, with generic unknown failure. No core semantics,
new scoring, auto loading, station rule, or approved art change.

Research: ADAPT [Microsoft error message guidance](https://learn.microsoft.com/en-us/windows/win32/debug/error-message-guidelines)
and [Xbox XAG115](https://learn.microsoft.com/en-us/gaming/accessibility/xbox-accessibility-guidelines/115):
describe the real condition and provide recovery. REJECT misleading generic
time-expiry cause; no claim of Xbox compliance. Existing Railbound/Trainyard
comparison remains the prior preview/retry-loop evidence, not new research here.

Actual standalone Main at960x540: four locales run authored RB08 layout without
pickup input until actual RESULT; no injected summary. All show ROUTE_END with
2 ground cargo,0 train cargo,6.3 elapsed and108.7 seconds remaining. Captures were
visually read in all4 locales; result buttons remain in bounds. BodyScroll holds
remaining metrics. Background gameplay HUD localization is still separate work.

Machine display RED: corrected full128 cases,1 failed,15835 assertions,exit1.
Initial GREEN display134 assertions passed but full invocation exited0xc0000005;
traced repeat stopped after responsive test's `product instantiate` marker, before
`product attached`. This bounds but does not identify the native fault. The marker
also precedes definition loading and stage policy application. No native fix claimed.

Independent five-pass review covered truth/scope,locale,tutorial isolation,layout,
evidence. Corrected missing TitleButton locale and added actual T2-hidden→book-visible
Edit transition regression. Final current display suite has146 assertions.

Preview144-case/3-pointer matrix rerun after flow delta; receipt source_revision
identifies merge base3530fbb94add7dc41a1c0a2c4485d4b5f1114f75, while recorded source
hashes bind the working delta. Neither receipt is an exact-commit runtime claim.
Human, native root cause, downloaded release-package execution, rights and release
remain unverified. Current logs are retained alongside this receipt.

Final corrected full regression:128 cases,15850 assertions,0 failures,exit0
(`route-result-verified.log`). Python305 passed/1 skipped; project contract PASS.
74-page derived PDF: no empty pages, no text blocks outside page bounds.
The successful invocation does not erase two earlier native exits. One intermediate
completed regression found only the old `완료 시간` expectation; it was updated to
the deliberately factual `경과 시간` and rerun in full. No assertions removed.
