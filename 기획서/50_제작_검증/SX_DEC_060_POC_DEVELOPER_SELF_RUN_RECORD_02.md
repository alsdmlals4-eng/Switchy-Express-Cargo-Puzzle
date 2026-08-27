# SX-DEC-060 POC Developer Self-Run Record 02

Status: `PACKAGE_VERIFICATION_PASS · ISOLATED_VISUAL_INPUT_OBSERVED · AUDIO_NOT_OBSERVED`

```yaml
candidate_id: SX60-POC-ACCEPT-002
pointer: evidence/acceptance/post_sx_dec_060_candidate.json
source_main: 0e882764b837d13282a7642b115948d4e061d163
artifact_evidence_owner: evidence/acceptance/sx60_poc_accept_002_artifact.json
deep_pck_evidence_owner: evidence/acceptance/sx60_poc_accept_002_pck_deep_audit.json
candidate_zip_sha256: b2602554ec28ba8597cc509c6dc2e1b61a946ca193a31673ed96bf9671c8c8e3
no_launch_package_verification: PASS · 2026-08-27 · explicit Candidate 002 NoLaunch PowerShell verification
physical_self_run_verdict: ISOLATED_TITLE_BRIEFING_BUILD_VISUAL_AND_BUTTON_INPUT_OBSERVED
observed_date_kst: 2026-08-27
observation_method: explicit Candidate 002 launcher live download and targeted returned-window capture
exact_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
process_observation: RUNNING_AND_RESPONDING
visual_input_verdict: OBSERVED · exact returned candidate window only
audio_verdict: NOT_OBSERVED
evidence_ceiling: ISOLATED_VISUAL_INPUT_ONLY_NOT_AUDIO_DEVICE_OR_HUMAN_ACCEPTANCE
```

From current project `main`, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\RUN_SX60_POC_SELF_RUN.ps1
```

The launcher downloaded and started only the explicit Candidate 002 artifact after archive/API digest, EXE/PCK hash, proof-log, and source-ancestry checks. The exact EXE process was observed running and responding. A targeted capture then selected the one returned window whose process path was the downloaded Candidate 002 EXE and whose title was `Switchy Express: Cargo Puzzle (DEBUG)`. On that exact window, the title screen, `Demo Start` → briefing, and `Build Start` → build board transitions were observed through button input. The owned process was then stopped as QA cleanup.

The earlier desktop-wide capture did not isolate the candidate window and is retained only as a failed observation route. The targeted recovery verifies visual and button-input behavior only. It does not claim audio perception, Windows full physical scenarios, Android device behavior, five-person comprehension, or player experience; those observations remain separate and required.
