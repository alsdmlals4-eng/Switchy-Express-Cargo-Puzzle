# Switchy Express · Visual Iteration Problem → Lesson · 2026-08-25

Status: `PROJECT_EVIDENCE · BASE_PROMOTION_CANDIDATE_SOURCE`

이 문서는 2026-08-25 Visual 작업에서 실제 발생한 문제와 재사용 가능한 교훈을 분리한다. 프로젝트 고유 art style, 색상, 캐릭터, 수치, asset 경로는 Base 공용 규칙으로 직접 승격하지 않는다.

## 1. 문제: 요청한 한 화면이 전체 프로젝트 인포그래픽으로 확장됨

### 관찰
`Capstone RUN Screen`처럼 한 visual question을 해결하려고 했지만 생성 결과가 전체 프로젝트 대시보드/설명 보드로 범위를 넓힌 사례가 반복됐다.

### 문제
- 결과 자체가 보기 좋아도 요청한 질문에 직접 답하지 않을 수 있다.
- 잘못 넓어진 결과를 그대로 승인하면 visual canon과 구현 명세가 섞인다.
- 생성 이미지 안에서 모델이 임의의 UI/규칙을 추가할 위험이 증가한다.

### 교훈
`VISUAL_TASK_SCOPE_FIDELITY` — 이미지 작업은 먼저 **한 이미지가 답할 명시적 질문/화면/상태**를 고정한다. 결과가 범위를 넓히면 동일 deliverable로 간주하지 않는다.

적용:
- single-screen mock
- component/state sheet
- before/after comparison
- visual QA evidence

비사용:
- 사용자가 처음부터 poster/dashboard/collage를 요청한 경우

## 2. 문제: 그림은 매력적이지만 분기/노선 판단성이 낮음

### 관찰
기존 Cozy Miniature / E+D Hybrid visual은 매력과 세계관은 유지됐지만, 실제 분기점에서 선택 경로·방향·점유/잠금이 배경과 경쟁할 수 있었다.

### 대안 비교

| 안 | 장점 | 위험 | 판정 |
| --- | --- | --- | --- |
| 전체 그림체 교체 | 큰 시각 변화 | 기존 asset 폐기 비용, 문제 원인이 style 자체가 아닐 수 있음 | `REJECT` |
| route color만 강하게 | 구현이 단순 | 색각/상태 혼동, color-only 회귀 | `REJECT` |
| 기존 style 유지 + semantic redundancy | 기존 정체성/asset 보존, 판단성 직접 개선 | 상태 규칙을 일관되게 관리해야 함 | `ADOPT` |

### 교훈
`DECISION_CRITICAL_VISUAL_SEMANTIC_REDUNDANCY` — 플레이 판단에 직접 쓰는 정보는 aesthetic style보다 우선하며, 가능한 경우 **서로 독립적인 복수 신호**로 전달한다.

Switchy 적용 예:
`color + direction + shape + brightness/thickness + state icon/motion`.

Base로 일반화할 때는 특정 색상·화살표 방향·선 두께 수치를 고정하지 않는다.

## 3. 문제: “3장 작업”이 한 이미지 안의 3개 패널로 생성됨

### 관찰
사용자가 이미지 작업을 **3장씩** 진행하라고 지정했지만, 생성기가 3개 작업을 한 장의 multi-panel board로 합쳤다.

### 문제
- 작업량 3개와 deliverable 3개는 다르다.
- 각 장을 독립 승인/교체/Notion 배치하기 어렵다.
- 다음 세션이 “3장 완료”를 잘못 해석할 수 있다.

### 교훈
`BATCH_COUNT_MEANS_INDEPENDENT_DELIVERABLES` — 사용자가 N장의 이미지를 요청하면 기본 해석은 **독립 검토 가능한 N개 파일/결과**다. 한 collage의 N panel은 사용자가 collage를 요청했을 때만 동등하다.

복구:
- 의미 손실 없이 독립 crop 가능하면 분리한다.
- 각 영역이 서로 의존하거나 잘리면 재생성한다.
- 분리 후 각각의 제목/목적/상태를 기록한다.

## 4. 문제: 이미지 Reference가 runtime evidence처럼 보일 위험

### 관찰
생성 mock은 실제 UI와 유사하고 완성도가 높기 때문에 구현 완료 또는 physical PASS처럼 오인될 수 있다.

### 교훈
`VISUAL_REFERENCE_EVIDENCE_CEILING` — AI-generated mock/reference는 planning/communication evidence다. 실제 code/scene/resource/runtime/physical/human evidence를 대신하지 않는다.

필수 라벨 예:
- `VISUAL_REFERENCE`
- `MOCK`
- `NOT_PRODUCT_ASSET`
- `NOT_RUNTIME_PROOF`

프로젝트 runtime asset root와 visual reference 저장 위치를 분리한다.

## 5. 문제: 목적지 업로드는 성공 메시지만으로 충분하지 않음

### 관찰
Visual 작업은 생성 파일이 존재하는 것만으로 끝나지 않는다. Notion owner에서 이미지가 실제 표시되고, 제목/상태/설명과 함께 보이는지 확인해야 다음 채팅이 안정적으로 소비할 수 있다.

### 교훈
`VISUAL_DESTINATION_READBACK_REQUIRED` — 지속적으로 사용할 visual은 목적지 attach/embed 뒤 **실제 destination readback**까지 확인해야 완료다.

검증:
1. intended destination인지
2. intended image인지
3. render/preview가 존재하는지
4. reference/runtime status가 정확한지
5. source/provenance가 남는지

## 6. 프로젝트 전용으로 남길 내용

다음은 Switchy 고유이므로 Base 공용 규칙에 넣지 않는다.

- `E+D Hybrid / Neo-Arcade Readability`
- Cozy Miniature railway
- 토끼 기관사
- Train/Station/Cargo/Switch의 실제 디자인
- 특정 green/blue/red/yellow 의미색
- 현재 73 PNG 수량
- `SX59-POC-ACCEPT-003`
- 3장 batch라는 현재 사용자 선호의 숫자 자체

Base에는 `N independent deliverables`라는 일반 원칙만 후보로 올린다.

## 7. Base 승격 후보

공용화 후보:
1. `VISUAL_TASK_SCOPE_FIDELITY`
2. `DECISION_CRITICAL_VISUAL_SEMANTIC_REDUNDANCY`
3. `BATCH_COUNT_MEANS_INDEPENDENT_DELIVERABLES`
4. `VISUAL_REFERENCE_EVIDENCE_CEILING`
5. `VISUAL_DESTINATION_READBACK_REQUIRED`

권장 구현 방식:
- 신규 Visual Skill을 만들기보다 기존 `auditing-and-refining-ui-art` / visual-generation owner / handoff evidence owner에 최소 계약을 추가.
- root AGENTS에 장문 체크리스트를 복제하지 않음.
- proposal과 active Base implementation은 별도 PR로 분리.

## 8. Evidence ceiling

이번 관찰로 증명 가능한 것:
- scope drift가 실제 발생했다.
- user batch 의도와 single-collage 결과가 어긋났다.
- user가 기존 style 유지 + route visibility 강화 방향을 승인했다.
- visual reference와 runtime evidence 분리가 필요하다.

이번 관찰만으로 증명하지 못하는 것:
- 특정 semantic signal 조합이 실제 플레이어 이해도를 개선했다는 human evidence
- Candidate 003 physical PASS
- accessibility PASS
- production asset 교체 필요성

따라서 Base 승격 시 **방법론/guardrail**만 승격하고 효과 크기를 검증 완료처럼 주장하지 않는다.
