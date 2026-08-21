# SX-DEC-059 Codex Handoff · Amendment 01

```yaml
status: BINDING
parent_handoff: SX_DEC_059_CODEX_HANDOFF_PACKAGE.md
parent_plan: docs/superpowers/plans/2026-08-20-sx-dec-059-first-session-vertical-slice-implementation.md
implementation_amendment: docs/superpowers/plans/2026-08-20-sx-dec-059-implementation-amendment-01.md
codex_handoff_trigger: USER_REQUESTED_CODEX_HANDOFF
trigger_state: NOT_PRESENT
```

At actual handoff, Codex MUST read the implementation amendment immediately after the parent implementation plan. The amendment overrides:

1. the illustrative hard-coded repository path in the parent preflight;
2. API-sketch `pass` placeholders for `FirstSessionDefinition` and `FirstSessionStagePolicy`;
3. any interpretation that exact tutorial map cell coordinates should be guessed before RED behavioral tests.

Binding execution read order:

```text
SX_DEC_059_CODEX_HANDOFF_PACKAGE.md
→ parent implementation plan
→ 2026-08-20-sx-dec-059-implementation-amendment-01.md
→ actual current code/tests
→ execute Task 1 RED
```

Use remote-identity LOCATION FIRST from the handoff package. If zero/multiple local checkouts match, block instead of cloning/guessing.

Current status remains:

```text
CODEX HANDOFF REQUESTED: NO
CODEX EXECUTED: NO
GODOT BUILD: NOT_STARTED
```
