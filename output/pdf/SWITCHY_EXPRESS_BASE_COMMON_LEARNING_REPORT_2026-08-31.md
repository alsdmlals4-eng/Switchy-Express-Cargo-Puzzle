# Switchy Express - Base 공용 학습 보고서

이 문서는 Base 검토용 파생 제출본이다. 공용 후보 한 건만 담으며 Base 제안 등록, 승인, 구현, 출시 판정이 아니다.

| 구분 | 확인값 |
| --- | --- |
| 대상 프로젝트 | alsdmlals4-eng/Switchy-Express-Cargo-Puzzle |
| 프로젝트 흡수 전 기준 | `a165a31ddf3ba20d2ba0411f42cc9f5899b4753b` (2026-08-31 KST) |
| 프로젝트 흡수 source | `32e7a0872f02e19561b0552cafe09aeb7bac5681` |
| Base 비교 revision | `1f0ef9d8bdb1869c9ba25b33efdcb34cf2ccba83` |
| 조사 기간과 표본 | 2026-08-01~2026-08-31 KST, reachable main 640 commits, first-parent milestones 51개 |
| 프로젝트 흡수 기록 | `docs/operations/2026-08-31-project-learning-absorption.md` (`SX-LRN-20260831-01`) |
| 공용 후보 수 | 1개 - BCL-SX-001, OBSERVATION_ONLY |
| 이번 Base 실제 변경 | NOT PERFORMED |

## A. 공용 학습 핵심 요약

프로젝트는 두 가지 운영 교훈을 이미 현재 정본과 실제 검사 소비처에 반영했다. 첫째, 플레이어가 보는 제품 바이트가 바뀌면 이전 패키지 후보 검증을 승계하지 않는다. 둘째, 깨끗한 Godot 작업공간에서는 import를 테스트 이전의 별도 준비 단계로 실행한다. 두 원칙은 Base의 exact-source/evidence-transfer 및 fresh derived-cache 경계에 이미 존재하므로 중복 제출하지 않았다.

한 가지 좁은 관찰만 Base 검토 후보로 남겼다. Windows에서 생성되는 Godot cache가 깊은 하위 경로를 만들 수 있으므로, 일회성 Godot worktree는 짧은 Temp 루트 직계 경로에 만들어야 하며 정리가 부분 완료되면 잔여물을 사실대로 영수증화해야 한다. 이는 Base의 task-owned Godot process lifecycle을 대체하지 않고, 그 lifecycle이 직접 다루지 않는 경로 깊이와 filesystem 잔여물 경계를 보완한다.

| 확인됨 | 확인하지 않음 |
| --- | --- |
| 프로젝트 운영 규칙/회귀 테스트, merge readback, 부분 정리 잔여물 관찰 | 새 Base 구현, 다중 프로젝트 효과, Godot runtime, 사용자/플레이어 경험, 디바이스, 플랫폼, 법률, 출시 |

## B. 공용 후보 사례 - BCL-SX-001

### 작업 전 문제

임시 Godot worktree의 생성된 `.godot` shader-cache 하위 경로가 깊어져, 정확히 식별된 정리 대상도 완전히 제거되지 않았다. 넓은 재귀 삭제나 process-name 전체 종료는 사용자 작업과 보호 대상 규칙을 약화할 수 있어 사용하지 않았다.

```text
relative path: .worktrees/codex-wayside-hazards-salvage-20260830
observed reclaimable size: 137,790,617 bytes
status: PARTIAL - not removed
```

### 조사와 대안 비교

| 대안 | 판정 | 이유 |
| --- | --- | --- |
| 작업 보고에만 남긴다 | REJECT | 반복 방지와 stable consumer/test 경계가 없다. |
| 새 Base skill을 만든다 | REJECT | 문제 범위가 좁고 Base에 기존 Godot lifecycle owner가 있다. |
| 기존 lifecycle owner에 짧은 경로/부분 정리 receipt를 보강한다 | ADAPT | ownership을 보존하면서 누락된 경로 깊이 경계만 더한다. |

### 프로젝트에 이미 적용된 결과

Switchy는 PR #264에서 v4.8 adapter의 workspace artifact hygiene 절, Active Context의 현재 rule, execution-contract freshness regression에 최소 적용을 완료했다. 이번 작업은 이를 다시 만들지 않고 `SX-LRN-20260831-01` 영수증과 Active Context resume link로 현장 관찰을 연결한다.

- Godot 전용 임시 worktree는 configured Windows temporary root의 짧은 direct child로 만든다.
- 삭제 전 exact target, consumer/reference, branch/PR, dirty state, task-owned process를 읽는다.
- 정리 실패 또는 부분 완료 시 relative path, reason, remaining size, recovery condition을 기록한다.
- cleanup evidence를 runtime, player, human, platform, release PASS로 승격하지 않는다.

