# SX-DEC-060 · Current-main Godot live machine QA · 2026-08-27

Status: `MACHINE_RUNTIME_FLOW_OBSERVED · HUMAN_DEVICE_AUDIO_NOT_RUN`

## Exact target

```yaml
project_main: cf93926e302d2b7d8ea1492dec3d19c43f7484cd
engine: Godot 4.7.1-stable.official.a13da4feb
project_name: Switchy Express: Cargo Puzzle
execution_isolation: disposable detached Git worktree
```

## Machine evidence

1. The official project Godot runner completed `112` cases, `13,480` assertions, and `0` failures on the exact target.
2. The live Godot editor launched the main scene and its runtime helper became live.
3. Machine-visible UI and framebuffer evidence observed the exact flow:

```text
title screen
→ Korean "첫 배송 시작" input
→ T1 "선로 연결" briefing
→ Korean "시작" input
→ build board / HUD
```

4. The title and board framebuffers were current (`stale_frame: false`). Runtime game logs contained helper registration and no game `error` entry for this run.
5. The first automated pointer attempt used the 1920 logical UI coordinates while the captured game used the 1280×720 override. It caused no state change. Repeating with the capture-space coordinates produced the expected title→briefing transition. This is test-harness coordinate evidence, not a gameplay defect.

## Observed warning boundary

The editor Errors view showed existing GDScript `SHADOWED_VARIABLE` / `SHADOWED_VARIABLE_BASE_CLASS` warnings in finite rail/delivery and presentation scripts. The full regression and live title→briefing→build flow still passed. This receipt does not change names or claim the warnings are resolved; warning cleanup needs its own scoped Issue if it becomes a quality gate.

## Non-promotion boundary

```text
Windows physical human smoke: NOT_RUN
audio perceptual QA: NOT_RUN
Android device: NOT_RUN
five-person comprehension: NOT_RUN
player experience: NOT_RUN
```

This does not replace the exact Candidate 002 package chain and does not authorize a new Slice. It confirms only the current-main machine runtime flow. No code, map, asset, image, or gameplay rule changed. PR #174 remains `READ_ONLY`.
