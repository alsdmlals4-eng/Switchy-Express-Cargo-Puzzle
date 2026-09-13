# Existing procedural cue drain — 2026-09-13

Parent main5128ac5e4dc073814a0b3acd9b2a456dcba886ad, current approved feedback
repair only. No art, mix, domain, time, map, engine or provider change.

## Problem / research / correction

All cues are shorter than the generator buffer. Old code stopped the player when
generation finished, before the queued samples could be consumed. Actual live run10
pickup reported playing=false immediately. Added8 assertions failed before the fix.

ADOPT the official writable-buffer contract:
https://docs.godotengine.org/en/stable/classes/class_audiostreamgeneratorplayback.html
Save capacity for each new playback; after generation, wait for source buffer drain.
REJECT guessed duration timers and unnecessary audio asset/mixer replacement.

https://docs.godotengine.org/en/stable/classes/class_audioeffectcapture.html
Capture only generated output in an owned muted bus; no microphone or user recording.

## Evidence

- audio-cue-red.log:8 assertion failures, exit1. Its exit leak warnings are not a PASS.
- audio-cue-bound.log and audio-cue-capture-proof.json:8 nonzero cues, eventual player
  stop,56 assertions, exit0. JSON binds LF-normalized exact sources and engine.
- audio-cue-regression.log:129cases/0failed/16048assertions, exit0.
- Full Python with GODOT_BINARY:308passed/1skipped, exit0; unconfigured preliminary
  tests/python alone279passed/3skipped is not the full acceptance result.
- Actual connected editor26468, correct linked project/main.tscn, run11 after restart:
  pickup immediately playing=true; later playing=false; temporary readback node freed.
- CI now runs the real capture with external30s timeout, exit/error/PASS-marker checks.

Source-buffer drain does NOT guarantee every downstream resampler/device sample,
perceptual quality, human audio approval or cue continuity after owner destruction.

## Five-pass / independent review

1. Consumer: actual cue players now remain active; no invented audio consumer.
2. Scope: no core, settings, train-loop or pause semantics changed.
3. Presentation: nonzero output and eventual stop observed, no listening claim.
4. Provenance: no generated assets; numeric capture hashes bind current source.
5. Failure: stop/replacement/null/exit reset safely; CI fails on errors and timeout.

Independent read-only review found no introduced blocking finding. It identified a
pre-existing next boundary: tutorial terminal success immediately queues product
destruction, canceling product-owned success audio. Fix this next, not silently PASS.

Native C0000005 is NOT_FIXED. Frame-separated repeated tutorial runs still crashed:
before audio correction after case3, and after correction at case2 beginning. Those
diagnostics are not replaced by successful regression retries. No native diagnosis
from the last log marker alone. Existing native evidence owner remains authoritative.

Expected value: current construction, pickup, unload and result cues survive generation
completion while their audio owner lives. Exact CI/merge and tutorial lifecycle follow.
