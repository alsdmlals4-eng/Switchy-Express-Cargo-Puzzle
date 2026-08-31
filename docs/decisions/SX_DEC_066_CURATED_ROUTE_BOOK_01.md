# SX-DEC-066 · Curated Route Book 01

**Status:** `USER_APPROVED · MERGED_MAIN_VERIFIED · SX60-POC-ACCEPT-006_HISTORICAL_AFTER_SX_DEC_067 · SX60-POC-ACCEPT-007_PREPARED_PACKAGE_VERIFIED · FINAL_USER_REVIEW_NOT_RUN`

**Date:** 2026-08-30 KST
**Approval source:** The user requested that playable stages be created and then approved the recommended six-stage `Route Book 01` direction with “진행해”.
**Decision owner:** This document owns scope, invariants, evidence boundaries, and the disposition of alternatives. `기획서/20_시스템_콘텐츠/ROUTE_BOOK_01_STAGE_CONTENT_SPEC.md` owns individual stage content; the linked design and implementation plan own technical delivery details.

## Decision lifecycle boundary

`SX-DEC-066` moved from approved planning direction through bounded implementation and normal PR #260 merge. The implementation commits are `d1d2087` (definition contract) and `49574b249cf4cfa675d4ba804851bfeb5e317dff` (maps, flow, consumers, and tests); the exact merged product source is `main@9af5a8c46d29ea6781f9ee06008d7c7d2cde1877`. Hosted CI/export/package evidence minted immutable `SX60-POC-ACCEPT-006`. These machine checks do **not** prove physical/device behavior or final user review. The exact machine record is in `docs/operations/2026-08-30-sx-dec-066-route-book-01-local-machine-verification.md`.

## Decision

Add `Route Book 01`: six hand-authored, directly selectable finite delivery stages that reuse the current production rules and presentation consumers.

```text
Title
→ Stage Book
→ choose one fixed stage
→ existing briefing / BUILD / RUN / factual Result
→ Retry Same Route | Edit Route | Stage Book | Next Stage
```

The existing first-session path remains an independent onboarding contract:

```text
T1 → T2 → T3 → T4 → T5 → T6 → VS_DEMO_01 → Result / Retry / Edit
```

`Route Book 01` is not a new tutorial lesson, does not renumber T1–T6, and is not required to enter or complete the first-session path.

## Player-value trace

```yaml
player_promise: "이미 배운 선로·적재·TOP·분기 판단을, 다른 지형의 완결된 수제 퍼즐에서 다시 설계하고 실행한다."
meaningful_choice: "어떤 화물을 언제 만나고 적재할지, 어느 역 인접 서비스 셀을 지날지, Auto를 언제 끌지, 분기를 언제 선행 선택할지를 노선으로 결정한다."
expected_experience: "한 가지 규칙을 다시 설명받는 느낌이 아니라, 익힌 규칙을 조합해 스스로 해결책을 설계하는 성취감을 얻는다."
research_question: "현재 finite 규칙과 existing product UI만으로 반복 가능한 고정형 추가 스테이지를 안전하게 생산할 수 있는가?"
observable_signal: "각 맵이 schema/preflight/success witness와 해당 핵심 판단을 무시한 반례를 자동 검증하며, Title→Stage Book→stage→Result recovery가 동일 런타임에서 연결된다."
evidence_ceiling: "MACHINE_VERIFIED only. Five-person comprehension and player-experience study are not required by SX-DEC-065; final user review is optional and only valid for a named exact post-change candidate."
slice_acceptance: "six map contracts, direct selection, recovery, four-locale copy, and full local machine regression pass without widening the finite core; exact CI/package proof and a new exact candidate remain separate post-merge work."
```

## Fixed scope

### Included

- `Route Book 01` list screen accessible from the Title screen.
- Six fixed `FiniteMapDefinition v3` map files and deterministic test-only witnesses.
- Reusable route-book definition/director data path, separate from `FirstSessionDefinition` and `FirstSessionDirector`.
- Existing briefing screen reused for stage title, objective, order, and start action.
- Existing product slice, board, HUD, route-control overlay, result recovery, and semantic product assets reused unchanged in purpose.
- New strings in `ko`, `en`, `ja`, and `zh-Hans`.
- Stage Book / Next Stage result actions, which are visible only while Route Book is active.
- Deterministic map, flow, input-policy, responsive-layout, exact merged-main CI, package integrity, and Candidate 006 machine verification.

### Explicitly excluded

- Any new core rule, station-service radius, cargo-contact rule, LIFO alteration, score, star, combo, economy, power progression, rank, daily/weekly challenge, procedural generation, editor, UGC, online service, save file, unlock persistence, or cross-device migration.
- Any extra T1–T6 tutorial lesson or alteration of their map/data/policy/copy contract.
- `SX-DEC-056`, `SX-DEC-057`, and `SX-DEC-058` implementation, including Yard Labs, Mastery, and generated challenge pipelines.
- A recommended or automatic solution shown to the player for a Route Book map.
- New bitmap, audio, VFX, or shell-art assets. Existing consumers and the established E+D Hybrid / Neo-Arcade grammar are reused.
- Changes to PR #254 or the read-only PR #174.

