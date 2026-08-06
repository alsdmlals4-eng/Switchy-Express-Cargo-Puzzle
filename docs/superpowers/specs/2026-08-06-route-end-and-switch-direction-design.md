# Route End and Switch Direction Design

## Status

```yaml
approval_batch_id: GMB-003
decision_ids:
  - SX-DEC-040
  - SX-DEC-041
  - SX-DEC-042
user_evidence:
  - EV-USER-028
  - EV-USER-029
audit_id: SX-AUD-026
canonical_patch_commit: 8dbdb62799d11e901f68fdbb09a6aa7eb57a9e75
state: APPROVED_PENDING_MERGE
```

## Player-observed evidence

- `EV-USER-028`: 로컬 F5에서 빨간 역은 한쪽 reciprocal 연결로 인정됐지만 파란 역은 인정되지 않았다.
- `EV-USER-029`: 마지막 배송 뒤 `SUCCESS` 결과 표시는 정상 노출됐다.
- 이 증거는 사용자 로컬 관찰이다. 정확한 local HEAD, 파란 역의 선로 회전·접근 방향, 로그는 아직 수집되지 않았으므로 자동 재현 전까지 색상별 원인을 단정하지 않는다.

## Protected product meaning

- 선로 건설, 자동 운행, 수동/자동 적재, unlimited LIFO, TOP 연속 동일 화물 하역은 유지한다.
- 마지막 필수 배송의 성공 판정은 같은 프레임의 노선 끝 실패보다 우선한다.
- Windows와 Android는 동일 게임 규칙·데이터 코어를 사용한다.
- UI와 화살표는 경로 상태를 표시하고 입력 의도를 전달할 뿐, 독립적인 경로 권위가 되지 않는다.

## SX-DEC-040 — One-sided station color parity

모든 역 색상과 화물 종류는 동일한 연결 규칙을 사용한다.

```text
시작점에서 구조적으로 도달 가능
AND 역 칸에 reciprocal 연결 이웃 선로가 1개 이상 존재
→ CONNECTED_STATION
```

빨간색, 파란색 또는 향후 추가 색상에 따른 예외는 두지 않는다. 역 반대편을 관통하는 두 번째 연결은 요구하지 않는다.

### Acceptance

- RED_STAR 한쪽 연결 역이 Preflight를 통과한다.
- BLUE_DIAMOND 한쪽 연결 역이 동일한 구조에서 Preflight를 통과한다.
- 두 색상 모두 마지막 필수 화물을 하역하면 성공한다.
- 테스트가 현재 코드에서 이미 통과하면 `COLOR_DOMAIN_PARITY_ALREADY_GREEN`으로 기록하고, 사용자 관찰은 특정 로컬 SHA·선로 회전·런타임 표현의 후속 재현 항목으로 유지한다.

## SX-DEC-041 — Route-end game over

기차가 `RUNNING` 상태이고 현재 칸의 접촉·하역 판정을 처리한 뒤에도 합법적인 다음 칸이 없으면 즉시 실패한다.

```text
RUNNING
→ cell contact 처리
→ delivery/unload 결과 처리
→ final delivery SUCCESS가 아니며 legal next cell 없음
→ FAILURE(reason=ROUTE_END)
```

### Ordering

1. 칸 진입과 화물 접촉을 먼저 처리한다.
2. 마지막 필수 배송이 확정되면 unload 연출 완료 후 `SUCCESS`다.
3. 마지막 배송이 아니고 하역 중이면 하역 연출을 완료한 뒤 `ROUTE_END`를 판정한다.
4. 접촉·하역이 없으면 노선 끝 도달 즉시 `ROUTE_END`다.
5. 제한 시간 실패는 별도 `TIME_EXPIRED` 사유를 유지한다.

### Recovery

- 결과 화면에서 같은 배치 재시도와 편집으로 복구할 수 있다.
- 실패가 레이아웃을 자동 변경하지 않는다.

## SX-DEC-042 — Direct switch direction arrows and U-turn

운행 중 `SWITCH` 칸은 reciprocal 연결된 세 방향을 각각 화살표로 표시한다.

- 선택 방향은 강조한다.
- 선택되지 않은 연결 방향도 항상 보이게 한다.
- 사용자는 원하는 화살표를 직접 클릭·터치해 해당 방향을 선택한다.
- 진입해 온 방향의 화살표도 선택할 수 있으며, 이 경우 기차는 분기에서 되돌아간다.
- 열차가 분기 칸을 점유한 동안 선택을 잠근다.
- 키보드·기존 보조 명령은 상태 순환 방식으로 세 방향을 모두 순회한다.
- `CROSSING`은 이번 배치에서 기존 `STRAIGHT/RIGHT/LEFT` 모드를 유지한다.

### Domain contract

`FiniteTrackSwitch`가 세 연결 포트와 선택 포트를 소유한다. Overlay는 `available_exits`와 `selected_exit`를 읽고 선택 의도를 Controller로 보낸다. Overlay가 열차의 다음 칸을 직접 계산하거나 변경하지 않는다.

### Interaction contract

- 화살표 hit target은 각 방향 끝 주변 최소 44 px 상당 영역을 목표로 한다.
- RUNNING·UNLOADING에서만 조작 가능하다.
- BUILD, PAUSED, SUCCESS, FAILURE에서는 입력을 통과시키거나 무시한다.
- 색상만으로 선택 상태를 구분하지 않고 굵기·채움 차이를 함께 사용한다.

## Visual and asset decision

```yaml
visual_status: NO_NEW_VISUAL_ASSET_REQUIRED
reason: 기존 RouteControlOverlay의 절차적 line/polygon arrow를 확장한다.
new_binary_assets: none
new_external_license: none
```

## Adversarial cases

- 파란 역만 색상 분기 코드로 누락되는 경우
- 노선 끝에서 TrainController assertion으로 crash하는 경우
- 마지막 배송 직후 ROUTE_END가 SUCCESS를 덮는 경우
- 비최종 하역 중 즉시 실패해 하역 상태가 손상되는 경우
- 선택 화살표와 실제 `next_cell`이 다른 경우
- U턴 시 이전 칸 금지 assertion이 남아 있는 경우
- 잠긴 분기에서 화살표 선택이 적용되는 경우
- Overlay가 BUILD의 선로 배치 클릭을 가로채는 경우
- Crossings까지 무단으로 U턴 계약이 확대되는 경우

## Verification ceiling

자동 테스트와 GitHub Actions가 통과해도 다음은 별도 수동 증거 전까지 `NOT_RUN` 또는 `RETEST_REQUIRED`다.

- 실제 로컬 F5 파란 한쪽 연결 역
- 실제 화살표 크기·가독성·터치 선택
- Windows artifact runtime·visual·audio smoke
- Android physical-device smoke
- five-person comprehension
- production cutover
