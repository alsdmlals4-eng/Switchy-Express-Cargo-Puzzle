# SX-DEC-060 POC Developer Self-Run Record 07

Status: `MACHINE_PRIMARY_PACKAGE_EVIDENCE · CURRENT_POINTER_CONTRACT_READBACK_PASS · FINAL_USER_REVIEW_NOT_RUN · NO_LAUNCH_RECHECK_NOT_RUN`

## Exact candidate

```yaml
candidate_id: SX60-POC-ACCEPT-007
source_main: c0bb86efa5bad6050217ca67dd6aa9eba155dc75
artifact_evidence_owner: evidence/acceptance/sx60_poc_accept_007_artifact.json
deep_pck_evidence_owner: evidence/acceptance/sx60_poc_accept_007_pck_deep_audit.json
```

GitHub Actions run `33382094895` was dispatched from a temporary ref that resolves exactly to the source SHA above and completed successfully. The candidate pointer binds no other artifact. Package integrity, exported runtime JSON proof, and the independent PCK audit are machine evidence only.

`RUN_SX60_POC_SELF_RUN.ps1 -ContractCheck` passed on 2026-08-31 and resolved only `SX60-POC-ACCEPT-007`. The optional `-NoLaunch` download receipt is intentionally separate and has not run; it must not launch the game or be interpreted as player evidence.

## Evidence ceiling

This record does not claim Windows physical input/visual inspection, audio perception, Android-device execution, accessibility review, five-person comprehension, player-experience study, production cutover, or user approval. Five-person comprehension and player-experience study are not required by SX-DEC-065; final user review remains optional and `NOT_RUN` on this unchanged candidate.
