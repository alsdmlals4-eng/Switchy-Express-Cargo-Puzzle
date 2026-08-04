# Switchy Express: Cargo Puzzle

**Switchy Express: Cargo Puzzle**는 플레이어가 직접 선로를 건설해 화물을 만나는 순서를 만들고, 마지막에 실은 화물부터 내리는 LIFO 규칙을 역산해 제한 시간 안에 모든 배송을 끝내는 모바일 가로형 물류 퍼즐입니다.

## 핵심 재미

> 선로가 적재 순서를 만들고, LIFO가 역 방문 순서를 만들며, 같은 화물을 연속 하역한 Combo가 더 빠른 다음 배송으로 이어진다.

## 현재 제품 기준선

- 건설 불가 구역을 제외한 자유 선로 건설
- 선로별 건설비와 철거 전액 환급
- 수동 적재 기본·자동 적재 토글
- 무제한 CargoStack
- TOP 연속 동일 화물 자동 하역
- Combo 일시 가속·점수
- 제한 시간 미배송 실패, 마지막 하역 즉시 성공
- 신속·절약·점수 별과 속도·가격·점수 리더보드
- 1~10 튜토리얼, 11+ 챕터, 일일·주간 도전
- 성능 없는 꾸미기 보상

## 프로젝트 상태

```text
GMB-002 planning canon approved
SX-AUD-012 adversarial audit passed with replan required
legacy endless runtime exists
finite delivery runtime not aligned
next gate: FINITE_PUZZLE_DEFINITION_OF_READY
```

기존 무한 생존·연료·BOOST·capacity 8·pickup respawn 기준선은 `[대체됨/폐기]`이며, 기존 PR과 테스트는 역사적 구현 증거로 보존됩니다.

## 정본 읽기 순서

1. `기획서/00_프로젝트_허브/START_HERE.md`
2. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
3. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
4. `기획서/00_프로젝트_허브/CANON_REPLACEMENT_REGISTER.md`
5. `기획서/10_경험/CORE_GAMEPLAY.md`
6. `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
7. `기획서/50_제작_검증/SX_AUD_012_FINITE_DELIVERY_PIVOT_AUDIT.md`

## 기술

- Godot 4.7.1-stable
- GDScript
- Android / landscape
- GitHub 정본 + Google Sheets GDD 동기화
