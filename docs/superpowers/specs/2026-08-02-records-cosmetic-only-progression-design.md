# Records + Cosmetic-Only Progression Design

```yaml
decision_id: SX-DEC-019
evidence_id: EV-USER-008
batch_id: GMB-001
batch_slot: 3/10
status: APPROVED_PENDING_BATCH_MERGE
authority: USER_APPROVED_HYBRID_A_PLUS_B
implementation_status: NOT_STARTED
validation_status: NOT_RUN
```

## 목적

Switchy Express의 장기 동기를 **공정한 개인 기록 경쟁**과 **성능 없는 꾸미기 수집**으로 구성한다. 플레이를 오래 했다는 이유로 속도·연료·적재량·점수 효율이 올라가지는 않으며, 모든 표준 run은 같은 규칙에서 비교 가능해야 한다.

## 확정 결정

1. 영구 진행은 `기록`과 `꾸미기 수집·장착`만 허용한다.
2. 표준 영구 기록은 최소한 다음을 보존한다.
   - 최고 점수
   - 최장 생존 시간
   - 한 판 최대 Combo
3. 꾸미기는 기관차 외형, 기관사 의상, 역·맵 테마, 기적음·배기 연출, 화물 token 스킨으로 확장할 수 있다.
4. 꾸미기는 외형·소리·연출만 바꾸며 run 성능과 규칙을 바꾸지 않는다.
5. 속도, 연료, 적재량, BOOST, 점수, 스폰, 맵 생성, 충돌, 카메라, 온보딩 보조의 영구 강화는 금지한다.
6. first-run assist가 적용된 판은 표준 경쟁 기록을 덮어쓰지 않는다.
7. 꾸미기 해금 방식과 구체 해금 조건은 별도 Decision에서 확정한다.

## 영구 Profile 경계

권장 Profile은 다음 세 책임을 분리한다.

```text
CompetitiveRecords
→ 표준 규칙에서 획득한 개인 최고 기록

CosmeticCollection
→ 해금된 cosmetic_id 집합과 slot별 장착 상태

ProfileMetadata
→ schema_version, migration_version, 마지막 저장 시각
```

Profile은 run의 속도·연료·점수 공식을 소유하지 않는다. RunBalance와 RunState는 Profile의 꾸미기 상태를 읽어 수치를 변경하지 않는다.

## 기록 계약

### 표준 기록

```text
best_score
longest_survival_seconds
best_max_combo
records_ruleset_id
```

- 기록 갱신은 최종 확정된 `RunSummary`를 입력으로 받는다.
- 각 필드는 독립적으로 최고값을 갱신한다.
- 결과 UI animation이나 신기록 연출 완료는 저장 조건이 아니다.
- 저장 실패는 run 결과와 재시작을 막지 않으며, 재시도 가능한 오류 상태만 남긴다.
- 같은 summary를 두 번 처리해도 기록이 중복 증가하거나 되돌아가지 않아야 한다.

### 기록 자격

표준 기록 자격의 권장 계약:

```text
record_eligible =
    run_completed
    AND NOT assisted_first_run
    AND ruleset_id == current_competitive_ruleset_id
    AND integrity_state == VALID
```

- first-run assist 판의 결과는 화면에 표시할 수 있지만 표준 최고 기록을 덮어쓰지 않는다.
- 개발·디버그·변형 규칙 run도 표준 기록에서 분리한다.
- TEST_VALUE 조정으로 규칙 의미가 달라지면 `ruleset_id` 갱신 여부를 명시적으로 검토한다.
- 온라인 리더보드는 이번 Decision 범위가 아니다. 현재 계약은 로컬 개인 기록을 최소 권위로 둔다.

## 꾸미기 Collection 계약

### 권장 category

```text
LOCOMOTIVE_SKIN
CONDUCTOR_OUTFIT
STATION_THEME
MAP_THEME
HORN_SOUND
EXHAUST_EFFECT
CARGO_TOKEN_SKIN
```

각 꾸미기 정의는 다음의 immutable metadata만 제공한다.

```text
cosmetic_id
category
asset_reference
preview_reference
localization_key
compatibility_version
accessibility_tags
```

### 해금·장착 상태

```text
unlocked_cosmetic_ids
selected_cosmetic_by_category
```

