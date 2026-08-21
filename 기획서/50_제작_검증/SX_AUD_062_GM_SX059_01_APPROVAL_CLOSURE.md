# SX-AUD-062 · GM-SX059-01 Approval Closure

```yaml
audit_id: SX-AUD-062
related_decision: SX-DEC-059
decision_question: GM-SX059-01
status: USER_APPROVED · CLOSED
approval: "2026-08-20 KST · 권장안 승인, 연속작업 진행"
selected: A_PREREQUISITE_ACTION_EARLY_STRATEGY_LATER
work_mode: PLAN
implementation_authority: NOT_GRANTED
protected_open_pr: "#154 · READ_ONLY"
```

## 확정

기존 Tutorial 순서를 유지하면서 같은 manual-load 기능을 두 단계의 학습 깊이로 나눈다.

```text
T2 · Cargo / Station
→ 화물을 싣기 위해 `적재`를 누르는 기본 prerequisite action만 just-in-time으로 학습
→ 같은 종류 역에서 자동 하역 관찰

T4 · Selective Manual Load
→ `적재하지 않는 것`도 선택임을 학습
→ 첫 통과에서 일부 화물을 의도적으로 건너뛰어 LIFO 순서를 설계
→ 남은 화물을 재방문하여 적재
```

## 보호 대상

- 제품 기본 상태는 `manual_load_active=false`, `auto_load_enabled=false` 그대로 유지.
- auto load는 T5에서 별도 선택 도구로 처음 명시 학습.
- pickup eligibility, LIFO, station pop, time, route, map rule 변경 없음.
- tutorial-only auto assist / preloaded stack / hidden state 금지.
- T2에서 selective strategy를 요구하지 않음.
- T4는 버튼 사용법 반복이 아니라 **왜 이번 화물을 싣지 않는가**를 판단하는 퍼즐이어야 함.

## T2 acceptance

- cargo 접근 전 contextual cue는 최대 1개.
- cue는 현재 manual-load input을 가리키며 자동 조작하지 않음.
- player가 직접 load input을 사용해 cargo pickup을 발생시킴.
- 같은 종류 station에서 current automatic unload를 관찰.
- 이 단계에서 cargo skip이 성공 조건이 되지 않음.

## T4 acceptance

- 최소 한 화물은 첫 통과에서 적재하지 않는 선택이 의미 있게 필요.
- skip한 화물은 current rule대로 map에 남고 재방문 가능.
- 플레이어가 hold/release를 이용해 목표 load order를 스스로 형성.
- 성공 후 `왜 첫 통과에서 그 화물을 싣지 않았는가`를 설명 가능한 구조.
- capacity 제한, cargo lock, 강제 pause, scripted failure 없음.

## Alternative disposition

- B tutorial auto assist: REJECT · 제품 기본값과 다른 mental model.
- C preloaded stack: REJECT · 새 domain initialization/API 필요.
- D curriculum reorder: REJECT_FOR_CURRENT_SLICE · 승인된 Tutorial 순서 변경 비용이 불필요.

## 후속

`GM-SX059-01`은 더 이상 planning blocker가 아니다.

```text
T1~T6 exact content/map contract
→ localization copy matrix
→ acceptance/TDD contract
→ adversarial clean recheck
→ explicit user "기획 완료" gate
```

현재: `PLAN_CONTINUES · BUILD_NOT_AUTHORIZED`.
