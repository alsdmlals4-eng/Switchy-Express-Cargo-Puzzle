# Core Fun Alignment and Benchmark Audit

```yaml
audit_id: SX-AUD-007
evidence_id: EV-USER-017~018
scope: core fun · core/support systems · benchmark · PR #37/#38 · current main · package sequencing
state: PASS_WITH_FOLLOWUPS · CANONICAL_MERGED · SHEET_READBACK_PASS
canonical_merge: a9368617102420639cc2bb83ee2b0c45505958a6
product_rule_change: NONE
current_package_authority: VS03-02_ONLY
```

## 1. 감사 목적

현재 승인된 시스템이 프로젝트의 핵심 재미를 실제로 강화하는지, 보조 시스템이 핵심을 가리거나 구현 순서가 핵심 검증을 늦추는지 확인한다.

또한 PR #37과 #38 이후 코드·정본·Issue·Sheet 상태를 대조하고, 앞으로 Grill Me와 주요 기획 작업에 외부 벤치마크와 현업 비교를 의무 입력으로 추가한다.

## 2. 한 문장 핵심 재미

> 자동으로 달리는 열차에서 **앞으로 필요한 하역 순서를 역산해 화물을 골라 싣고**, 분기기를 미리 바꾸며, 무게와 연료 압박을 감수해 **큰 LIFO 하역 그룹을 성공시키는 계획형 생존 퍼즐**.

핵심은 단순 철도 운행이나 빠른 탭이 아니다.

```text
적재 순서 계획
→ 노선 선행 결정
→ 위험을 감수한 운반
→ 뒤쪽부터 의도한 그룹 하역
→ 큰 Combo와 생존 연장
```

## 3. 시스템 위계

### 3.1 핵심 시스템

1. **선택 적재와 capacity 8 LIFO CargoStack**
2. **자동 운행과 선행 분기 결정**
3. **색상별 station과 연속 그룹 하역**
4. **생존 경제**
5. **BOOST 위험 교환**
6. **compact token / rear=LIFO-top 가독성**

### 3.2 보조 시스템

- 상황형 첫-run onboarding과 Help
- PREP camera·FULL_MAP_READY·active full-map camera
- HUD·Unload Order·rear item·difficulty signal
- evidence-based result insight와 same-map restart
- official map discovery·reselection·minimum target3 catalog
- global/per-map personal records
- cosmetic collection·unlock·bounded cosmetic currency
- Profile single-writer transaction·save recovery
- telemetry·economy simulation·playtest evidence
- Production target100 official catalog
- Production online UGC·publication·moderation·community signals

보조 시스템은 핵심 판단을 강화해야 하며, 점수·재화·목록·콘텐츠 양으로 핵심 재미를 대체하면 안 된다.

## 4. 핵심 재미 우선순위

```text
1. LIFO 적재 순서 계획
2. 목적 역까지의 노선 선행 결정
3. 큰 그룹을 위한 위험·생존 판단
4. BOOST와 배송 속도의 전술적 시간 관리
5. 결과 학습·재도전
6. 기록·꾸미기·맵 발견·UGC
```

적대적 기준:

- 빠른 탭이나 BOOST 사용이 1~3을 이기면 방향 이탈이다.
- 단색 화물만 골라 싣는 전략이 항상 최적이면 LIFO 퍼즐이 붕괴한다.
- 메타 보상이 실제 적재·노선 판단보다 강한 재도전 이유가 되면 핵심 검증이 왜곡된다.
- 난이도 증가는 입력 정밀도보다 의미 있는 판단 빈도와 기회비용을 높여야 한다.

## 5. 외부 벤치마크

조사일: `2026-08-03`

| 벤치마크 | 가져올 점 | 가져오지 않을 점 |
|---|---|---|
| Mini Metro | 점진적 압력과 학습 가능한 실패 | 노선 건설 자체를 핵심으로 확대하지 않음 |
| Conduct THIS! | 적은 입력과 즉각적인 분기 피드백 | 충돌 회피·반사신경을 주된 재미로 만들지 않음 |
| Railbound | 화차 순서·경로 결과의 인과 가독성 | 정답형 고정 puzzle로 endless survival을 대체하지 않음 |
| Train Valley 2 | 공식 콘텐츠와 사용자 콘텐츠의 단계 분리 | 핵심 검증 전 tycoon·UGC 규모 확대 금지 |
| Rail Route | 권위 있는 routing model과 presentation 분리 | signal·자동화·건설 복잡도를 모바일 핵심에 도입하지 않음 |

벤치마크 결론:

```text
Conduct THIS!의 실시간 분기 압박
+ Mini Metro의 점진적 생존 압력
+ Railbound의 화차·경로 인과 가독성
+ Switchy 고유의 선택 적재 LIFO 그룹 계획
```

위 조합에서 LIFO 그룹 계획이 가장 앞에 남아야 한다.

## 6. PR #37 / #38 적대적 검토

잘 맞는 부분:

- `Combo == unload_result.count`를 코드·테스트에서 고정했다.
- cargo slowdown이 fuel drain을 할인하지 않는다.
- BOOST 속도·추가 연료 비용·LOAD 배제가 분리됐다.
- cell event, run clock, difficulty event, fuel-zero 순서를 테스트했다.
- 실제 DeliveryLoop·CargoStack·Station 결합을 검증했다.
- PR #38은 VS03-02만 다음 권위로 승격했다.

## 7. Finding 상태

