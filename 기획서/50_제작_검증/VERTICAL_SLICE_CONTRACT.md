# Vertical Slice Contract

## 목표

한 판에서 적재 선택, 2·3단계 분기 전환, compact token LIFO 하역, 하역 그룹 Combo, 연료 생존, 화물 감속, 부스터 위험 선택이 연결되어 반복 플레이 의도를 만드는지 목표 품질로 검증한다.

## 포함

- Godot 4.7.1 프로젝트
- Android 가로형 기준 16:9
- 15×10 연결 철도망 생성
- 모든 선로 연결·막다른길 없음
- 2단계 분기기 최소 4개
- 3단계 분기기 최소 2개
- 색상별 스테이션 2개
- 색상별 화물 최소 4개
- 기차와 `SX-DEC-015` compact wagon token 최대 8개
- LOAD 홀드
- LIFO 연속 하역
- `SX-DEC-014` 하역 그룹 Combo
- 점수·연료·속도
- 화물 적재량 감속
- BOOST 홀드와 추가 연료 소모
- 시간 경과 난이도 상승
- 게임오버·재시작
- 최고 기록 로컬 저장
- 승인 시각 방향의 대표 맵·HUD·피드백
- 헤드리스 테스트와 10분 런타임 검증

## 제외

- 광고·결제
- 에너지·생명 제한
- 차량 능력치 성장
- 가챠
- PvP·길드·실시간 랭킹
- 다수 지역·스킨
- 장문 스토리
- 온라인 의존성
- iOS 출시 작업
- 여러 배송을 잇는 Combo streak 시스템
- 화물당 1개 full-size rail-cell wagon
- 항상 표시되는 빈 화차 8개

## Combo 계약 — SX-DEC-014

- `Combo`는 한 번의 역 도착에서 stack top부터 연속 하역된 동일 `cargo_type`의 개수다.
- `max_combo`는 한 판에서 기록한 가장 큰 하역 그룹 크기다.
- 빠른 연속 배송은 Combo가 아니라 별도 `speed_bonus` `TEST_VALUE`다.
- 빈 역·타입 불일치는 Combo·점수·연료 보상 0이다.
- HUD·결과·telemetry·저장은 같은 의미를 사용한다.

## compact wagon token 계약 — SX-DEC-015

- token count는 CargoStack size와 1:1이며 범위는 0~8이다.
- 화물 0개에서는 기관차만 표시한다.
- 기관차→뒤쪽 token 순서는 stack bottom→top이다.
- 가장 뒤 token은 다음 LIFO 하역 대상이다.
- token은 cargo_type의 색상+모양을 표시한다.
- 적재·하역 뒤 token count/order와 compressed footprint를 같은 도메인 단계에서 갱신한다.
- 권장 시험값은 body 0.22칸, spacing 0.28칸, 8개 chain 2.18칸, trailing footprint 최대 3칸이다.
- spawn exclusion은 full-size wagon 8칸이 아니라 compressed footprint가 실제로 교차하는 칸을 사용한다.
- motion·audio·haptic 완료는 cargo·token·occupancy 권위가 아니다.

## Quality Bar

### 가독성
- 첫 3초 안에 기차·화물·역·분기기를 구분
- 분기기의 현재 활성 경로를 설명 없이 판별
- 현재 하역 순서를 HUD에서 즉시 확인
- 색각 조건에서도 모양으로 식별
- `COMBO ×N`과 speed bonus를 서로 다른 보상으로 구분
- 0/1/4/8 token 상태에서 적재량을 판별
- 8 token 상태에서도 가장 뒤 LIFO token·역·분기·preview를 구분

### 조작
- LOAD와 BOOST가 한 손으로 안정적으로 입력
- 분기기 터치 영역 48dp 이상
- 슬로모션 없이도 다음 분기를 선택할 시간 확보
- 탭한 분기 상태와 실제 경로 100% 일치

### 시스템
- LIFO 하역 단위 테스트 통과
- `compact_wagon_token_count == cargo_stack.size()`
- rear token type == `CargoStack.top()`
- 8 token trailing footprint ≤ 3 rail cells
- `combo_count == unload_group_size == try_unload().count`
- `speed_bonus`가 Combo를 변경하지 않음
- 색상별 최소 화물 유지
- compressed footprint 안에 pickup 생성 금지
- 생성 맵 연결성·막다른길 없음
- 무조작 영구 생존 불가
- 부스터 상시 사용이 최적 전략이 아님

### 성능
- 목표 Android 기기에서 60 FPS 목표, 1% low 45 FPS 이상
- 10분 실행 중 메모리 지속 증가 없음
- 프레임마다 전체 그래프 재탐색 금지
- fractional token path sampling이 무제한 history를 만들지 않음

## Decision Gate

- `PASS`: 핵심 선택과 반복 의도 확인, Production 계획 진입
- `REVISE`: 재미는 있으나 분기·연료·화물·token 밀도·보상 수치 재조정
- `PIVOT`: 플레이어가 적재 순서·분기 판단·큰 하역 그룹을 핵심으로 인식하지 못함
- `STOP`: 규칙 이해 실패와 반복 의도 부재가 수정 후에도 지속