- 기본 꾸미기는 항상 해금 상태다.
- 잠긴 꾸미기는 장착할 수 없다.
- 삭제·이름 변경·호환 불가 ID가 저장되어 있으면 해당 category의 기본 꾸미기로 안전하게 복귀한다.
- 장착은 즉시 저장 가능하지만 저장 실패가 현재 run의 도메인 상태를 변경하면 안 된다.
- 같은 cosmetic_id를 반복 해금해도 중복 보상·중복 저장이 발생하지 않는다.

## 절대 금지되는 성능 영향

꾸미기와 영구 Profile은 다음 값을 변경할 수 없다.

```text
base_speed
cargo_multiplier
fuel_max
fuel_start
base_fuel_drain
boost_multiplier
boost_drain_multiplier
cargo_capacity
unload_score
fuel_reward
speed_bonus
heavy_bonus
station_count
pickup_count
spawn_probability
rail_graph_generation
train_collision
compact_token_footprint
camera_framing
onboarding_assist
record_eligibility
```

CosmeticDefinition에 gameplay modifier 필드를 두지 않는다. 향후 modifier 필드가 추가되면 `SX-DEC-019` 위반으로 간주한다.

## 시각·오디오 공정성

### 기관차·의상·배기

- 외형이 커져도 collision, occupied rail cell, compact footprint는 바뀌지 않는다.
- 기관차 전방과 rear token의 위치 관계를 가리면 안 된다.
- 배기·파티클은 활성 경로, 분기 preview, 연료 위험 경고를 덮지 않는다.
- Reduced Motion에서는 같은 소유·장착 상태를 정적 표현으로 보존한다.

### 역·맵 테마

- 선로 대비, 활성 경로 굵기·화살표, 역의 색상+모양 이중 부호를 유지한다.
- 테마 변경으로 분기, pickup, station, compact token의 식별 난도가 유의미하게 달라지면 안 된다.
- Android aspect variant와 색각 보조 상태에서 별도 캡처 검증이 필요하다.

### 화물 token 스킨

- `RED_STAR`, `BLUE_DIAMOND`, `YELLOW_TRIANGLE`의 의미를 유지한다.
- 색상만 바꾸거나 shape glyph를 제거할 수 없다.
- rear token과 HUD unload order의 parity를 훼손하면 안 된다.
- token body length, spacing, trailing footprint를 바꾸지 않는다.

### 기적음

- 경고음·게임오버·분기 접수·하역 Combo 등 P0/P1 오디오 신호와 혼동되지 않아야 한다.
- 기적음 길이·볼륨이 중요한 경고를 마스킹하면 자동 duck 또는 재생 제한을 적용한다.
- mute 상태에서도 꾸미기 소유·장착은 유지된다.

## 해금 경제의 미결정 경계

이번 Decision은 `무엇을 영구 진행으로 허용하는가`만 확정한다. 다음은 아직 미확정이다.

- 업적형 milestone 해금인지
- run 보상 통화 구매인지
- 두 방식을 결합할지
- 중복 보상, 가격, 희귀도, 시즌 운영
- 유료 판매 또는 광고 보상의 존재 여부

단, 향후 어떤 방식이 선택되어도 성능 강화를 판매하거나 해금할 수 없다.

## 무조작·파밍 보호 원칙

- 단순 실행 시간만으로 꾸미기 보상을 반복 획득하지 않는다.
- score 0, delivery 0, integrity invalid run을 핵심 해금 근거로 사용하지 않는다.
- 같은 run 종료 event의 중복 처리로 해금이 여러 번 지급되지 않는다.
- 광고·결제·시간 조작 검증은 실제 해당 기능을 도입하는 별도 Decision 전에는 구현 범위가 아니다.

## 저장·마이그레이션

권장 저장 형태:

```text
profile_schema_version
competitive_records
unlocked_cosmetic_ids
selected_cosmetic_by_category
```

- schema migration은 이전 기록과 해금 상태를 가능한 한 보존한다.
- 손상된 record 값은 유효 범위로 정규화하거나 해당 필드만 기본값으로 복구한다.
- 알 수 없는 cosmetic_id는 무시하되 원본 save 전체를 폐기하지 않는다.
- 기본 cosmetic은 registry 누락·save 손상에서도 반드시 사용할 수 있어야 한다.
- save migration 실패는 제품 기본 외형과 빈 기록으로 안전 복구하되 오류 증거를 남긴다.

