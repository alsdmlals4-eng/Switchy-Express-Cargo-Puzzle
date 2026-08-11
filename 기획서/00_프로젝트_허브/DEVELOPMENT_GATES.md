# Development Gates

현재 제품/실행 상태는 `CURRENT_CONFIRMED_DECISIONS.md`, `ACTIVE_CONTEXT.md`, `SX_AUD_047_PHASE_B_FINAL_PLANNING_REVIEW.md`가 우선한다. 저장된 commit/PR/run 값은 해당 시점 증거이며 current GitHub/Sheet를 대체하지 않는다.

## Active Gate Chains

### v4.5 planning/build chain

```text
A0 PHASE A GPT CHAT PLANNING: COMPLETE · SX-AUD-044
→ A1 READY_FOR_USER_PLANNING_COMPLETE_GATE: PASS
→ A2 explicit user "기획 완료": GRANTED · 2026-08-11 KST
→ A3 PHASE B FINAL PLANNING REVIEW: PASS · SX-AUD-047
→ A4 BUILD AUTHORITY: AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE
→ A5 FIRST BUILD STEP: SX-DEC-055 Task 1 / Step 1.1 RED · NOT_STARTED
```

Phase B did not execute product/runtime BUILD. It only closed planning/canon readiness and added the JSON export packaging prerequisite.

### PC Vertical Slice chain

```text
PC0 SX-DEC-037~042 CURRENT FINITE IMPLEMENTATION: PASS · product baseline GMB-002
→ PC1 AUTOMATED VERTICAL SLICE: PASS
→ PC2 DEFAULT PROJECT PLAY BOOT: PASS · AUTOMATED
→ PC3 ROUTE·TERMINAL·MID-RUN AUTOMATED REGRESSION: PASS
→ PC4 COLOR PARITY·ROUTE-END·SWITCH DIRECTION: MERGED_MAIN_VERIFIED · AUTOMATED_PASS · feature-scoped user F5 evidence
→ PC5 LOCAL ROUTE·MID-RUN FULL RETEST: RETEST_REQUIRED
→ PC6 WINDOWS DEBUG EXPORT/PACKAGING: historical PASS evidence
→ PC7 WINDOWS EXPORTED ARTIFACT PHYSICAL RUNTIME/VISUAL/AUDIO/INPUT: NOT_RUN
```

`GMB-003` was a historical route-end/switch implementation package and is not the current finite product baseline.

### SX-DEC-055 runtime semantic POC chain

```text
S0 SX-DEC-053/054 73 PRODUCT PNG PACKAGE: COMPLETE
→ S1 SX-DEC-055 DECISION/SPEC/DoR: PASS
→ S2 PHASE B READINESS: PASS · SX-AUD-047
→ S3 SemanticAssetCatalog RED/GREEN: NOT_STARTED
→ S4 pure SemanticRuntimeState RED/GREEN: NOT_STARTED
→ S5 manual-load read projection: NOT_STARTED
→ S6 HUD/BUILD/route semantic reinforcement: NOT_STARTED
→ S7 SemanticEventOverlay + Reduced Motion: NOT_STARTED
→ S8 ProductFiniteSlice existing-seam wiring: NOT_STARTED
→ S9A NON-RESOURCE JSON EXPORT CONTRACT + EXPORTED-PACK PROOF: NOT_STARTED · MANDATORY
→ S9B FULL AUTOMATED/EXACT-HEAD/IMMUTABILITY PR GATE: NOT_STARTED
→ S10 SAME-ID SX-DEC-055 MERGED-MAIN CLOSURE: NOT_STARTED
```

The required Phase B packaging amendment is:

`docs/superpowers/plans/2026-08-11-sx-dec-055-phase-b-readiness-amendment.md`

It requires narrow runtime-owned JSON export inclusion for:

```text
data/maps/*.json
art/product_assets/ed_hybrid_v1/*.json
```

and exported-package proof before export evidence may satisfy the POC gate.

### Product / Android / human chain

```text
G0 PROJECT_IDENTIFIED: PASS
→ G1 FINITE_PRODUCT_AUTHORITY: PASS · GMB-002 · SX-DEC-027~055
→ G2 AUTOMATED_CORE: PASS
→ G3 VALIDATION_PREPARATION: PASS
→ G4 HISTORICAL CANONICAL APK EXPORT: PASS · packaging/hash evidence only
→ G5 ANDROID DEVICE SMOKE · HISTORICAL VALIDATION-HARNESS: NOT_RUN · OPTIONAL DIAGNOSTIC LANE
→ G5A SX-DEC-055 AUTOMATED RUNTIME POC: NOT_STARTED
→ G5B EXACT POST-POC ACCEPTANCE BUILD IDENTITY: UNASSIGNED
→ G5C PHYSICAL ACCEPTANCE SMOKE ON THAT EXACT BUILD: NOT_READY · NOT_RUN
→ G6 FIVE-PERSON COMPREHENSION: NOT_RUN
→ G7 FINAL PASS/REVISE/PIVOT/STOP: NOT_RUN
→ G8 PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

`ANDROID DEVICE SMOKE` is retained as the canonical machine-readable gate token. The current historical validation-harness lane remains NOT_RUN and does not substitute for the future post-POC acceptance-build physical smoke.

## Physical/manual evidence ceiling

The following remain explicitly separate from automated/hosted evidence:

- Windows exported artifact physical runtime/visual/audio/input: `NOT_RUN`
- `ANDROID DEVICE SMOKE` · Android landscape actual-device: `NOT_RUN`
- Connected physical Godot/Hera authoring session: `NOT_RUN`
- post-POC acceptance-build physical smoke: `NOT_READY · NOT_RUN`
- Five-person Comprehension: `NOT_RUN`
- broader human/comprehension: `NOT_RUN`
- production cutover: `BLOCKED_DEFERRED`

Hosted export success is packaging evidence only. It cannot promote physical/device/human gates.

## Protected gates

Phase C must preserve:

- LIFO and cargo eligibility;
- route topology/cycle/U-turn/occupied-lock authority;
- time/scoring/failure/save/ruleset/map content;
- product PNG and semantic sidecar bytes;
- historical `runtime_integrated=false` provenance;
- existing procedural/text fallback/redundancy;
- Base `v9.4.3` pin;
- `.asset-vault` deferred state.

No new gameplay/domain signal may be invented solely for semantic feedback or combo VFX.

## Five-person Comprehension gate

After an exact post-POC acceptance build exists and physical smoke is reviewed:

- recruit target: `6` (`TEST_VALUE` buffer)
- minimum analyzable first-contact sessions: `5`
- behavior → prediction → explanation → transfer first
- neutral moderator; no solution-relevant coaching
- use `PLAYTEST_PLAN.md` FS-01~FS-12
- unresolved P0/P1 comprehension/accessibility finding must be `0` for PASS.

## Current next action

After this Phase-B canon-sync is merged and the configured Sheet is reconciled, the only authorized first implementation action is:

```text
SX-DEC-055
Task 1 / Step 1.1 RED
→ tests/demo/test_semantic_asset_catalog.gd
→ tests/run_tests.gd registration
→ custom Godot suite
→ expected RED must be the missing SemanticAssetCatalog assertion
```
