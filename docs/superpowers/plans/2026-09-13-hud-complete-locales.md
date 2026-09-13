# Complete Gameplay HUD Locale Implementation Plan

> Execute inline with executing-plans; independent review before merge.

**Goal:** Complete the existing four-language gameplay HUD without changing gameplay.
**Architecture:** Reuse FirstSessionCopy and the already propagated HUD locale. Keep node paths/signals and read-model ownership. Translate complete messages through the common JSON catalog, not a second loader.
**Tech Stack:** Godot4.7.1, GDScript, existing custom tests and standalone runtime runner.
**Spec:** CURRENT_CONFIRMED_DECISIONS.md delegated continuous improvement; finite baseline unchanged.

## Scope / alternatives / evidence

Base remote observed d830c0f; compatibility v9.4.3 retained. Parent main9fd5b8e.
Existing216 tracked dirty imports/settings and untracked files protected. PR174/254/281 read-only.
ADOPT existing Copy owner, four locales ko/en/ja/zh-Hans, structured keys and fallback.
ADAPT existing HUD: toolbar/history/stack/preflight/internal overlays use selected locale.
DEFER engine TranslationServer migration: wider settings/extraction ownership unnecessary here.
REJECT independent HUD dictionary: duplicates loader/fallback/validation.
Research: https://afterburn.games/railbound/ uses understandable track-puzzle presentation;
https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html
warns translated text lengths differ. Use existing buttons and measured layouts, no copied maps/art.
SWOT: strength is route-order/LIFO identity; mixed-language repair guidance weakens it.
Opportunity is clear actionable existing feedback; threat is long text crowding board/controls.
No new art, rules, map, save, package approval, paid tool or Base promotion.
Historical static scene text stays a Korean editor fallback; ready/apply_model owns runtime text.

## Task1: HUD complete language connection

Files: product_hud.gd, first_session_v1.json, test_hud_status_locales.gd.
Consumes: locale:String; apply_model(Dictionary), existing stack_tokens and primary_reason.
Produces: same visible controls/signals, localized labels, unchanged model and unbounded manifest.
- [x] RED: add real HUD assertions for four locales: tool names, history states, auto modes,
  empty/mixed/64-token stack and TOP group, exact cargo vs cardinal station errors, unknown failure.
- [x] Run `Godot --headless --path . --script res://tests/run_tests.gd`; observe missing-locale failure.
- [x] Implement catalog entries and node-path mapping. Keep helpers instance-scoped to use locale.
  `button.text = _copy.text(key, locale)`; format counts through `_copy.format(key, values, locale)`.
- [x] Full custom runner/Python/contracts; inspect all failure branches and disabled/visible controls.

## Task2: Real window and delivery

- [x] Extend existing standalone runtime checks for translated toolbar/problem/manifest bounds.
  Capture real build/run states in four locales. Verify64-token manifest remains scrollable.
- [x] Refresh existing source-bound receipts affected by catalog/HUD bytes; do not re-label old captures.
- [x] Five full-scope review passes: semantic+consumer, scope, layout/readability, provenance, failure/evidence.
- [x] Update Active Context/roadmap/decisions and human Blueprint with actual evidence.
- [ ] Selective commit, branch push, exact-head CI, normal merge, main readback and postmerge tests.

## Overall completion queue (not a game-complete claim)

1. Existing gameplay language coverage and input/viewport regression (this unit).
2. Existing twelve-stage content decision diversity audit using actual witnesses, not presumed optimal routes.
3. Native intermittent exit diagnosis with original failures retained; no repeat-PASS-as-fix.
4. Fresh exact playable package and all approved asset consumers/progression/save/ending audit.
5. Final user-review handoff; rights/public release and explicitly deferred feature families remain separate.

Rollback: scoped PR revert only. Learning remains project-only pending repeated cross-project evidence.
