# One-shot audio playback completion

Scope: repair existing eight procedural cues, no new assets, audio style, gameplay rule,
mix policy, saved preference or engine/provider change. Execute after PR301 delivery.

## Confirmed problem and design

Actual Switchy live editor run10: play_cue(pickup) records pickup but OneShotPlayer.playing
is false immediately afterward. DemoAudioDirector._fill_one_shot_buffer fills a cue
shorter than its buffer and immediately calls stop when generated frames reach zero.
Generation completion is not playback completion. Existing tests check cue names,
stream type and domain nonmutation, not whether queued samples can actually play.

Primary source:https://docs.godotengine.org/en/stable/classes/class_audiostreamgeneratorplayback.html
get_frames_available reports writable space, not elapsed audio. ADOPT this actual buffer
contract: remember empty-buffer capacity per playback, fill remaining frames, then stop
only after generated frames are zero AND writable space has returned to empty capacity.
REJECT a guessed timer or new audio asset/mixer replacement. Existing cue/volume/pause
and train-loop semantics remain unchanged. This is not a native-crash fix assertion.

## RED → GREEN → runtime

1. Existing audio test must observe all8 real players still playing immediately after
   cue request, and stop_all genuinely stopped. Run RED before product code.
2. Add one per-playback capacity value; preserve queued samples after last push;
   drain on subsequent process updates, reset capacity on stop/replacement.
3. Regress domain model/layout/summary nonmutation and all existing tests.
4. Real AudioEffectCapture on a dedicated temporary output bus: observe nonzero
   generated cue samples and eventual stop. No microphone/input capture. Remove only
   the owned temporary bus after observation. This is not perceptual/human audio approval.
5. Five-pass consumer/scope/presentation/provenance/failure review, independent review,
   current owners and exact CI/normal merge/readback. Keep native NOT_FIXED separate.

Expected effect: build/pickup/unload/result actions retain their existing audible cue
instead of canceling it immediately. No score, timing, cargo or map changes.
