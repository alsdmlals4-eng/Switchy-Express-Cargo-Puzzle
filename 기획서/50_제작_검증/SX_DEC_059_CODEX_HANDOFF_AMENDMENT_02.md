# SX-DEC-059 Codex Handoff · Amendment 02

```yaml
status: BINDING
parent_handoff: SX_DEC_059_CODEX_HANDOFF_PACKAGE.md
handoff_amendment_01: SX_DEC_059_CODEX_HANDOFF_AMENDMENT_01.md
implementation_amendment_01: docs/superpowers/plans/2026-08-20-sx-dec-059-implementation-amendment-01.md
implementation_amendment_02: docs/superpowers/plans/2026-08-20-sx-dec-059-implementation-amendment-02.md
codex_handoff_trigger: USER_REQUESTED_CODEX_HANDOFF
trigger_state: NOT_PRESENT
```

Binding read order at actual execution:

```text
SX_DEC_059_CODEX_HANDOFF_PACKAGE.md
→ SX_DEC_059_CODEX_HANDOFF_AMENDMENT_01.md
→ SX_DEC_059_CODEX_HANDOFF_AMENDMENT_02.md
→ parent implementation plan
→ implementation Amendment 01
→ implementation Amendment 02
→ actual current code/tests
→ Task 1 RED
```

Amendment 02 specifically closes:

- required `title_key` fields in first-session sequence data;
- localized Lesson Card CTA keys;
- persistent HUD StagePolicy visibility after every model update;
- safe ProductFiniteSlice stage-policy application before/after `_ready()`;
- T1→T2 same-instance + same-layout signature regression proof.

Current execution state remains:

```text
CODEX HANDOFF REQUESTED: NO
CODEX EXECUTED: NO
BUILD: NOT_STARTED
```
