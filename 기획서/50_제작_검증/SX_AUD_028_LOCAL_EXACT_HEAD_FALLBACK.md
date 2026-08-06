# SX-AUD-028 — Local Exact-HEAD Fallback Audit

```yaml
audit_id: SX-AUD-028
decision_id: SX-DEC-047
approval_batch_id: GMB-005
date: 2026-08-07
validation_mode: WINDOWS_WSL2_MATRIX
python_targets:
  - WINDOWS_3_11
  - WINDOWS_3_12
  - WINDOWS_3_13
  - WSL2_UBUNTU_3_12
full_project_target: WINDOWS_GODOT_4_7_1
GAMEPLAY_UNCHANGED: true
WINDOWS_FULL_PROJECT_NOT_RUN: true
ANDROID_DEVICE_NOT_RUN: true
HIGODOT_CONNECTION_NOT_VERIFIED: true
```

사용자가 Windows와 WSL2 환경을 모두 설치했다고 확인했다. 따라서 GitHub-hosted Actions 매트릭스에 가장 가까운 로컬 재현 범위로 Python 4개 환경을 채택한다. Godot/GUT는 Windows exact HEAD에서 실행하고, WSL2는 Python 계약 재현에 한정한다.

PR #103 초기 구현의 적대적 검토에서 Python bytecode가 `__pycache__`를 만들면 post-run dirty gate가 자기 자신 때문에 실패할 수 있고, Git 오류 코드 문자열에 비ASCII 오타가 있는 결함을 발견했다. `-B`, `PYTHONDONTWRITEBYTECODE=1`, hardened entry의 `GIT_COMMAND_FAILED`로 교정한다.

WSL2는 Windows 경로를 `wslpath`로 변환한 뒤 `git rev-parse HEAD`와 clean status를 독립 확인한다. 네 Python target 중 하나라도 누락·실패·버전 불일치·HEAD 불일치면 전체 검증을 실패시킨다.

현재 환경에서는 Windows/WSL2 실제 실행을 할 수 없으므로 도구의 Python 단위 계약만 컨테이너에서 검증한다. 전체 매트릭스와 Godot/GUT PASS는 사용자 Windows checkout에서 exact PR HEAD로 실행하기 전까지 `NOT_RUN`이다.
