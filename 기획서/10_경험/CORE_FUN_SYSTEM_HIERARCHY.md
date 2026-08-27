# [대체됨] Core Fun and System Hierarchy

상태: `[대체됨]`

기존 문서는 `LIFO 적재 계획 → 노선 준비 → 위험/생존 → BOOST` 위계를 책임졌다. `GMB-002`에서 생존·연료·BOOST가 제품에서 폐기되고 player track construction·finite delivery가 핵심으로 승격됐다.

현재 위계:

```text
선로 건설로 조우 순서 설계
→ 수동/자동 적재로 무제한 LIFO 구성
→ 분기 전환으로 역 방문 순서 실행
→ 연속 그룹 하역 결과 읽기
→ 시간·비용을 고려한 재설계
```

현재 책임 원본:

- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `기획서/10_경험/CORE_GAMEPLAY.md`
- `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`

old hierarchy는 git history와 `CANON_REPLACEMENT_REGISTER.md`에서 역사 자료로만 보존한다.
