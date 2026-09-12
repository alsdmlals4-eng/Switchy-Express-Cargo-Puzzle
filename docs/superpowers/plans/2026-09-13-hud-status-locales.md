# HUD status language continuity

Goal: connect existing shell locale to existing HUD status, time, unresolved cargo,
cost and Menu text without changing finite rules or adding languages/settings.
Scope approved by current continuous-work request and Active Context next action.
Baseline dfbb3e4c28a2809e3ebf11d38b8e0f4dcb40996b;216 pre-existing imports/settings preserved.
Work mode PLAN→BUILD→REVIEW; project-local switchy-express-design, TDD and live QA.
Base observed d830c0f; compatibility pin unchanged. Five project review passes
override Base's newer two-loop default. No Base promotion or external PR absorption.

## Preflight and alternatives

- REUSE existing FirstSessionCopy JSON four-locale loader, shell locale, actual HUD model.
- ADAPT Godot localization guidance: externally owned message keys and explicit locale.
  https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html
- ADAPT Railbound's localized interface and compact rail-planning presentation; no maps/art copied.
  https://www.afterburn.games/railbound/
  https://store.steampowered.com/app/1967510/Railbound/
- Alternative1 chosen: explicit shell→HUD locale and existing Copy owner, minimum migration risk.
- Alternative2 deferred: migrate all strings to TranslationServer/gettext; valid for full localization
  but changes project settings/extraction/locale ownership beyond this bounded correction.
- Alternative3 rejected for now: separate HUD language dictionary; duplicates current loader/fallback.
Old AI production snapshot remains historical; current Active Context governs this bounded continuation.

## Implementation / verification

- [ ] RED: real shell selects book+stage in4 locales; HUD status uses selected language;
      RUN model retains12.5 seconds,2+3 unresolved cargo and1100/4500 costs.
- [ ] Add HUD locale configuration before its _ready; cache FirstSessionCopy once per HUD.
      Translate full formatted messages, not separately joined word fragments. Keep ko defaults.
- [ ] GREEN full custom Godot runner; Python/contracts. Preserve any native failure as failure.
- [ ] Render actual Main four locales at960x540; inspect top status and values, no domain mutation.
- [ ] Refresh flow-bound prior receipts, five-pass review, current docs, normal PR/CI/merge/readback.

Acceptance excludes whole-HUD localization, human language quality, new locale preferences,
native crash repair, release readiness, score/content/core changes and asset production.
Rollback: revert scoped commit through normal PR. Reuse learning remains project-only until repeated.
