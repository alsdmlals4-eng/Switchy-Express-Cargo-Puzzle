# Switchy Express · Visual Quality Session Handoff · 2026-08-25

## 목적

새 채팅/새 작업자가 과거 대화를 읽지 않아도 **현재 GitHub + Notion만 재확인해 같은 수준의 Visual/GDD 품질로 작업을 이어가기 위한 압축 라우터**다. 이 문서는 현재 사실을 대체하지 않는다. 재개 시 반드시 최신 Base, 프로젝트 `main`, 열린 PR, Notion Human Home/Visual owner를 다시 읽는다.

## 현재 권위와 시작 순서

1. 사용자의 최신 지시와 승인
2. 프로젝트 `AGENTS.md` + v4.8 r4 thin adapter
3. Notion Human Home / `03 · Visual · UX · Assets` / Visual Bible
4. GitHub의 실제 code/data/Scene/Resource/assets/tests/runtime evidence
5. 최신 completed Base `main`

`GOOGLE_SHEETS: RETIRED_NO_ACTIVE_USE` — 일반 작업에서 읽기·쓰기·동기화·결정 입력에 사용하지 않는다.

이 문서 작성 기준 프로젝트 main은 `81dc7d29eabff1482fae92d985cc8e67fcf22cdd`였다. **재개 시 SHA를 고정값으로 믿지 말고 GitHub 최신 completed main을 다시 확인한다.**

기존 draft PR #174는 **READ_ONLY**다. 별도 명시 승인 없이 수정·rebase·merge·흡수하지 않는다.

## 현재 게임 / Visual 방향

- 게임 정체성: finite cargo puzzle — `BUILD → Preflight → RUN → Pickup → LIFO/TOP → Switch → Delivery → Result → Retry/Edit`.
- 기존 art style 유지: `E+D HYBRID · NEO-ARCADE READABILITY`.
- 사람용 해석: Cozy Miniature Neo-Arcade / premium casual miniature railway.
- 손그림/새 스타일 패밀리로 전환하지 않는다.
- 기존 73 semantic product PNG의 제품 권위는 그대로 유지한다.
- 새 생성 이미지는 **VISUAL REFERENCE / MOCK / GDD**이며 별도 승인·통합 전에는 runtime product asset이 아니다.

## 사용자 승인 Visual 결정 · Route visibility

그림체를 바꾸지 않고 판단에 필요한 노선/분기 정보만 강화한다. Decision-critical route state는 색상 하나에 의존하지 않는다.

```text
COLOR
+ DIRECTION
+ SHAPE
+ BRIGHTNESS / THICKNESS
+ STATE ICON / MOTION WHEN APPROPRIATE
```

필수 구분 상태:
- Selected
- Unselected
- Occupied / Locked
- Inactive

스위치 손잡이/아이콘도 직진·좌분기·우분기를 자체 실루엣과 방향으로 읽을 수 있어야 한다. 분기점 주변 배경 디테일은 노선 정보보다 우선하지 않는다.

## 이미지 작업 계약

사용자 지시: **이미지 작업은 3장씩 한 배치**.

`3장`은 한 콜라주 안의 3패널이 아니라 **독립 검토 가능한 3 deliverables**를 뜻한다. 생성기가 합쳐서 내면 그대로 3장 완료로 세지 말고 각 작업을 독립 이미지로 재생성하거나 의미 손실 없이 분리한다.

매 이미지 작업 전:
1. 이번 이미지가 답할 visual question 1개를 적는다.
2. 기존 스타일/승인 asset/reference를 reuse-first로 확인한다.
3. 게임 규칙을 새로 만들지 않는다.
4. 생성 결과가 요청 scope를 넓히면 `OUT_OF_SCOPE_REFERENCE`로 취급하고 제품 정본으로 승격하지 않는다.
5. 승인 이미지는 Notion owner에 올리고 destination readback을 확인한다.
6. mock/reference는 physical/runtime PASS로 해석하지 않는다.

## 현재 승인 Visual batch · Pixel owner

**Pixel owner는 Notion**이다.