## C. 공용 작업구조의 최소 계약

| 계약 요소 | Base 검토 후보 |
| --- | --- |
| Consumer | Windows에서 disposable Godot worktree를 만들고 import/test 뒤 정리하는 task |
| Trigger | task가 temporary worktree 또는 task-launched Godot/import/test process를 소유할 때 |
| Inputs | exact path, branch/PR, dirty state, process ownership, consumer/reference, cleanup outcome |
| Procedure | 짧은 Temp direct child 선택 -> exact target 감사 -> cleanup -> Git/worktree readback |
| Output | PASS / PARTIAL / NOT_RUN receipt. PARTIAL은 path, reason, size, recovery condition을 포함 |
| Non-use | 문서 전용 작업 또는 Godot/worktree를 시작하지 않은 task |
| Failure and rollback | broad delete/kill 금지. 잔여물을 보존하고 동일 target 재검증 후에만 재시도 |
| Minimum verification | project-local policy/test entry point를 확인하고 cleanup claim을 runtime claim과 분리 |

### 다른 프로젝트 사용 예

다른 Windows Godot 프로젝트가 `C:\Temp\gdt-7f3`처럼 짧은 worktree를 만든 뒤 import와 test를 실행할 수 있다. 종료 뒤 동일 경로만 제거한다. 생성 cache 일부가 남으면 `PARTIAL` receipt에 상대 경로와 크기를 적고 삭제된 것처럼 보고하지 않는다. 이 예시는 설명용이며 다른 프로젝트에서 이미 검증된 채택 사례는 아니다.

## D. Base 기존 owner와 통합안

가장 가까운 Base owner는 `[수정제안서]/BCP-2026-046-work-godot-process-lifecycle/PROPOSAL.md`다. 이 owner는 task-launched process identity, safe shutdown, residual check, user-owned process 보호, cleanup/runtime claim 분리를 이미 다룬다.

향후 별도 승인된 Base proposal에서의 최소 통합안은 다음과 같다.

- 새 universal cleanup skill 대신 BCP-046 lifecycle owner에 Windows-only reference/checklist 한 절을 추가한다.
- deep cache/shader path를 생성할 수 있는 disposable Godot worktree에만 short temporary-root child를 요구한다.
- PARTIAL cleanup receipt를 relative path, reason, remaining-size field로 보강하되 existing no-broad-kill/no-broad-delete 경계를 유지한다.
- 승인 뒤에만 focused contract regression을 추가한다.

현재 Base 상태: NOT SUBMITTED, NOT APPROVED_FOR_IMPLEMENTATION, NOT IMPLEMENTED.

## E. 실패, 반례, 적용 한계

- 한 프로젝트의 한 관찰은 모든 filesystem, Godot version, project에서 같은 효과가 있음을 증명하지 않는다.
- 짧은 경로는 예방 수단일 뿐, unknown target을 안전하게 삭제하는 권한을 만들지 않는다.
- project-specific residual path, branch, Godot version, cache content, test count는 공용 계약 값이 아니다.
- cleanup PASS는 runtime, player readability, audio, device, human review, platform/legal/release PASS가 아니다.
- Base BCP-025의 fresh import boundary와 Base exact-source/evidence-transfer rule은 이미 존재하므로 중복 제안하지 않는다.

## F. 공용 후보 근거 부록

| 근거 | 확인 내용 |
| --- | --- |
| Project receipt SX-LRN-20260831-01 | 분류, local residual receipt, project absorption, Base non-mutation boundary, Active Context resume link |
| PR #264 / `a165a31...` | workspace hygiene rule과 regression test가 project main에 병합됨 |
| Project v4.8 adapter section 8A | short temporary worktree, protected cleanup target, partial residual handling |
| `tests/python/test_execution_contract_freshness.py` | hygiene contract와 learning receipt를 지키는 machine consumer |
| PR #97 / `42d6a173...` | fresh-import diagnosis. 기존 Base-owned learning으로 제외 |
| Base BCP-025 / BCP-046 | duplicate exclusion / nearest lifecycle owner respectively |

### PDF 검수 기록

2026-08-31에 이 Markdown 파생 원고로 PDF를 생성하고 A4 3쪽 전체를 PNG로 렌더링해 검사했다. 한글 글꼴, 잘림, 겹침, 빈 페이지, 표 넘침, 머리말과 쪽번호는 발견되지 않았다. 텍스트 추출에는 `BCL-SX-001`, `OBSERVATION_ONLY`, `NOT SUBMITTED`, `NOT PERFORMED`, `32e7a0872f02e19561b0552cafe09aeb7bac5681`, `공용 후보`가 포함됨을 확인했다. 이 검수는 PDF 표현과 텍스트 추출에 한정되며, Base 채택·runtime·사용자 검수의 PASS를 뜻하지 않는다.