## Invariants

Every Route Book map must retain the current finite product rules:

```text
cargo pickup = exact-cell Manual / Auto contact
station service = abs(dx) + abs(dy) == 1
station footprint and diagonals = no delivery
stack = unlimited LIFO; matching contiguous TOP group unloads
route control = direct pre-occupancy selection; occupied lock; no auto-reset
preflight = start-reachable RUN component covers required cargo and one legal service cell per station
retry = same sealed layout with fresh mutable runtime
result = only actual SUCCESS / ROUTE_END / TIME_EXPIRED facts
```

All stages expose full production controls except `RECOMMENDED_LAYOUT`; hiding that action prevents an unused or solution-leaking control. No tutorial-only gameplay rule is introduced.

## Alternatives and disposition

| Alternative | Disposition | Reason |
| --- | --- | --- |
| Rebuild or extend T1–T6 as more tutorials | Reject | The seven-part first session is implemented and machine-verified; new tutorial stages violate its locked scope and duplicate existing learning content. |
| Six fixed, directly selectable Route Book stages | Adopt | Reuses current finite runtime and assets, supplies real additional play content, and needs neither progression persistence nor a generator. |
| Revive dynamic map selection, Yard Labs, Mastery, Daily/Weekly, or a content generator | Reject | The existing legacy map-selection family is not the current `FiniteMapDefinition v3` product consumer, while SX-DEC-057/058 implementation remains unauthorized or blocked. |

## Research and feasibility disposition

Public-source reverse engineering across twelve related railway, routing, delivery, and miniature-puzzle games is recorded in [`docs/research/2026-08-30-route-book-01-genre-reverse-engineering.md`](../research/2026-08-30-route-book-01-genre-reverse-engineering.md). It closes the pre-implementation comparison gate without changing any finite product rule or claiming runtime/user evidence.

`ADOPT`: six fixed, directly selectable authored maps; one named central judgement per map; testable success witnesses and failure counterexamples; factual delivery feedback; color + shape + text redundancy; and multiple valid player solutions without a solution reveal.

`ADAPT`: the clear information hierarchy and miniature-diorama warmth found in comparable games, but only through existing board/HUD/result consumers and the already-approved E+D Hybrid / Neo-Arcade asset grammar. No new production asset is needed.

`REJECT`: tycoon/economy/production chains, score/rank/stars/rewards, unlock/save progression, dynamic city growth, endless/survival pressure, roguelite, procedural maps, editor/UGC, sandbox, social sharing, free terrain, multi-train systems, and any replacement of the machine-primary validation policy with a player-experience gate.

No new Godot engine capability, plugin, service, schema version, asset slot, or platform dependency is required. Existing `FiniteMapLoader`, `FiniteBuildSession`, `FiniteRunSessionFactory`, `ProductFiniteSlice`, `FirstSessionStagePolicy`, and `DemoFlowController` prove the needed integration seam.

## Evidence and candidate transition

`SX60-POC-ACCEPT-005` remains immutable historical machine evidence for its exact `main@a11dfd1` source bytes. Route Book code/data changes made it historical for the changed product. `SX60-POC-ACCEPT-006` is immutable machine-primary evidence for exact `main@9af5a8c` Route Book 01 bytes, and SX-DEC-067 later made it historical for the changed product. `SX60-POC-ACCEPT-007` now binds the exact post-SX-DEC-067 package from `main@c0bb86e`; it is the sole current candidate while unchanged.

```text
Route Book implementation changes product bytes
→ local deterministic and headless Godot checks pass on exact local implementation commit `49574b249cf4cfa675d4ba804851bfeb5e317dff`
→ PR #260 merged to exact main 9af5a8c
→ exact CI/export/package verification and Candidate 006 mint complete
→ machine-primary acceptance ready
→ optional final user review only when requested on that exact candidate
```

Five-person comprehension and player-experience studies are not scheduled or used as completion blockers. Machine evidence never becomes human evidence.

## Rollback

The feature has no save migration, unlock state, asset mutation, or core-rule change. Reverting its data, flow, and UI files removes Route Book access while preserving the first session, `VS_DEMO_01`, current assets, and historical candidate records.

## Required implementation records

- Content owner: `기획서/20_시스템_콘텐츠/ROUTE_BOOK_01_STAGE_CONTENT_SPEC.md`
- Technical design: `docs/superpowers/specs/2026-08-30-route-book-01-stage-pack-design.md`
- Implementation plan: `docs/superpowers/plans/2026-08-30-route-book-01-stage-pack-implementation.md`
- Local machine evidence: `docs/operations/2026-08-30-sx-dec-066-route-book-01-local-machine-verification.md`.
- Exact-main runtime/package evidence: `evidence/acceptance/sx60_poc_accept_006_artifact.json`, `evidence/acceptance/sx60_poc_accept_006_pck_deep_audit.json`, and Candidate 006 acceptance record.
