# Route Book product-speed witnesses

Parent478530552884fdaa1534c85e8f37da8b376d2965. Test-only reconciliation, no map,
product, physics, time limit, difficulty or authored solution changes.
Plan:docs/superpowers/plans/2026-09-13-product-speed-stage-witnesses.md.

Two test helper defaults were4.0, actual ProductScene/Factory defaults2.0. Read actual
scene property and assert started train speed. Initial draft asserted before START,
when train correctly has speed0; this was a test mistake, not production evidence.
Corrected RED log:22 started-speed mismatches4.0vs2.0, focused exit1.
Corrected helper defaults2.0: all12 positive SUCCESS and unchanged negative drivers,
92underlying assertions. Dedicated receipt runner adds37 checks for exactly12 ordered
RB01–RB12 SUCCESS records at2.0:129focused assertions PASS, exit0.

Independent review caught possible incomplete-test output markedPASS; explicit result
completeness checks added, exact rerun and read-only review closed P2.
Five-pass: actual consumer speed; no product changes; no visual/new assets; preserved
fixture provenance; fail-closed outputs/unchanged timeouts. No optimality/player timing claim.

Full official Windows regression product-speed-regression.log terminatedC0000005 after
E2E with NO TEST SUMMARY. UNVERIFIED, NOT_PASS. Focused PASS does not replace it.
Earlier product-speed-red.log likewise crashed after the draft speed assertions.
Python308passed/1skipped observed separately, not native reliability proof.
Draft-only delivery until native investigation/verification reconciled. Whole game open.

Native plan:docs/superpowers/plans/2026-09-13-native-symbol-diagnostic.md.
Official source4.7.1 tag/readback a13da4feb8d8aefc283c3763d33a2f170a18d541.
Local diagnostic folder C:/Users/user/Downloads/Switchy_Native_Diagnostics_20260913.
MSVC14.44/SDK10.0.26100.0 already installed; isolated SCons4.11.1 used.
AccessKit0.21.2 downloaded/extracted manually to new local folder; installer was not
run because it would delete existing global dependency data. ArchiveSHA256:
02a08691b78fc6f8f88f6546e997b9f90b4ecbedf5ca5c621dbab144a4b18964.
Build:platform=windows target=editor arch=x86_64 debug_symbols=yes d3d12=no angle=no
accesskit_sdk_path=<diagnostic>/dependencies/accesskit-c-0.21.2 -j4.
MSVC/D3D12/ANGLE differences are diagnostic-only, not production engine changes;
AccessKit remains enabled, OpenGL consumer preserved. No security exclusions/settings.
Private dumps remain local. Build/stack results pending; do not claim native cause.

## Actual Main/Product completion evidence

completion/receipt.json and12result PNGs bind the separate window runner to actual
Main/Product sources and all12maps. Official4.7.1 window,960x540,ko, accelerated0.05
steps with frame yields. Existing authored fixture placement and real LOAD_ACTIVE,
AUTO_TOGGLE,BOARD_CELL commands; no graph mutation or injected terminal summary.
All12 actual RESULT/SUCCESS, zero map/stack cargo and correct per-book Next visibility.
completion/window.log:12stage markers, final PASS, observed process exit0, no script/
runtime errors or warnings. Captures vary with animated frame timing, not pixel locks.
Negative no-pickup RB01:actual FAILURE, two expected positive-assertion failures,
exit1; ObjectDB1warning retained in completion/negative.log, not clean shutdown proof.
Independent read-only review found no important defect; five-pass scope/consumer/
art/provenance/false-PASS review closed. No production code was changed by this proof.
Not human-paced play, button-to-button Next traversal, native reliability or final UX.
The existing official Windows full-suite crash remains UNVERIFIED/NOT_FIXED.
Fresh full Python suite with GODOT_BINARY configured:308passed/1skipped,exit0 before
this window-only test addition; skipped live-editor Pilot requires its separate setting.
