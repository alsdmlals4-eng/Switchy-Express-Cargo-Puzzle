# Native source-symbol diagnostic plan

Problem: Windows official4.7.1 full suite now again exits C0000005 after tutorial E2E;
same-process and frame-separated reproduction already retained. Product-speed
witnesses pass focused92assertions but full Windows suite remains UNVERIFIED.
No successful retry is a fix. Need a source-level crash stack.

Official4.7.1 source tag resolves a13da4feb8d8aefc283c3763d33a2f170a18d541,
matching installed official binary version. No Windows PDB is shipped. Existing
MSVC14.44 and Windows SDK are installed; debugger folder contains DLLs, no cdb.

Sources:
https://docs.godotengine.org/en/stable/engine_details/development/compiling/introduction_to_the_buildsystem.html
https://docs.godotengine.org/en/stable/engine_details/development/compiling/compiling_for_windows.html

ADOPT separate symbol-enabled exact-release diagnostic build in Downloads, using
existing compiler and isolated SCons environment. This is diagnostic-only, never
replace the project engine/provider pin or distribute it as the approved game.
Compiler/layout differences mean an MSVC diagnostic result is not official-byte proof.
REJECT antivirus exclusions, accessibility disablement, registry/security changes,
uploading private memory dumps, or guessing the faulting method from a final log line.

1. Verify exact clone HEAD and inspect build/dependency scripts before execution.
2. Build with symbols, modest parallelism and >=15GB free disk guard. Keep OpenGL
   consumer; D3D12 dependency omission is a diagnostic build difference, not a product
   renderer change. Preserve AccessKit support. Keep all downloads local and recorded.
3. Run the bounded E2E reproduction serially with exact project sources. Read actual
   native stack and source, minimize confirmed failure, write RED before any product fix.
4. Correct only source-backed in-scope issue; official4.7.1 full regression and runtime
   must pass without error before claiming repair. If not reproduced, retain NOT_FIXED.
5. Five-pass consumer/scope/security/provenance/evidence review. Move only completed
   diagnostic artifacts to user-deletion holding with path/hash/restore manifest later.

No whole-game completion, native repair or release claim is authorized by this plan.

## Source-backed generator lifetime correction plan

CDB with normal heap(-hd) caught worker-thread AV in AudioStreamGenerator::_get_target_rate
line61, called by AudioStreamGeneratorPlayback::get_stream_sampling_rate line196,
AudioStreamPlaybackResampled::mix -> AudioServer::_mix_step -> AudioDriverDummy.
Exact source uses raw AudioStreamGenerator* in playback; stop schedules fade/deletion,
so destroying/replacing the player's stream can outlive its generator in the mixer.
Actual DemoAudioDirector creates train generators per restart and owns cue cache only
for node lifetime. This identifies a concrete lifetime hole, not arbitrary UI teardown.

1. RED: hold each actual playback, destroy the director, assert weak generator remains
   valid while playback is still alive. Cover one-shot and train independently.
2. ADOPT per-playback strong resource reference via Object metadata, set immediately
   after obtaining playback while local stream still owns generator. No reference cycle:
   generator does not own playback. Lifetime ends with playback, no global cache/leak.
3. REJECT replacing engine, delaying scene destruction, muting audio, static permanent
   caches or unrelated lifecycle refactoring. Same generated audio and gameplay.
4. Run RED/GREEN, original official E2E/pair stress and full suite; actual cue capture
   and window completion; source-bound evidence refresh. A retry alone is never repair.
5. Five-pass and independent review of lifetime, race interval, cue parity, bounded
   resource release and evidence. Native fix status requires exact official verification.

Primary source:official tag a13da4feb servers/audio/effects/audio_stream_generator.cpp/.h,
servers/audio/audio_server.cpp. Historical issue65155 concerns earlier buffer starvation;
REJECT as proof of this same fault. Local source-level stack is the current evidence.