| Finding | 내용 | 심각도 | 최종 상태 |
|---|---|---:|---|
| SX-AUD-007-F86 | current consumer status drift | P1 | `FIXED` |
| SX-AUD-007-F87 | 30초 DifficultyDirector와 45초 fuel boundary authority split | P1 | `CORRECTION_PLANNED · VS03-R1 · NOT_STARTED` |
| SX-AUD-007-F88 | core-fun hierarchy unstated | P1 | `FIXED` |
| SX-AUD-007-F89 | mono-color loading dominant-strategy risk | P1 evidence gap | `VALIDATION_NOT_RUN` |
| SX-AUD-007-F90 | landscape one-hand reach ambiguity | P1 UX | `SINGLE_POINTER_NORMALIZED · DEVICE_NOT_RUN` |
| SX-AUD-007-F91 | Profile/meta before playable surface | P1 execution | `RESOLVED_BY_EV-USER-018 · OPTION_C` |
| SX-AUD-007-F92 | compact token readability at full-map Android view | P1 evidence gap | `DEVICE/HUMAN_NOT_RUN` |
| SX-AUD-007-F93 | benchmark/professional comparison missing from Grill Me process | P1 process | `FIXED_IN_PROJECT_SKILL` |

### F87 교정 원칙

```text
speed pressure boundary: 30초
fuel pressure boundary: 45초
DifficultyDirector: 실제 경계의 union schedule 단독 권위
```

30·45·60·90초 및 large delta를 test-first로 검증한다. 제품 수치나 의미를 바꾸지 않는다.

### F89 검증 항목

- 2색 이상 stack 비율
- stack distinct-type count/entropy
- mono-color delivery 비율
- Combo 1/2/3/4/5+ 분포
- group-size base / speed / heavy bonus 점수 비중
- 다른 화물 때문에 목표 화물이 막힌 보유 시간

강제 혼합·pickup 조정·보너스 재설계는 증거 없이 도입하지 않는다.

### F90 정의 보정

```text
single-pointer friendly
+ simultaneous chord input 불필요
+ 한 번에 하나의 semantic input만 요구
```

실제 손 reach는 Android에서 별도 검증한다.

## 8. 사용자 승인 — EV-USER-018

사용자는 benchmark-backed 권장안 C와 작성된 설계 정본을 승인했다.

```text
VS03-01 DONE
→ VS03-02 current authority
→ VS03-03 target3 maps/session/restart/selection
→ VS03-R1 difficulty authority alignment
→ VS03-05A minimal playable core surface
→ VS03-04 Profile/records/cosmetics/unlocks/rewards
→ VS03-05B result/collection/map browser
→ VS03-06 contextual onboarding
→ VS03-07 integration/evidence handoff
```

승인 이유:

- 실제 화면에서 LIFO·분기·생존 재미를 meta 전에 검증한다.
- Profile schema를 임시 UI가 선점하지 않는다.
- 05A는 read-only presentation과 semantic input만 소유한다.
- 05B는 실제 Profile transaction receipt가 존재한 뒤 result·collection·browser를 구현한다.

## 9. 정본 설계와 구현 계획

```text
docs/superpowers/specs/2026-08-03-playable-core-before-meta-sequencing-design.md
docs/superpowers/plans/2026-08-03-vs03-core-first-resegmentation.md
docs/superpowers/plans/2026-08-03-vs03-r1-difficulty-authority-alignment.md
docs/superpowers/plans/2026-08-03-vs03-05a-minimal-playable-core-surface.md
```

계획 상태:

- `VS03-R1`: executable TDD plan complete, blocked by VS03-03.
- `VS03-05A`: executable TDD plan complete, blocked by VS03-R1.
- `VS03-04`: 기존 상세 책임 유지, blocked by VS03-05A.
- `VS03-05B`: result·collection·browser 책임으로 분리.

## 10. 앞으로의 Benchmark-backed Grill Me

```text
현재 프로젝트 근거
→ 가까운 벤치마크
→ 인접 장르 또는 현업 사례
→ 비교 축
→ 업계 기본안
→ Switchy에 적합한 점과 복제하지 않을 점
→ 옵션별 제작 비용
→ 가장 강한 실패 위험
→ 권장안
→ 적대적 반론
→ 자동·simulation·device·human 검증 방법
```

중요 player-facing choice, package sequencing, 플랫폼·접근성·경제·온라인 정책에 적용한다. 안전한 구현 교정에는 불필요한 Decision을 추가하지 않는다.

## 11. Canonical evidence

```text
PR #39 exact head 577af564a0c20789b36bf379f91d7745a285ba4d
18 planning/current-consumer/project-Skill files
product files 0
Project Contract 265 PASS
Godot Tests 247 PASS
behind 0 · thread 0 · REQUEST_CHANGES 0
canonical merge a9368617102420639cc2bb83ee2b0c45505958a6
correct Sheet 12-tab readback PASS
```

## 12. 최종 판정

```text
core_direction: KEEP_AND_SHARPEN
player_rule_change: NONE
F91: RESOLVED
F87: PLANNED_NOT_IMPLEMENTED
current_build_authority: VS03-02_ONLY
sync: CANONICAL_MERGED · SHEET_READBACK_PASS
```

제품 Scene runtime·Android·soak·localization/accessibility·economy simulation·captures·5명+ 사람 검증·target100·online UGC는 계속 `NOT_RUN`; `F58`은 `NOT_MET`다.