## 권위와 데이터 흐름

```text
RunState / RunController
→ immutable RunSummary
→ RecordEligibilityPolicy
→ CompetitiveRecordStore

CosmeticRegistry
→ CosmeticCollectionState
→ CosmeticViewModel
→ Visual / Audio views
```

- RecordEligibilityPolicy가 표준 기록 자격을 판정한다.
- CompetitiveRecordStore는 최고값 비교와 저장만 담당한다.
- CosmeticCollectionState는 해금·장착만 담당한다.
- Visual·Audio view는 장착 상태를 표현하며 해금·기록·run 결과의 권위가 아니다.
- CosmeticCollectionState를 RunBalance에 주입하지 않는다.

## Vertical Slice 최소 범위

VS-03/VS-04에서 전체 상점·경제를 만들지 않는다. 최소 검증 범위는 다음이다.

1. 표준 기록 3종 저장·로드.
2. assisted first run이 표준 기록을 덮어쓰지 않는 경계 테스트.
3. 기본 기관차 + 대표 기관차 스킨 1종의 registry·해금·장착·fallback.
4. 장착 전후 run 수치·충돌·seed signature parity.
5. save migration과 누락 cosmetic fallback.
6. Android에서 스킨 장착 전후 경로·역·token 가독성 비교.

꾸미기 획득 경제, 다수 category UI, 상점, 시즌, 온라인 리더보드는 Vertical Slice 필수 범위가 아니다.

## 계측

권장 bounded event:

```text
personal_record_updated
cosmetic_unlocked
cosmetic_equipped
cosmetic_fallback_applied
profile_migration_completed
profile_migration_failed
```

필수 field는 최소 ID·category·ruleset·assisted 여부·migration version으로 제한한다. 원시 save 내용이나 무제한 run history를 telemetry에 저장하지 않는다.

## 합격 기준

자동 검증:

- 적격 표준 run은 세 기록 필드를 독립 갱신한다.
- assisted first run은 표준 기록을 0회 갱신한다.
- 꾸미기 장착 전후 속도·연료·점수·capacity·collision·footprint·seed signature가 100% 동일하다.
- 잠긴 ID·누락 ID·삭제 ID 장착은 기본 cosmetic으로 안전 복귀한다.
- 해금·기록 event 중복 처리에도 상태가 idempotent하다.
- migration 후 기존 유효 기록과 해금이 보존된다.

Android·사람 검증:

- 대표 스킨 장착 전후 역·분기·active route·rear token 식별 성공률이 저하되지 않는다.
- 5명 이상 중 4명 이상이 `꾸미기가 성능을 올리지 않는다`고 설명할 수 있다.
- 기본 결과→기록 확인→재시작 흐름을 collection UI가 방해하지 않는다.

## 적대적 검토 결과

- `SX-AUD-004-F36 · HIDDEN_POWER_LEAK_RISK`: 꾸미기 metadata에 gameplay modifier가 숨어 들어갈 위험. modifier 필드 금지와 수치 parity 테스트로 차단한다.
- `SX-AUD-004-F37 · READABILITY_COLLISION_RISK`: 스킨·테마·파티클이 충돌·경로·token 의미를 바꿀 위험. collision/footprint 불변과 Android 비교 캡처를 요구한다.
- `SX-AUD-004-F38 · ASSISTED_RECORD_CONTAMINATION`: first-run assist 기록이 일반 최고 기록을 덮어쓸 위험. RecordEligibilityPolicy로 분리한다.
- `SX-AUD-004-F39 · IDLE_GRIND_EXPLOIT_RISK`: 무조작 시간·중복 종료 event가 꾸미기 파밍 수단이 될 위험. 유효 run 근거와 idempotent unlock을 요구한다.
- `SX-AUD-004-F40 · SAVE_MIGRATION_LOCKOUT_RISK`: 콘텐츠 삭제·save 손상으로 장착 화면이나 게임 시작이 막힐 위험. 기본 cosmetic fallback과 부분 복구를 요구한다.

현재 P0/P1 open finding은 없다. 구체 해금 방식·가격·희귀도·대표 스킨 자산·Android 가독성·사람 검증은 `NOT_DECIDED / NOT_STARTED / NOT_RUN`이다.
