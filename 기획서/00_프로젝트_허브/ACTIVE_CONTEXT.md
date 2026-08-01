# Active Context

## 현재 상태

- 프로젝트 이름과 핵심 코어가 사용자 승인됨.
- Base v9.3 프로젝트 운영체계가 설치되어 있음.
- Vertical Slice Issue #4 / PR #9가 완료됨.
- 구현 Commit: `801632949d28564528e38d83dac59cccc6f06fb2`.
- Godot 4.7.1 프로젝트·헤드리스 테스트 러너·15×10 RailGraph·2/3단계 분기 로직이 구현됨.
- Godot 검증: `3 cases / 934 assertions / 0 failures`.
- Project Contract: PASS.
- Issue #4: CLOSED · COMPLETED.
- Google Sheets는 `USER_FACING_GDD_WORKSPACE`이며 Post-VS01 상태 동기화 진행 중.
- HTML POC는 규칙 탐색용으로 종료하며 Godot 제품 구현 증거로 사용하지 않음.
- 승인 시각 방향: 부드럽고 둥근 프리미엄 캐주얼 3D 카툰, 토끼 기관사 마스코트, 선명한 선로·분기 상태.
- 현재 Work Mode: `PLAN · CODEX_BUILD_READY`.
- Vertical Slice Epic: GitHub Issue #3.
- 다음 실행 Issue: GitHub Issue #5.

## 구현된 범위

- 1920×1080 가로형 Godot main scene
- 결정론적 15×10 전체 연결 철도 그래프
- 막다른길 0·cycle rank 3 이상
- seeds 1~100 생성 검사
- 2단계 분기 최소 4개·3단계 분기 최소 2개
- 직진 가능 시 기본 A노선 직진 우선
- 즉시 180도 반전 금지
- 5칸 경로 preview와 실제 next-cell 일치
- 통과 후 기본 상태 복귀
- 결정론적 safe fallback
- Godot 런타임 Script Error를 CI 실패로 판정

## 현재 차이

- 기관차 이동·경로 보간·화차 추종이 없음.
- 화물 타입·스택·LOAD 입력·화물 생성이 없음.
- 스테이션 배치·LIFO 하역이 없음.
- 연료·점수·속도·BOOST·게임오버가 없음.
- RailGraph 생성은 계약을 통과하지만 실제 맵 다양성·경로 엔트로피는 아직 미검증.
- 승인 콘셉트 이미지는 시각 방향으로 승인됐지만 저장소 영구 자산 import는 별도 작업임.
- Android export·실기 성능·접근성·플레이테스트 증거는 `NOT_RUN`.

## 다음 작업

Codex가 아래 실행문을 사용해 Issue #5만 테스트 우선으로 구현한다.

`기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_02.md`

다음 Goal:

> 선택된 선로를 따르는 기관차와 최대 8개 화차, LOAD 선택 적재, 색상별 최소 화물 유지, 색상별 역 2개, LIFO 연속 하역과 하역 순서 ViewModel을 실패→통과 증거와 함께 구현한다.

## 주요 위험

- 분기 데이터는 정확하지만 실제 화면에서 활성 방향이 읽히지 않을 수 있음.
- 현재 생성기의 구조 변형 폭이 실제 반복 플레이에 부족할 수 있음.
- 화차 경로 이력이 분기·곡선에서 겹침이나 순간 이동을 만들 수 있음.
- 역 6개·동색 거리 5칸·화물 최소 12개를 작은 맵에 배치할 때 후보 부족이 생길 수 있음.
- 화물 감속이 후반 속도 상승을 상쇄해 영구 생존 전략이 될 수 있음.
- 부스터가 항상 정답이거나 사용 가치가 없을 수 있음.
- 작은 가로형 맵에서 화물·역·분기 UI가 겹칠 수 있음.

## 감사

- 최신 적대적 감사: `기획서/50_제작_검증/POST_VS01_ADVERSARIAL_AUDIT.md`
- Sheet 동기화 완료 뒤 `SYNCED` 상태와 canonical sync Commit을 다시 기록한다.
