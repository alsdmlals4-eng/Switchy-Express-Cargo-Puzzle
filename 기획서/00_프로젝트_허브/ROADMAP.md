# Roadmap

## M0 — 운영체계 설치 · COMPLETE

- [x] GitHub 정본·Registry·Base Adapter·Google Sheets GDD 연결
- [x] 새 작업자가 저장소만으로 현재 결정과 다음 작업 복원
- [x] Base v9.4 운영 계약 적용

## M1 — 철도·열차·화물 기반 · COMPLETE

- [x] Godot 4.7.1 프로젝트와 헤드리스 테스트 러너
- [x] 15×10 연결 철도망
- [x] 2단계·3단계 분기기
- [x] 직진 우선 기본 노선·5칸 경로 미리보기
- [x] 연속 기관차 이동·경로 보간
- [x] 최대 8개 화차의 제한된 이동 이력 추종
- [x] LOAD 선택 적재와 LIFO stack
- [x] 스테이션 6개와 색상별 pickup 최소 4개
- [x] 런타임 재생성 회복

증거:

- PR #9 / `801632949d28564528e38d83dac59cccc6f06fb2`
- PR #12 / `0738d9c10e431a43e7a2f34590369c3f17d1f8a5`
- PR #13 / `4e435a1a6d10ab146197671049da80709fd18c1f`
- Godot `9 cases / 6915 assertions / 0 failures`

남은 품질 증거: 실제 화면 가독성, 맵 다양성·경로 엔트로피, 장시간 soak.

## M2 — 총기획·정본 복구 · IN_PROGRESS

- [x] Post-VS02 실제 구현과 정본 드리프트 감사
- [x] 잘못 제공된 타 프로젝트 Sheet 제외
- [ ] Post-VS02 GitHub 정본 복구 PR
- [ ] 올바른 Switchy Express Sheet 동기화
- [ ] Sync Closure PR
- [ ] 전체 기획 Coverage 감사
- [ ] 분야 간 충돌 적대적 검토
- [ ] 중요 기획 공백 Grill Me
- [ ] VS-03 Codex Definition of Ready

완료 기준: GitHub 정본·Issue·Plan·Sheet가 실제 구현과 일치하고, 중요한 기획 충돌이 Decision ID로 닫히며, 상세 수치는 시험값으로 구분된다.

## M3 — 핵심 생존 루프 · NOT_STARTED

### VS-03A · 생존 경제 도메인

- [ ] 시간 기반 기본 속도 상승
- [ ] 화물 수에 따른 속도 감소
- [ ] 시간 기반 연료 소모
- [ ] BOOST 속도·추가 연료 소모
- [ ] 배송 점수·연료 보상
- [ ] 무입력 영구 생존 방지
- [ ] 연료 0 게임오버와 결과 요약

### VS-03B · 제품 플레이 화면

- [ ] RailBoardView·SwitchView
- [ ] LOAD·BOOST·Unload Order HUD
- [ ] 결과 화면·즉시 재시작
- [ ] 최고 점수·최장 생존·최대 콤보 저장
- [ ] 저장 버전·손상 fallback
- [ ] 48dp·safe area·Reduced Motion·mute·haptic-off
- [ ] 대표 상태 캡처

M3 종료 기준: 한 세션이 시작→운행→적재→분기→하역→보상→연료 0→결과→재시작까지 실제로 연결되고 자동 테스트가 통과한다.

## M4 — 목표 품질·플레이테스트 · NOT_STARTED

- [ ] 텔레메트리와 저장 지속성 검증
- [ ] 10분 headless soak
- [ ] Android 실제 기기 실행·성능
- [ ] 첫 경험 사용자 5명 이상
- [ ] 맵 다양성·경로 엔트로피 측정
- [ ] 밸런스 재조정
- [ ] MUST_FIX 회귀 검증
- [ ] Production Gate

## 현재 실행 순서

```text
Post-VS02 Canonical Recovery
→ Sheet Sync Closure
→ Total Planning Coverage·Adversarial Audit
→ Grill Me Decision Queue
→ VS-03A
→ VS-03B
→ VS-04
→ Production Gate
```