- Notion owner: `03 · Visual · UX · Assets`
- Page ID: `3c51b237-eb1c-81fa-8d47-d043dae17e11`
- Current section: `CURRENT · Durable Approved Visual Preview Batch · 2026-08-25`
- Delivery evidence: `NOTION_OWNED_ATTACHMENT · DESTINATION_READBACK_PASS · ATTACHMENT_CONTENT_READBACK_PASS`
- GitHub manifest: `docs/visual-references/2026-08-25/README.md`

현재 3개 독립 deliverable:
1. `01 · Before / After Route Visibility`
2. `02 · Capstone RUN Information Hierarchy`
3. `03 · Preflight Problem Visibility`

초기 GitHub JPG transport는 byte corruption이 발견되어 제거했다. GitHub는 source hash / 목적 / 규칙 / handoff를 소유하고, 이 batch의 중복 pixel canon으로 사용하지 않는다. Notion의 current durable preview는 low-resolution handoff preview이며 **human-visible/client render PASS나 Candidate 003 runtime PASS를 뜻하지 않는다.**

상태: `USER_APPROVED_VISUAL_REFERENCE · NOT_RUNTIME_PROOF`.

## 다음 이미지 backlog

다음 권장 3장 배치:
1. Failure Result / Debrief — `ROUTE_END` vs `TIME_EXPIRED`, map cargo vs train cargo, Retry vs Edit.
2. BUILD / Edit 실제 화면 — valid/invalid, rotate/replacement, no-build, cost hierarchy.
3. Tutorial / Lesson Popup — 새 규칙 1개만 설명하고 board를 가리지 않는 구조.

그 다음 후보 3장:
1. Success Result
2. T1→T6→Capstone Progressive Disclosure Storyboard
3. 960×540 minimum viewport readability

추가 선택 후보:
- Reduced Motion equivalence
- 전체 Screen Map
- Color-blind / Accessibility sheet
- Train/Station/Cargo/Switch long-term style sheet
- VFX/Feedback state sheet
- Campaign / Daily-Weekly / Ranking screens — 향후 제품 상태와 구현 증거가 생긴 뒤

## Candidate 003 증거 경계

Current candidate: `SX59-POC-ACCEPT-003`.

자동/package evidence와 visual mock을 실제 사용자/기기 증거와 섞지 않는다.

아직 `NOT_RUN`:
- Candidate 003 physical visual recheck
- developer self-run / screen QA
- audio perceptual QA
- Windows full physical runtime
- Android device
- five-person comprehension
- player experience

새 채팅은 위 항목을 이미지 reference를 근거로 PASS로 바꾸면 안 된다.

## 새 채팅의 첫 행동

```text
1. Base latest completed main + relevant owner refresh
2. Project latest main + open PR refresh
3. AGENTS / r4 adapter / current candidate pointer 확인
4. Notion Human Home + 03 Visual + Visual Bible fetch
5. 03 Visual의 CURRENT Durable Approved Visual Preview Batch 존재/readback 확인
6. GitHub docs/visual-references/2026-08-25/README.md와 본 Handoff 대조
7. 현재 사용자 요청을 3-image batch인지, 구현/검증인지 분류
8. 작업 시작
```

## 품질 체크

새 Visual을 승인 후보로 올리기 전 최소 확인:
- 기존 스타일을 유지하는가?
- 플레이 판단 정보가 배경/장식보다 먼저 보이는가?
- color-only가 아닌가?
- 작은 viewport에서도 핵심 상태가 겹치지 않는가?
- 한 이미지가 한 질문을 명확히 답하는가?
- 실제 게임 규칙/현재 구현과 충돌하는 가짜 UI가 없는가?
- mock/reference/runtime evidence 라벨이 정확한가?
- Notion 업로드 후 destination readback 했는가?

## Rollback / 충돌 처리

- 사용자 최신 결정과 이 문서가 충돌하면 사용자 최신 결정이 우선.
- GitHub/Notion current owner와 이 문서가 충돌하면 실제 최신 owner를 다시 읽고 원인을 분석한다.
- 잘못 생성된 visual은 삭제를 서두르지 말고 reference/historical로 격리한다.
- 기존 73 runtime asset을 새 mock 때문에 임의 교체하지 않는다.
- Notion preview transport가 실패하면 GitHub manifest/source hash는 유지하고 새 durable transport만 교체한다.
