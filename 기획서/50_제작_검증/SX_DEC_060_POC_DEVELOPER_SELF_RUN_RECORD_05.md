# SX-DEC-060 POC Machine Validation Record 05

Status: `MACHINE_PRIMARY_PACKAGE_EVIDENCE · FINAL_USER_REVIEW_NOT_RUN`

## Exact candidate

```yaml
candidate_id: SX60-POC-ACCEPT-005
source_main: a11dfd1a063e434ee22e8cfb7b073ebc380aa27a
artifact_evidence_owner: evidence/acceptance/sx60_poc_accept_005_artifact.json
package_audit_owner: evidence/acceptance/sx60_poc_accept_005_pck_deep_audit.json
```

GitHub Actions run `33301925424` dispatched from that exact `main` SHA and completed successfully. The current pointer binds no other artifact. Its package integrity, exported runtime JSON proof, and independent PCK audit are machine evidence only.

`RUN_SX60_POC_SELF_RUN.ps1 -ContractCheck` passed on 2026-08-30 and resolved only `SX60-POC-ACCEPT-005`. The exact-candidate `-NoLaunch` verification then downloaded the bound artifact, checked its API digest and EXE/PCK hashes, and confirmed both packaged runtime JSON proofs without launching the game. Neither command claims player evidence.

## Evidence ceiling

This record does not claim Windows physical input/visual inspection, audio perception, Android-device execution, accessibility review, five-person comprehension, player-experience study, production cutover, or user approval. Five-person comprehension and player-experience study are not required by `SX-DEC-065`; a final user review remains optional and `NOT_RUN` on this unchanged candidate.
