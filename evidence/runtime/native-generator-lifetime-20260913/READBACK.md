# Generator playback lifetime correction

Parent current-task Draft304 fe3e28a1c7cac8126a9b8181a116b42ad80febb8.
Plan/research:docs/superpowers/plans/2026-09-13-native-symbol-diagnostic.md.
Historical native-exit observations remain immutable NOT_FIXED-at-that-revision records.

## Cause and bounded change

Exact-release MSVC symbol build caught worker-thread C0000005 via CDB normal heap(-hd):
AudioStreamGenerator::_get_target_rate61 -> GeneratorPlayback::get_stream_sampling_rate196
-> AudioStreamPlaybackResampled::mix -> AudioServer::_mix_step422 -> AudioDriverDummy.
Engine source stores generator as raw pointer; AudioServer stop schedules a final fade.
DemoAudioDirector could release the source while mixer retained playback. Two per-playback
metadata strong references now keep each source alive until its own playback is released.
No global resource cache, reference cycle, scene delay, engine replacement, mute or core change.

## RED and correction evidence

- Initial test had inferred-Variant parse error:NOT_RED. Fixed explicit WeakRef type.
- Initial same-function weakref test falsely passed because GDScript expression temporaries
  retained the source. Helper-return boundary clears those temporaries; not a product fix.
- Scoped RED:cue and train source destroyed while playback held, two failures,exit1.
  Original ObjectDB2warning retained; not clean shutdown proof.
- GREEN final:both sources survive director destruction and release after playback drops,
  sources2 PASS,exit0,no warning. Numerical receipt binds exact production/test source.
- Official engine E2E30:30cases/630assertions,exit0. Pair30:60cases/7770assertions,exit0.
- Full official Windows suite:129cases/16105assertions,failed0,exit0.
- Unchanged frame-separated20probe:20/420,exit0,no AV, but ObjectDB2warning remains.
  This diagnostic is not a clean-shutdown PASS. Its SHA256 is
  bf0cc8d0425f20fed22a5d438530ae518cf0e6ec3b34f4ca9be591f59f30ce27.
  The official non-frame E2E/pair/full-suite and lifetime/window proofs have no warnings.
- Eight actual cue output and post-product-free T2->T3 capture:63assertions PASS,exit0.
  Same cues/gain/duration and no generated artwork changed. Human listening remains NOT_RUN.
- Actual12stage Main/Product window completion rerun after audio change,exit0/no warnings;
  current completion receipt now also binds audio source. Numerical product-speed129 PASS.
- Correct live editor26468 main.tscn run13: actual T1/T2 witness -> T3, transition cue
  playing=true/source_retained=true; later cue_finished=true and returned TITLE.
  Fresh editor diagnostics:error0/warning0. Other projects were not touched.

Independent read-only review checked raw-pointer source, async fade, attachment interval,
prior playback replacement, absence of reverse ownership/cycle and test temporary lifetime.
No important finding. Five-pass consumer/scope/visual/provenance/failure/evidence review closed.
CI now executes the lifetime runner with strict summary/exit/error/warning checks and30s cap.

Diagnostic caveats:MSVC binary differs from official MinGW binary; source stack and official
verification are separate evidence. Initial CDB debug-heap20 loop printed summary but cleanup
did not finish; interrupted exact owned processes, NOT clean exit. CDB q after trapped AV
returns0 but is a captured crash, never PASS. No private memory dump uploaded or global
debugger/security/registry changes. Tools remain task-local until verified cleanup/handoff.

Current source-backed repair was merged via PR304 after exact five CI checks. PR305
subsequently delivered the terminal HUD correction and verified package; PR306 changes
only Pilot tooling. This remains no guarantee against every possible native defect.
Final full Python308passed/1skipped,exit0 with GODOT_BINARY configured; skipped live-editor
Pilot uses its separate GODOT_BIN setting. Correct editor run13 above is independent
live evidence, not an assertion that the skipped Python test ran. Project contract PASS.

## Frame-only shutdown diagnostic refinement

The unchanged original frame probe20/420 still exits0 with two ObjectDB warnings.
Full verbose stdout identifies exactly AudioStreamGeneratorPlayback and AudioStreamGenerator,
both reference count1, including metadata/switchy_generator_source. No stack/scene leak
identity is inferred from that observation. Original warning is not relabeled PASS.

Separate test-only frame-source-drain-probe.gd.txt records weak references to generator
sources as real AudioStreamPlayers exit the tree over the same20E2E cases. After the last
normal frame:220observations,1sourcepending; then waits only while a weak source remains,
bounded120frames. Result:0remaining after8frames,20/420,exit0 and no warnings.
frame-source-drain.log preserves the summary. No product/source retention code was changed.
This supports pending mixer release in this bounded diagnostic, not a fix to every shutdown
path or permission to hide warnings. Existing lifetime runner independently proves release.
