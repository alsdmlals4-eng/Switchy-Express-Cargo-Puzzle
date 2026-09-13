# Exported Route Book consumer readback

## Product and actual artifact

PR299 artifact10308281108 / run34727597446, source merge-refaab01161100b65a913df59c76458413d53e0e140.
Source tree136e6cea3a5fe93270325fc9423072f9ec780a6d equals merged97ea477 tree.
Later PR300/main37f1575 contains diagnostic-only changes, not new gameplay bytes.
Four downloaded hashes matched the CI SHA256SUMS; no local export substituted.

- EXE:1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
- PCK:c66305774a879ab1b12a3d978a93f2e79c003eb283614dad4ffe1922474a8d07
- Current external verifier raw SHA256:e6ebd72aa5d76adc60c6d557c20c2bfdc992798c7a8ad73efe1b069761dc25c4

Actual EXE ran120frames headless(exit0) and real-window(exit0, OpenGL3.3/NVIDIA RTX3050).
Logs: pr299-package-startup.log and pr299-package-window.log. Window startup was not
visually captured in this unit; do not promote it to a screenshot or user UX approval.
Playable folder:C:/Users/user/Downloads/Switchy_Playable_20260913_PR299.

## Actual mounted PCK consumer

The editor binary4.7.1 mounted the downloaded PCK from outside the project checkout
and ran the current external verifier. pr299-mounted-routebook-final.log records
2 books,12 unique stages,12 actual shell BUILD entries, correct map identities; exit0.
Book definitions/maps use current loaders; all four locale title/objective/context
values are data-validated. Actual BUILD entry uses defaultko, NOT four-locale window QA.

An earlier attempt to run --script through the export template EXE did not execute
the verifier; its startup-only process was stopped after exact PID/path verification.
CLI help identifies --script as editor/debug-tool functionality. That attempt is NOT
counted as consumer proof; only the mounted editor-engine log above is counted.

## Regression and failure proof

RED: real old verifier returned only parsed_json31 and omitted Route Book marker;
the new subprocess test failed as intended. GREEN: actual2/12/12 consumer marker.
Negative fixture overlays one malformed book JSON through a tiny PCK in a separate
process. Real loader rejects it with exit1; setup/mount errors are separate exit3.
No checkout JSON is modified. Both subprocess tests PASS after fresh resource import.
Python full:308passed/1skipped. Custom suite:129cases/16039assertions/exit0.
These observations do NOT fix the intermittent nativeC0000005 retained separately.

## Five-pass and independent review

1. Consumer: inspect actual catalog, loader, copy and shell map identity; no mocked entry.
2. Scope: no stage/rule/filter/art/save/provider change. Existing JSON already exported.
3. Presentation: ko BUILD entry only; locale data presence not translation or visual quality.
4. Provenance: source tree and artifact hashes; package not claimed to contain the new verifier.
5. Failure: malformed real overlay fails closed; no PASS after failures; native risk retained.

Independent read-only review found no blocking finding. Its watchdog caveat led to
external60s timeout around CI proof-pack invocations; the in-engine30s timer alone
cannot interrupt a synchronous native hang. No human, device, rights or release PASS.

First exact PR301 export CI run34728976100 failed exit124 at its historical45s full
suite limit, despite printing129/0/16039. Same-head headless job34728976064 passed
under its existing180s limit; its separate pilot recorded full regression44.362705s.
Export/Android full-suite limits now match that existing180s owner budget. No tests,
error checks or nonzero handling were removed; proof-pack timeout remains60s.
This corrects an obsolete time-budget mismatch, not the Windows native fault.
The failed CI run remains visible; fresh exact-head export evidence is required.

## Cleanup and remaining work

Final PR301 head57d31dc136123a47db7e717ce133bb65ff6d118e: five checks SUCCESS.
Export run34729215777 reports ROUTE_BOOK_PACK_PROOF PASS books=2 stages=12
build_entries=12 for both Windows and Android proof packs. Normal merge readback:
main5128ac5e4dc073814a0b3acd9b2a456dcba886ad. Earlier pending statements are history.

Five completed proof-only artifacts moved, not deleted, to
C:/Users/user/Downloads/Switchy_User_Delete_Review/20260913-package-verification-extras.
Its manifest retains original/holding paths, hashes, sizes and restoration instructions.
The game EXE/PCK remain untouched. The user decides physical deletion.

Next: exact new-verifier CI pack readback, actual product-speed authored-stage witnesses,
native lifecycle investigation, remaining approved consumer audit and final user handoff.
BUILD entry is NOT a proof of solutions, difficulty balance,12-stage completion or release.
