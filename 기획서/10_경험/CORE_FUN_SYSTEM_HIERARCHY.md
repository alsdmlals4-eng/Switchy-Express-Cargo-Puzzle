# Core Fun and System Hierarchy

```yaml
status: CANONICAL · SYNCED
audit: SX-AUD-007 · CLOSED
source_decisions: SX-DEC-002~010 · SX-DEC-014~026
current_package_authority: VS03-03_ONLY
```

## 한 문장 핵심 재미

> 자동으로 달리는 열차에서 **앞으로 필요한 하역 순서를 역산해 화물을 골라 싣고**, 분기기를 미리 바꾸며, 무게와 연료 압박을 감수해 **큰 LIFO 하역 그룹을 성공시키는 계획형 생존 퍼즐**.

## 플레이어 목표

한 판의 직접 목표:

```text
연료가 다하기 전까지
→ 필요한 화물을 의도한 LIFO 순서로 적재하고
→ 알맞은 역으로 경로를 준비하며
→ 큰 하역 그룹을 만들어
→ 점수와 연료를 이어가고
→ 개인 최고 기록을 갱신한다.
```

장기 목표는 기록·맵 발견·꾸미기 수집이지만, 이들은 한 판의 적재·경로·위험 판단을 대체하지 않는다.

## 핵심 판단 사슬

```text
앞으로 방문할 역과 경로를 읽는다
→ 어떤 화물을 지금 실을지 선택한다
→ stack top과 미래 하역 순서를 예측한다
→ 더 실어 큰 그룹을 만들지 지금 배달할지 결정한다
→ 화물 감속·연료·BOOST 비용을 감수한다
→ 뒤쪽 연속 그룹을 의도대로 하역한다
→ Combo·점수·연료 회복으로 계획 결과를 확인한다
```

## 핵심 시스템

핵심 시스템은 제거했을 때 프로젝트의 장르적 정체성이 바뀌는 요소다.

### 1. 선택 적재 + capacity 8 LIFO CargoStack

- LOAD 중에만 화물을 선택해 적재한다.
- 마지막에 실은 화물이 첫 하역 대상이다.
- 무엇을 넘기고 무엇을 실을지 자체가 계획이다.

### 2. 자동 운행 + 선행 분기 결정

- 열차는 자동으로 움직이며 플레이어를 기다리지 않는다.
- 플레이어는 preview를 읽고 분기기를 미리 전환한다.
- preview와 실제 next cell이 일치하고 segment 진입 뒤 목표가 잠겨야 계획을 신뢰할 수 있다.

### 3. 색상별 station + 연속 그룹 하역

- stack top부터 역 색상과 일치하는 연속 그룹만 하역한다.
- `Combo == unload_group_size`다.
- Combo streak가 아니라 한 번의 적재 순서 설계 결과를 보상한다.

### 4. 생존 경제

- 시간 경과에 따라 속도와 연료 압력이 증가한다.
- 화물을 많이 실으면 느려지지만 연료 소모가 할인되지는 않는다.
- 배송은 점수와 연료를 회복한다.
- 연료 0에서 run이 끝난다.

### 5. BOOST 위험 교환

- BOOST는 속도를 높이는 대신 연료를 더 쓴다.
- BOOST 중 LOAD는 차단된다.
- 상시 정답이나 계획 실패를 무조건 지우는 복구 버튼이 되어서는 안 된다.

### 6. compact token + rear=LIFO top 가독성

- 화물 1개를 작은 token 1개로 표현한다.
- front→rear는 stack bottom→top이다.
- rear token은 다음 하역 대상이다.
- 내부 스택이 플레이어에게 읽히지 않으면 LIFO 판단이 성립하지 않으므로 표현이지만 core readability system으로 분류한다.

## 보조 시스템

보조 시스템은 핵심 재미를 학습·반복·확장한다.

### 학습·정보

- 실제 첫-run 상황형 onboarding과 Help
- HUD·Unload Order·rear item
- PREP camera·FULL_MAP_READY·active full-map camera
- difficulty forecast와 CALM/BUSY/INTENSE signal

