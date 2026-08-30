# SX-DEC-065 · Machine-primary validation with final user review

**Status:** `USER_APPROVED · CURRENT_POLICY`

**Date:** 2026-08-30 KST
**Approval source:** User direction in this task: machine verification is the main acceptance route; five-person comprehension and player-experience studies are not to be run; user validation is reserved for the final review.
**Scope:** Current Switchy Express validation governance and its exact-candidate workflow. This changes no game rule, scene, asset, package byte, platform target, release-rights requirement, or prior evidence record.

## Decision

`MACHINE_PRIMARY_FINAL_USER_REVIEW` is the current validation policy.

```text
exact source/build identity
→ deterministic contracts + automated runtime/package verification
→ machine acceptance decision
→ optional final user review on the same exact candidate
→ user-directed release/cutover decision when requested
```

The following are **not required acceptance gates** for this project:

```text
FIVE_PERSON_COMPREHENSION_NOT_REQUIRED
PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED
```

No substitute human study, fixed participant count, or implicit player-experience threshold may be introduced to recreate either gate. A final user review is intentionally narrower: it is the product owner's final inspection of a named exact candidate, not a five-person research study and not evidence that replaces machine verification.

## Evidence boundary

Machine acceptance is based on the applicable exact-head evidence: deterministic unit/contract tests, Godot runner, export/package integrity, runtime payload proof, CI, and any supported device automation required for the release target.

```text
Machine evidence never becomes human evidence.
Human evidence never retroactively changes the machine result.
```

Accordingly:

- an unrun final user review is `NOT_RUN`, not `PASS`;
- an unrun Windows physical/audio observation is `NOT_RUN` and does not block machine acceptance unless a later user-approved release decision makes it a final-review requirement;
- Android device evidence remains a separate machine/device compatibility concern when the Android target is in scope; no historical APK identity may be reused;
- release-rights, store, accessibility, and platform obligations retain their own owners and are not passed by this policy;
- historic `NOT_RUN` five-person and player-experience records remain historical evidence; they are not rewritten as passes.

## Alternatives considered

| Option | Result | Reason |
| --- | --- | --- |
| Keep five-person and player-experience as required release blockers | Rejected | Conflicts with the user-approved machine-primary workflow. |
| Remove all user review | Rejected | Conflicts with the requested final user inspection. |
| Machine-primary acceptance with a separately recorded final user review | Adopted | Preserves deterministic evidence as the primary signal while retaining the user's final inspection authority. |

## Research and feasibility disposition

`NOT_MATERIAL_FOR_SELECTION`: this is a user-owned governance priority, not a claim that player research is invalid. The current Base Games User Research owner already rejects universal 11-domain coverage, fixed research methods, and fixed sample counts. The actual Godot/package consumers already expose deterministic runner, export, PCK, and CI evidence routes, so no new engine, service, data schema, or asset is required.

## Current application

1. Mint a new immutable candidate after the v04 rail/runtime-byte change from its exact source revision.
2. Run the candidate's supported machine validation and retain the resulting evidence ceiling.
3. Do not schedule or block on five-person comprehension or player-experience sessions.
4. When the user asks for final inspection, present the exact candidate and record only the review actually performed.

## Guardrails and rollback

- This decision does not authorize release, store submission, legal approval, a human-pass claim, gameplay expansion, or PR #174 work.
- A project-specific future decision may require a narrowly defined human study only with new explicit user approval; it must not be inferred from this policy.
- Rollback is a revert of this decision and its current-gate projections. Historical candidate and study records remain intact.

## Five-scope adversarial review receipt

`FIVE_SCOPE_ADVERSARIAL_REVIEW_CLOSED · 2026-08-30 KST · policy source revision pending PR merge`

| Scope | Review question | Result and correction |
| --- | --- | --- |
| 1. Authority and scope | Does the policy overreach into gameplay, release, or prior evidence? | Clean. The decision is limited to validation governance; gameplay, platform, rights, release, and historical evidence remain separately owned. |
| 2. Current versus historical documentation | Do any current hubs still make five-person comprehension or player-experience a required next gate? | Finding corrected. Current hubs and the active section of the playtest plan now route to machine-primary validation; prior research material is explicitly `HISTORICAL_METHOD_REFERENCE_ONLY`. |
| 3. Exact-candidate eligibility | Can a prior package candidate be launched as the current final-review candidate? | At policy adoption, the finding was corrected by setting the pointer to `NOT_CREATED`, preserving prior candidates as immutable evidence, and fail-closing the launcher. Candidate 006 was subsequently minted after Route Book 01 from exact `main@9af5a8c46d29ea6781f9ee06008d7c7d2cde1877`; Candidate 005 remains historical and Candidate 006 final user review remains `NOT_RUN`. |
| 4. Evidence-boundary integrity | Do machine results accidentally become human/user approval, or do historic `NOT_RUN` values get erased? | Clean. Machine and human evidence remain distinct; historic evidence is preserved and the final user review remains `NOT_RUN`. |
| 5. Consumer and regression coverage | Do the registered owners, protected approval, JSON documents, contract validator, and project/Base regressions agree? | Clean after corrections. Project JSON parses, project contract validation passes, project Python regression is `229 passed, 1 skipped`, and the affected Base regression set is `29 passed`. |
