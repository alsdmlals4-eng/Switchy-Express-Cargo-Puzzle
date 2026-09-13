# Tutorial transition audio implementation plan

**Goal:** preserve the existing success cue when T2–T6 replaces a product instance.
**Architecture:** reuse DemoAudioDirector under the persistent DemoFlowController,
only for this transition. Stop the disappearing product's cue before starting the
shell cue. No global singleton, reparenting, delayed screen transition or new sound.
**Spec:** delegated existing feedback repair in CURRENT_CONFIRMED_DECISIONS.md;
confirmed consumer limitation in evidence/runtime/audio-cue-20260913/READBACK.md.
**Execution:** inline executing-plans; no routine approval stop per latest user.

## Research and feasibility

https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html
ADAPT non-positional UI audio to the existing persistent shell lifetime. Reuse the
exact procedural success stream/settings. REJECT an autoload for one bounded owner,
or retaining dead gameplay/adding timers solely to keep its sound alive.
Actual consumer: product_finite_slice terminal signal -> DemoFlowController's
observe_terminal -> queue_free product -> BRIEFING. The shell survives this boundary.

## Task: repair transition ownership and prove real output

- [ ] Add RED assertions in the existing first-session flow test using real T1/T2
  fixture and product terminal transition. Expect a shell-owned TransitionAudio
  success cue playing, old product cue stopped, no transition cue on ordinary T1
  briefing. Return to title must stop it. Do not alter E2E native source binding.
- [ ] Add ProductFiniteSlice.stop_audio_for_transition() -> existing _audio.stop_all().
  Lazily create DemoAudioDirector child TransitionAudio in the changed tutorial
  terminal branch; stop product cue then play shell success. Reuse on later lessons.
  return_to_title stops it; shell destruction naturally frees it. Route Book and
  standalone results keep their existing product-owned cues.
- [ ] Extend actual audio capture runner with a real T2 solution transition, dedicated
  capture bus, frame boundary proving old product freed, nonzero success output and
  eventual stop. Require separate TUTORIAL_AUDIO_PROOF marker in existing CI step.
- [ ] Run focused RED/GREEN, full regression and Python, actual live runtime readback.
  Review consumer, scope, presentation, provenance and failure boundaries; independent
  review before normal PR/CI/merge. Native C0000005 remains separate and NOT_FIXED.

## Five-pass preimplementation review

1. Consumer: T2–T6 only; T1 model advancement and capstone result are unchanged.
2. Scope: preserve immediate lesson transition and all domain/stage rules.
3. Presentation: stop old cue before shell playback to avoid doubling; stop on title.
4. Provenance: existing generated cue only, no new asset/rights/approval claim.
5. Failure: lazy owner is freed with shell; no orphan root node or hanging async product.
