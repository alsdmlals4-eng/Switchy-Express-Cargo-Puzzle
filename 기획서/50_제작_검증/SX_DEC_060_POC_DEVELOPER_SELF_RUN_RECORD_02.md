# SX-DEC-060 POC Developer Self-Run Record 02

Status: `PACKAGE_VERIFICATION_PASS · PROCESS_STARTUP_OBSERVED_UNVISUALIZED`

```yaml
candidate_id: SX60-POC-ACCEPT-002
pointer: evidence/acceptance/post_sx_dec_060_candidate.json
source_main: 0e882764b837d13282a7642b115948d4e061d163
artifact_evidence_owner: evidence/acceptance/sx60_poc_accept_002_artifact.json
deep_pck_evidence_owner: evidence/acceptance/sx60_poc_accept_002_pck_deep_audit.json
candidate_zip_sha256: b2602554ec28ba8597cc509c6dc2e1b61a946ca193a31673ed96bf9671c8c8e3
no_launch_package_verification: PASS · 2026-08-27 · explicit Candidate 002 NoLaunch PowerShell verification
physical_self_run_verdict: PROCESS_STARTUP_OBSERVED_UNVISUALIZED
observed_date_kst: 2026-08-27
observation_method: explicit Candidate 002 launcher live download and start
exact_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
process_observation: RUNNING_AND_RESPONDING
visual_input_audio_verdict: NOT_OBSERVED
evidence_ceiling: STARTUP_ONLY_NOT_PHYSICAL_VISUAL_OR_HUMAN_ACCEPTANCE
```

From current project `main`, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\RUN_SX60_POC_SELF_RUN.ps1
```

The launcher downloaded and started only the explicit Candidate 002 artifact after archive/API digest, EXE/PCK hash, proof-log, and source-ancestry checks. The exact EXE process was observed running and responding, then stopped as QA cleanup. The multi-window desktop capture did not isolate the candidate window, so this record does not claim a visual, input, audio, human, device, or player-experience result. Those observations remain separate and required.