### 실패 학습·재도전

- evidence-based result cause/action
- neutral fallback
- exact same-map restart
- new official map 선택·발견·재선택

### 장기 진행

- official global/per-map personal records
- cosmetic-only collection/equip
- DEFAULT/DUAL_PATH/CURRENCY_ONLY unlock
- bounded cosmetic currency
- Profile single-writer transaction

### 콘텐츠·운영·검증

- minimum target3 official maps
- Production target100 official catalog
- telemetry·economy simulation·device/human playtest
- Production online UGC·publication·moderation·community signals

## 우선순위

```text
1. LIFO 적재 순서 계획
2. 목적 역까지의 노선 선행 결정
3. 큰 그룹을 위한 위험·생존 판단
4. BOOST와 배송 속도의 전술적 시간 관리
5. 결과 학습·같은 조건 재도전
6. 기록·꾸미기·맵 발견·UGC
```

모든 신규 기능과 수치 변경은 위 순서에서 자신보다 상위 항목을 약화하지 않는지 확인한다.

## 방향 이탈 판정

다음 중 하나가 반복되면 핵심 재미가 흐려진 것이다.

- 빠른 탭과 BOOST 운용이 적재 순서 계획보다 점수에 더 큰 영향을 준다.
- 같은 색만 골라 싣는 단순 전략이 거의 항상 최적이다.
- 플레이어가 rear token과 다음 하역 대상을 빠르게 식별하지 못한다.
- 분기 preview와 실제 경로의 인과를 이해하지 못한다.
- 기록·재화·콘텐츠 수가 실제 run 재미보다 주된 재도전 이유가 된다.
- 난이도 상승이 판단의 기회비용보다 입력 정밀도·반사신경만 요구한다.

## 핵심 검증 지표

### 행동

- mixed-stack 비율과 stack distinct-type count
- mono-color delivery 비율
- Combo 1/2/3/4/5+ 분포
- 큰 그룹을 위해 화물을 보유한 시간
- 경로 선행 전환 성공·실수·복구 비율
- BOOST 사용 시간과 LOAD 기회비용

### 보상 구성

- 점수 중 unload-group base 비중
- speed bonus 비중
- heavy bonus 비중
- 연료 회복 중 Combo 크기별 기여

### 이해

- rear token이 다음 하역 대상임을 설명할 수 있는가
- 큰 Combo가 빠른 탭이 아니라 적재 순서에서 나온다는 것을 설명할 수 있는가
- 현재 경로와 다음 목적 역을 말할 수 있는가
- 같은 맵 재시작과 새 맵 선택을 구분하는가

## Benchmark Positioning

벤치마크에서 참고할 문제 해결 방식:

- `Mini Metro`: 점진적으로 커지는 생존 압력과 실패 후 설계 학습
- `Conduct THIS!`: 적은 입력과 즉각적인 분기 피드백
- `Railbound`: 화차 순서와 경로 결과의 명확한 인과
- `Train Valley 2`: 공식 콘텐츠와 사용자 제작 콘텐츠의 단계적 분리
- `Rail Route`: 경로·신호 권위를 presentation과 분리하는 시스템 구조

Switchy의 차별점은 철도 자체가 아니라 다음 결합이다.

```text
실시간 분기 압박
+ 점진적 생존 압력
+ 읽을 수 있는 화차·경로 인과
+ 선택 적재 LIFO 그룹 계획
```

벤치마크 기능을 그대로 복제하지 않는다. 네트워크 건설·충돌 회피·tycoon·자동화·UGC 규모는 LIFO core가 검증된 뒤 필요성을 판단한다.

## 변경 규칙

- 위 핵심 재미와 시스템 위계 변경은 material player-facing Decision이다.
- 수치가 위 의미를 보존하면 `TEST_VALUE` 재보정으로 처리한다.
- 구현 오류·권위 분리·상태 드리프트 수정은 새 Decision 없이 적대적 감사 Finding으로 처리한다.
- 중요한 Grill Me에는 외부 벤치마크, 현업 기본안, 제작 비용, 실패 위험, 검증 방법을 포함한다.
