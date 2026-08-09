# Semantic Asset Completion Strategy — Design Spec

**Decision:** `SX-DEC-054`  
**Date:** 2026-08-10 KST  
**Baseline main:** `de302e7cfd56a23d53a6ec97509195564e36749d`  
**Approved approach:** `SEMANTIC_FIRST_INDEPENDENT_ASSETS`

## 1. Goal

Close the remaining semantic-asset backlog left by `SX-DEC-053` without assigning invented meanings to ambiguous historical atlas regions.

The design converts already-approved component states into explicit, independently reviewable product assets while preserving the current 39-product package, its provenance, and all runtime/device/human evidence boundaries.

## 2. Constraints

Hard constraints:

- `E+D HYBRID · NEO-ARCADE READABILITY` remains the visual direction;
- D-style puzzle readability wins over decorative polish;
- cargo/station identity is color + shape, never color-only;
- Stack HUD must keep TOP and predicted contiguous unload group readable;
- the existing `unloading` asset is not the predicted unload-group asset;
- switch semantics reuse current `RouteControlOverlay` authority;
- committed rail and BUILD preview art remain visually distinct;
- Reduced Motion retains information equivalence;
- no new gameplay rule or runtime integration is authorized by this spec.

## 3. Approach comparison

### Approach A — semantic-first independent assets

**Selected.** Use approved state contracts as the semantic source and create explicit product assets or reusable state primitives.

Trade-off: creates new files, but each file has unambiguous intent and testable provenance.

### Approach B — atlas reinterpretation

Do not select. It minimizes file creation but requires guessing which unnamed visual region means which state, directly violating the current authority boundary.

### Approach C — wait for runtime hookup

Do not select. It avoids immediate asset work but moves visual ambiguity into the Godot integration phase and makes review harder.

## 4. Asset architecture

Root remains:

`art/product_assets/ed_hybrid_v1/`

Families remain:

- `run/`
- `build/`
- `vfx/`

Existing core/UI/shell/meta product assets remain untouched unless an unrelated verified defect is discovered.

Each new semantic record must include:

```yaml
decision_id: SX-DEC-054
source_authority: <registered owner decision/component>
family: <run|build|vfx>
role: <semantic role>
state: <explicit state>
runtime_integrated: false
transform_or_generation_kind: <independent_semantic_asset|reuse_composition|static_equivalent>
```

If an asset reuses current product primitives, the manifest records those product paths as inputs. It must not claim an ambiguous atlas crop as a named source.

## 5. RUN information design

### Stack HUD

Keep current assets:
- `run_stack_empty_v01`;
- `run_stack_32plus_v01`;
- `run_stack_unloading_v01`;
- `run_stack_top_highlight_v01`.

Add semantic coverage for:
- compact;
- 8plus;
- 16plus;
- predicted unload group;
- paused.

The predicted unload-group representation should function as a boundary/highlight primitive that can coexist with TOP. It must not visually look like an unload event already committed.

### Train cargo strip

Represent only the compact world-adjacent summary:
- empty;
- 1–3 visible recent/TOP tokens;
- `+N` compression;
- unload transition.

Reuse current cargo tokens and the approved smaller-wagon hierarchy. Do not render an unbounded physical wagon chain as the stack model.

### Load mode

Provide unambiguous icon+shape states for:
- manual idle;
- manual held;
- auto off;
- auto on;
- paused disabled;
- input received feedback where consumed by the approved component authority.

A neutral mode shell plus independent state markers is preferred over duplicating a full panel for every state when visual meaning is unchanged.

### Switch direction

Use the current switch-direction runtime authority to enumerate actual reciprocal directions at implementation time. Provide selected/unselected/occupied-locked/inactive visual semantics using the existing VIS-014-compatible arrow language.

Do not infer missing directions by mirroring or rotating old atlas regions and then claiming those old regions were authoritative.

## 6. BUILD design

### Placement preview

