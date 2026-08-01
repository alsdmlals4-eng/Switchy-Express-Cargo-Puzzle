# Roadmap

## M0 — 운영체계 설치 · COMPLETE

- [x] GitHub 정본·Registry·Base Adapter·Google Sheets GDD 연결
- [x] 저장소만으로 현재 결정과 다음 작업 복원
- [x] 설치 검증 보고

## M1 — Vertical Slice 기반 · COMPLETE

- [x] Godot 4.7.1 프로젝트와 헤드리스 테스트 러너
- [x] 15×10 연결 철도망
- [x] 2단계·3단계 분기기
- [x] 직진 우선 기본 노선·5칸 경로 미리보기
- [x] 기관차 연속 이동·현재 구간 target lock
- [x] 최대 8개 화차의 제한된 이동 이력 추종

증거:

- PR #9 · `801632949d28564528e38d83dac59cccc6f06fb2`
- PR #12 · `0738d9c10e431a43e7a2f34590369c3f17d1f8a5`

## M2 — 핵심 생존 루프 · IN_PROGRESS

완료:

- [x] LOAD 선택 적재
- [x] 색상+모양 화물 타입
- [x] 색상별 최소 화물 4개와 runtime 복구
- [x] 스테이션 6개 배치
- [x] 최대 8칸 LIFO 하역
- [x] 실제 기차 수거→스택→역→하역 통합

남음:

- [ ] 시간별 기본 속도 상승
- [ ] 화물 감속
- [ ] 연료·배송 보상
- [ ] 점수·combo
- [ ] BOOST 속도·추가 연료 소비
- [ ] 게임오버·재시작·로컬 기록
- [ ] 무입력 영구 생존 방지

현재 증거:

- PR #12 · `0738d9c10e431a43e7a2f34590369c3f17d1f8a5`
- PR #13 · `4e435a1a6d10ab146197671049da80709fd18c1f`
- Godot headless `9 cases / 6915 assertions / 0 failures`

M2 종료 기준: 배송 성공으로 점수·연료를 얻고, 실제 시간 연료 drain과 난이도 상승으로 무입력 영구 생존이 불가능하며, 연료 0에서 run이 종료된다.

## M3 — 목표 품질 Vertical Slice · NOT_STARTED

- [ ] 기능적 모바일 가로형 gameplay scene·HUD
- [ ] 귀엽고 친근한 프리미엄 캐주얼 시각 방향
- [ ] 접근성 모양 표식
- [ ] 효과음·진동·주요 피드백
- [ ] 분기 상태·화살표·실제 경로의 시각 일치
- [ ] 대표 플레이 캡처
- [ ] Android export·실기 성능

Issue #6에서 기능 HUD를 시작하지만 최종 시각 품질은 Issue #7까지 완료로 보지 않는다.

## M4 — 플레이테스트·Production Gate · NOT_STARTED

- [ ] 행동 로그와 플레이테스트 기록
- [ ] 맵 다양성·경로 엔트로피 측정
- [ ] 밸런스 재조정
- [ ] MUST_FIX 회귀 검증
- [ ] Production 진입 판단

## 현재 실행 순서

```text
Issue #6 · VS-03 연료·속도·점수·BOOST·기능 HUD
→ Issue #7 · 목표 시각 품질·Android·접근성·soak·플레이테스트
→ Production Gate
```
