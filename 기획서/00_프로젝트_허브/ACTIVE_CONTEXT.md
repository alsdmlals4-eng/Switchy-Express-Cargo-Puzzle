# Active Context

## 현재 상태

- 프로젝트 이름과 핵심 코어가 사용자 승인됨.
- Base v9.3 프로젝트 운영체계가 설치되어 있음.
- Issue #4 / PR #9 Rail foundation 완료.
- Issue #5 / PR #12 배송 하위 루프 완료.
- Post-VS02 runtime 보완 PR #13 완료.
- 최신 구현 Commit: `4e435a1a6d10ab146197671049da80709fd18c1f`.
- Godot 검증: `9 cases / 6915 assertions / 0 failures`.
- Project Contract: PASS.
- Issue #4·#5: CLOSED · COMPLETED.
- Google Sheets는 `USER_FACING_GDD_WORKSPACE`이며 Post-VS02 상태 동기화 진행 중.
- HTML POC는 규칙 탐색용으로 종료하며 Godot 제품 구현 증거로 사용하지 않음.
- 승인 시각 방향: 부드럽고 둥근 프리미엄 캐주얼 3D 카툰, 토끼 기관사, 선명한 선로·분기 상태.
- 현재 Work Mode: `PLAN · CODEX_BUILD_READY`.
- Vertical Slice Epic: GitHub Issue #3.
- 다음 실행 Issue: GitHub Issue #6.

## 구현된 범위

### Rail foundation

- 1920×1080 가로형 Godot 프로젝트
- 결정론적 15×10 전체 연결 RailGraph
- 막다른길 0·cycle rank 3 이상
- seeds 1~100 생성 검사
- 2단계 분기 최소 4개·3단계 분기 최소 2개
- 직진 우선 기본 A노선·5칸 preview parity
- 현재 이동 구간 target lock·즉시 반전 금지·통과 뒤 reset

### 배송 하위 루프

- 기관차 연속 이동과 큰 delta의 칸별 처리
- 최대 8개 화차의 1칸 간격 제한 이력 추종
- LOAD 중에만 화물 수거
- 색상+모양 타입과 최대 8개 LIFO 스택
- 빨강·파랑·노랑 역 각 2개, 총 6개
- 같은 타입 역 거리 5칸 이상
- 맵 위 타입별 화물 최소 4개
- 1초 재생성·금지 칸·직전 위치 제외·결정론·deferred 복구
- runtime에서 현재 열차·전방 2칸을 피한 최소 수량 자동 복구
- LIFO 연속 그룹 하역과 전후 ViewModel
- 실제 기차 진입 기반 수거→스택→역→하역 통합
- 정확한 칸 진입 event time

## 현재 차이

- 시간별 기본 속도 상승과 화물 감속 공식이 없음.
- 연료 drain·배송 연료 보상·점수·combo가 없음.
- BOOST 입력 우선은 있으나 속도·연료 효과가 없음.
- 연료 0 게임오버·결과 요약·재시작·최고 기록이 없음.
- 기능 HUD·RailBoardView·SwitchView가 없음.
- RailGraph의 실제 반복 플레이 다양성·경로 엔트로피는 미검증.
- 승인 콘셉트 이미지는 저장소 영구 자산 import 대기.
- Android export·실기 성능·접근성·외부 플레이테스트는 `NOT_RUN`.

## 다음 작업

Codex가 아래 실행문을 사용해 Issue #6만 테스트 우선으로 구현한다.

`기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md`

다음 Goal:

> 기존 배송 이벤트에 속도·화물 감속·연료·점수·BOOST·게임오버·기록을 연결하고, 기능적 가로형 gameplay scene과 HUD를 실패→통과 증거와 함께 구현한다.

## 주요 위험

- 화물 8개 감속이 실제 시간 연료 drain과 결합해 생존 exploit를 만들 수 있음.
- 상시 BOOST가 점수와 생존 모두에서 항상 정답이거나 완전히 무가치할 수 있음.
- frame delta에 따라 연료·점수·배송 간격이 달라질 수 있음.
- 연료 0 뒤에도 signal·이동·스폰·입력이 계속 처리될 수 있음.
- 재시작 시 signal 중복 연결·event buffer·pending respawn이 남을 수 있음.
- 기능 HUD와 실제 CargoStack·RunState가 어긋날 수 있음.
- 작은 가로형 화면에서 LOAD·BOOST·분기 터치 영역이 겹칠 수 있음.

## 감사·동기화

- 최신 적대적 감사: `기획서/50_제작_검증/POST_VS02_ADVERSARIAL_AUDIT.md`
- Post-VS02 Sheet 동기화: `PENDING`
- 다음 Evidence: `EV-VS02-001`
- 다음 Audit: `SX-AUD-003`
