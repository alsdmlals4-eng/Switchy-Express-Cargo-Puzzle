# Codex Goal — VS-02 기차·화차·화물·스테이션·LIFO

Status: `COMPLETE · HISTORICAL_EXECUTION_CONTRACT`
GitHub Issue: `#5 · CLOSED`
Parent Epic: `#3`
Implementation PR: `#12`
Runtime recovery PR: `#13`
Implementation main: `0738d9c10e431a43e7a2f34590369c3f17d1f8a5`
Validated recovery main: `4e435a1a6d10ab146197671049da80709fd18c1f`
Plan: `docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md` Task 4~5

이 파일은 완료된 VS-02의 역사 실행 계약이다. 새 구현에 다시 사용하지 않는다.

## 완료 결과

- 선택된 RailGraph 경로를 따르는 연속 기관차 이동
- 최대 8개 화차의 제한된 route-history 추종
- segment target lock과 분기 통과 후 reset
- LOAD 상태의 화물 적재
- `RED_STAR / BLUE_DIAMOND / YELLOW_TRIANGLE`
- capacity 8 LIFO stack과 unload-order ViewModel
- 색상별 스테이션 2개·총 6개
- 색상별 map pickup 최소 4개
- 금지 칸·전방 2칸·직전 위치 제외
- 1초 지연·bounded·deterministic respawn
- `SPAWN_DEFERRED` 회복
- LIFO 동일색 연속 그룹 하역
- cell boundary 시각의 DeliveryLoop 이벤트
- 실제 런타임 pending respawn 처리

## 최종 증거

```text
PR #12: 9 cases / 6908 assertions / 0 failures
PR #13: 9 cases / 6915 assertions / 0 failures
Project Contract: PASS
```

## 후속 작업

현재 기획·Codex 준비 상태는 `CODEX_GOAL_VS_03.md`가 책임진다.
