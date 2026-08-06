# Windows + WSL2 Local Exact-HEAD Verification Design

```yaml
approval_batch_id: GMB-005
decision_id: SX-DEC-047
audit_id: SX-AUD-028
scope: validation infrastructure only
```

Python 계약 테스트를 Windows 3.11·3.12·3.13과 WSL2 Ubuntu 3.12에서 실행한다. Windows 3.12는 full verifier의 Python 권위이며, Windows Godot 4.7.1에서 project contract·legacy 회귀·GUT 9.7.1 JUnit·production mutation guard를 실행한다.

`python-matrix.json`이 exact HEAD와 네 target 결과를 기록하고 독립 matrix validator가 이를 다시 검증한다. 네 target 중 하나라도 누락·실패·버전 불일치·HEAD 불일치면 전체 실패다. WSL2에서도 HEAD와 clean status를 독립 확인한다.

모든 Python 실행에 `-B`와 `PYTHONDONTWRITEBYTECODE=1`을 적용해 `__pycache__` 자기오염을 막는다. 기존 verifier는 hardened compatibility entry를 통해 `GIT_COMMAND_FAILED` 오류 코드를 안정화한다.

GitHub workflow, gameplay, `project.godot`, Scene, Resource, binary asset은 변경하지 않는다. Hosted Actions는 `[skip actions]`로 `NOT_RUN` 처리한다.
