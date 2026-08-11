# SX-AUD-050 · Playtest Routing and Conditional Acceptance Refresh

Status: `CANON_FRESHNESS_REPAIR · PLANNING_ONLY · MERGE_REQUIRES_EXACT_HEAD_PASS`

Date: `2026-08-11 KST`

## Finding

After `SX-DEC-056~058` approval and `SX-AUD-049` same-ID reconciliation, `PLAYTEST_PLAN.md` still exposed a stale current header/conclusion:

- `PHASE_A_PLANNING`;
- product authority `SX-DEC-027~055`;
- planning audit `SX-AUD-044`;
- user planning-complete gate `NOT_GRANTED`;
- Phase B `NOT_RUN`.

The body already contained the correct acceptance-build identity discipline and the core FS-01~12 comprehension contract. The issue was current-routing metadata plus the absence of a conditional human-validation mapping for newly approved player-facing `SX-DEC-056/057` work.

## Repair

`PLAYTEST_PLAN.md` is refreshed to:

```yaml
phase_b: PASS · SX-AUD-047
product_authority: GMB-002 · SX-DEC-027~058
planning_audit: SX-AUD-049
build_authority_scope: SX-DEC-055_ONLY
sx_dec_056_058_implementation: NOT_STARTED · DELTA_DOR_REQUIRED
acceptance_build: UNASSIGNED
physical_smoke: NOT_READY
five_person: NOT_RUN
```

The existing FS-01~12/HUM-01~13 contract is preserved.

Conditional additions apply only if `SX-DEC-056/057` are actually implementation-authorized and included in the tested acceptance build:

- Route Probe interpretation / probe-to-run comparison;
- actual-event Debrief causality;
- Yard Lab campaign transfer;
- Mastery optionality/progression understanding.

These additions do not authorize implementation and do not make 056/057 a prerequisite for the existing `SX-DEC-055` POC acceptance lane.

## Protected boundaries

- no runtime/code/test/workflow/asset/export mutation;
- no acceptance build invented;
- no physical/device/human PASS inflation;
- no change to the existing minimum analyzable session count or 4/5 threshold policy;
- no change to SX-DEC-055 first implementation step;
- no implementation authority for SX-DEC-056~058;
- BMK-R09/R10 remain post-validation hold;
- production cutover remains blocked/deferred.

## Merge gate

Exact PR head must pass repository-required checks before merge. After merge, configured Sheet current routing will be updated to the merge-main SHA and read back.
