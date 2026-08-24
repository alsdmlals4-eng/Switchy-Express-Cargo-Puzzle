# SX-DEC-059 · Playable POC Acceptance Candidate 03

Date: `2026-08-24 KST`  
Status: `PREPARED · PENDING_PHYSICAL_VISUAL_RECHECK`

```yaml
candidate_id: SX59-POC-ACCEPT-003
supersedes_candidate: SX59-POC-ACCEPT-002
supersedes_reason: CANDIDATE_002_PHYSICAL_STARTUP_FOUND_P1_PREFLIGHT_VISUAL_DEFECTS_FIXED_BY_PR_171
current_pointer: evidence/acceptance/current_poc_candidate.json
artifact_evidence_owner: evidence/acceptance/sx59_poc_accept_003_artifact.json
deep_pck_evidence_owner: evidence/acceptance/sx59_poc_accept_003_pck_deep_audit.json
corrected_runtime_pr: 171
corrected_pr_head: 3c871c6ab752492ec706cc3bd81ed4d471d0054f
corrected_merge_main: 9d82b004b2ebf3f7d69d0376c79daae1040e94a4
corrected_tree_sha: e3b6154a3042808fbc2fc62d5a3c6487e3d2a40f
artifact_workflow_run_id: 32715351609
artifact_workflow_run_number: 351
artifact_id: 9515705015
artifact_zip_sha256: 8b4e630c667b5fd88886878e5a07401c1fe6cfd8f1f9d84b2ab39cb8824923d4
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: 2e9634cedd6da49793973f4582e2bd58ea4daae2fec246657edcf58ae360af72
package_integrity: PASS
pck_deep_integrity: PASS · 472/472 MD5
product_texture_packaging: PASS · 73/73
physical_visual_recheck: NOT_RUN
developer_self_run: NOT_RUN
acceptance_build: NOT_YET_DESIGNATED
windows_physical_runtime_full_scenarios: NOT_RUN
audio_perceptual_qa: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

## Why Candidate 003 exists

Candidate 002 is retained as immutable evidence because it proved the exact package could start on the user's Windows / NVIDIA GeForce RTX 3050 environment. That physical run also exposed two P1 presentation defects:

1. the preflight semantic badge stretched across the banner and overlapped Korean problem copy;
2. the board-level preflight composition could cover required station/cargo identity.

PR #171 changed player-visible presentation bytes to fix both. Therefore Candidate 002 cannot be promoted even though its startup smoke passed.

## Candidate 003 correction contract

- `ProblemBanner` uses a horizontal layout: approved semantic badge at `112×48`, text in the remaining lane.
- problem cells keep the high-contrast problem outline without drawing the full HUD preflight composition over cargo/station identity.
- approved image assets themselves are unchanged.
- gameplay/domain rules, map semantics, audio implementation and deferred SX-DEC-056A/056B/057/058 remain unchanged.

## Physical recheck gate

Before continuing the full eight-scenario self-run, visually verify on Candidate 003:

```text
A. top preflight badge no longer stretches across or overlaps the Korean problem text
B. disconnected station/cargo identity remains visible; only the problem outline reinforces the cell
```

If either check fails, record `BLOCKED_P1_VISUAL` and do not designate an acceptance build.

If both pass, continue the eight-scenario Developer Self-Run Record 03 and actual audio perceptual QA on the same exact Candidate 003 bytes.

## Evidence ceiling

Package/CI/PCK integrity does not prove the corrected physical presentation. `physical_visual_recheck`, full Windows self-run, audio perceptual QA, Android device, five-person comprehension and player experience remain `NOT_RUN` until actually observed.