Keep the four authoritative batch-1 crops. Add semantic primitives needed for:
- rotate preview;
- replacement preview;
- shared valid/invalid reinforcement where existing per-form crops do not cover a form.

Committed rail remains the visual authority for a placed result. A placement-preview asset never becomes a committed rail substitute.

### Track palette

Track-form silhouettes:
- straight;
- curve;
- switch;
- crossing.

Interaction semantics:
- idle;
- selected;
- unavailable;
- keyboard focus;
- touch pressed.

Implementation should separate form identity from interaction state wherever possible. Reusable frames/overlays are preferred to generating 20 nearly duplicate binaries.

### Preflight

The UI component contract remains:
- clear;
- primary issue;
- multi-issue summary;
- focused location.

If presentation uses ready/warning/blocking severity styling, that styling is driven by authoritative preflight issue data and does not define a new game outcome. Optional target misses must not look like general run failure.

## 7. VFX design

Meaning-bearing event set:
- cargo pickup;
- cargo unload;
- combo;
- route selection;
- success;
- failure;
- route end;
- time expired.

For each event, choose the smallest asset structure that preserves causality:
- static frame/marker when motion is optional;
- short frame set when motion materially improves cause reading;
- explicit Reduced Motion static equivalent whenever motion carries information.

VFX may decorate an event but never own score, result, cargo, route, or save authority.

## 8. Data flow

```text
Approved owner/component state
→ semantic asset requirement
→ independent asset or reuse composition
→ SX-DEC-054 manifest record
→ static package validator
→ exact-head CI
→ merged-main readback
→ same-ID Sheet synchronization
→ later separate Godot runtime/POC gate
```

No step maps an unnamed historical atlas region to a new meaning.

## 9. Error handling

If a proposed semantic asset cannot be tied to an approved state:

1. do not generate/promote it;
2. record the gap as pending rather than guessing;
3. reuse a neutral existing primitive only if that primitive does not imply the missing meaning;
4. escalate only if product semantics, not implementation details, are genuinely missing.

If a generated/reused PNG fails integrity or manifest validation, repair/version that asset without mutating historical source bytes.

## 10. Testing strategy

TDD sequence for implementation:

1. Add/extend focused Python tests with expected semantic roles/states before the new files exist (RED).
2. Extend validator contract to reject:
   - unregistered semantic files;
   - missing required states;
   - ambiguous-atlas source claims;
   - decision ID drift;
   - PNG integrity/dimension/alpha failures;
   - manifest↔physical-file drift;
   - runtime integration set true;
   - incomplete Reduced Motion equivalents for meaning-bearing VFX in scope.
3. Add the minimum asset batch to satisfy the contract (GREEN).
4. Run repository Project Contract plus existing GUT/Godot/Thin/Windows-export regression workflows on the exact PR head when triggered/applicable.
5. Inspect changed-file scope and unresolved review threads before merge.

Automated export success is not physical Windows runtime evidence.

## 11. Batch recommendation

Keep implementation finite and reviewable:

### Batch 2A — RUN semantic completion
- Stack HUD remainder;
- train cargo strip;
- load mode;
- switch presentation completion.

### Batch 2B — BUILD semantic completion
- remaining placement semantics;
- track palette primitives;
- complete preflight presentation primitives.

### Batch 2C — causal VFX
- event feedback set;
- Reduced Motion equivalents.

A batch may reuse shared semantic primitives introduced by an earlier batch. Each batch must preserve `runtime_integrated=false`.

## 12. Non-goals

This design does not:
- modify gameplay/domain rules;
- hook assets into Godot scenes;
- author Theme/Animation/Resource/signal wiring;
- change `project.godot`;
- claim Windows physical, Android device, connected editor, or human PASS;
- untrack `.asset-vault`;
- perform release cutover.

## 13. Success condition

The semantic asset package is implementation-ready when every approved in-scope state has either:

- an explicit independent product asset; or
- a documented reusable product primitive/composition that conveys the same state without ambiguity,

and the static contract proves that no new semantic meaning was inferred from unnamed legacy atlas regions.