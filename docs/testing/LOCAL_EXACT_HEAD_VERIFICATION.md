# Local Exact-HEAD Verification

```yaml
decision_id: SX-DEC-047
audit_id: SX-AUD-028
status: ACTIVE_TEMPORARY_FALLBACK
reason: GITHUB_HOSTED_ACTIONS_BUDGET_UNAVAILABLE
matrix:
  - Windows Python 3.11
  - Windows Python 3.12
  - Windows Python 3.13
  - WSL2 Ubuntu Python 3.12
full_project_runtime: Windows Godot 4.7.1 + legacy regression + GUT 9.7.1
```

## 검증 구조

Python 계약 테스트는 Windows `py` 런처의 3.11·3.12·3.13과 WSL2 Ubuntu의 `python3.12`에서 실행한다. WSL2에서도 `git rev-parse HEAD`와 clean status를 독립 확인해 동일 exact HEAD를 증명한다. 이후 Windows Python 3.12로 project contract를 실행하고, Windows Godot 4.7.1에서 legacy 회귀와 GUT 9.7.1 JUnit을 한 번 실행한다. WSL2에서 Windows Godot 실행 파일을 재사용하지 않는다.

모든 Python 실행은 `-B`와 `PYTHONDONTWRITEBYTECODE=1`을 사용해 `__pycache__`가 작업 트리를 오염시키지 않게 한다.

## 실행 명령

```powershell
Set-Location "C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle"
git fetch --prune origin
git switch <pr-branch>
git pull --ff-only origin <pr-branch>
$ExpectedHead = git rev-parse HEAD

./tools/run_local_exact_head_verification.ps1 `
  -ExpectedHead $ExpectedHead `
  -GodotExecutable "C:/path/to/Godot_v4.7.1-stable_win64.exe" `
  -WslDistribution "Ubuntu" `
  -WslPythonExecutable "python3.12"
```

## 외부 산출물

```text
%TEMP%/SwitchyExpress/local-exact-head/<head-prefix>/python-matrix.json
%TEMP%/SwitchyExpress/local-exact-head/<head-prefix>/windows-python-3.11.log
%TEMP%/SwitchyExpress/local-exact-head/<head-prefix>/windows-python-3.12.log
%TEMP%/SwitchyExpress/local-exact-head/<head-prefix>/windows-python-3.13.log
%TEMP%/SwitchyExpress/local-exact-head/<head-prefix>/wsl-ubuntu-python-3.12.log
%TEMP%/SwitchyExpress/local-exact-head/<head-prefix>/gut-junit.xml
%TEMP%/SwitchyExpress/local-exact-head/<head-prefix>/local-verification.json
```

`python-matrix.json`은 네 환경의 실제 Python 버전, exit code, 실행 시간, 로그 파일명, exact HEAD를 기록한다. 절대 사용자 경로와 stdout/stderr 원문은 최종 증거 요약에 넣지 않는다.

## 필수 실패 코드

- `PYTHON_MATRIX_TARGETS_MISMATCH`
- `PYTHON_MATRIX_TARGET_FAILED`
- `PYTHON_MATRIX_HEAD_MISMATCH`
- `PYTHON_MATRIX_VERSION_MISMATCH`
- `WSL_HEAD_MISMATCH`
- `WSL_DIRTY_WORKTREE`
- `HEAD_MISMATCH`
- `DIRTY_WORKTREE`
- `POST_RUN_DIRTY_WORKTREE`
- `GODOT_VERSION_MISMATCH`
- `GUT_DISCOVERY_BELOW_MINIMUM`
- `GUT_JUNIT_FAILURE`
- `PRODUCTION_MUTATION`

## PR 증거

```text
LOCAL_EXACT_HEAD_VERIFICATION: PASS
HEAD: <40-character SHA>
PYTHON_MATRIX: Windows 3.11 PASS · Windows 3.12 PASS · Windows 3.13 PASS · WSL2 Ubuntu 3.12 PASS
GODOT: 4.7.1-stable
GUT: discovered=<n> failures=0 errors=0
PRODUCTION_MUTATION: false
MATRIX_SHA256: <python-matrix.json sha256>
MANIFEST_SHA256: <local-verification.json sha256>
LIMITATIONS: HIGODOT_CONNECTION_NOT_VERIFIED; WINDOWS_RUNTIME_SMOKE_NOT_INCLUDED; ANDROID_DEVICE_NOT_RUN; HUMAN_COMPREHENSION_NOT_RUN
```

GitHub-hosted run은 `[skip actions]` 때문에 `NOT_RUN`이며 PASS로 표기하지 않는다. 새 커밋이 생기면 이전 매트릭스와 manifest는 무효다.
