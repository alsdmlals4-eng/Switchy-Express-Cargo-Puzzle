# SX-DEC-047 — Local Exact-HEAD Verification Fallback

```yaml
decision_id: SX-DEC-047
approval_batch_id: GMB-005
audit_id: SX-AUD-028
approved_by: user
approved_at: 2026-08-07 KST
status: APPROVED_ACTIVE_TEMPORARY
execution_pack: Windows + WSL2
```

GitHub-hosted Actions 예산이 없을 때 검증 실행 위치만 Windows + WSL2 로컬 팩으로 전환한다. exact HEAD, TDD, GUT 9.7.1 JUnit, legacy 회귀, production mutation hash, diff 검토와 merged-main readback은 그대로 유지한다.

Python 호환성 매트릭스는 Windows 3.11·3.12·3.13과 WSL2 Ubuntu 3.12다. Godot/GUT 전체 프로젝트 검증은 Windows Godot 4.7.1에서 수행한다. WSL2는 Python 재현 범위이며 Windows Godot의 대체 런타임으로 주장하지 않는다.

모든 Python 테스트는 `-B`와 `PYTHONDONTWRITEBYTECODE=1`을 사용한다. WSL2에서도 HEAD와 clean worktree를 독립 확인한다. `python-matrix.json`과 `local-verification.json`은 저장소 밖 임시 경로에 생성하며 exact HEAD와 SHA-256으로 PR에 결박한다.

이 결정은 `project.godot`, Scene, Resource, gameplay 파일 또는 기존 workflow 변경 권한을 추가하지 않는다. `[skip actions]`는 hosted run을 생략할 뿐 PASS가 아니다.
