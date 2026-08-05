# Android Device Smoke Evidence Template

> Template only. This file is not execution evidence and must remain `NOT_RUN` until completed from a physical-device session.

```yaml
record_state: TEMPLATE_NOT_EXECUTED
current_audit: SX-AUD-019
current_evidence: EV-FP-APK-001
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
device_alias:
device_model:
android_version:
resolution_density:
orientation: landscape
input_method: touch
executed_at:
tester_alias:
item_results:
  AND-01: NOT_RUN
  AND-02: NOT_RUN
  AND-03: NOT_RUN
  AND-04: NOT_RUN
  AND-05: NOT_RUN
  AND-06: NOT_RUN
  AND-07: NOT_RUN
  AND-08: NOT_RUN
  AND-09: NOT_RUN
  AND-10: NOT_RUN
  AND-11: NOT_RUN
  AND-12: NOT_RUN
  AND-13: NOT_RUN
  AND-14: NOT_RUN
  AND-15: NOT_RUN
  AND-16: NOT_RUN
  AND-17: NOT_RUN
  AND-18: NOT_RUN
  AND-19: NOT_RUN
  AND-20: NOT_RUN
recording_references:
screenshot_references:
crash_anr_log_reference:
observations:
overall_gate: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED
```

## 항목별 기록표

| ID | Status | Evidence reference | Observation / Failure detail |
|---|---|---|---|
| AND-01 | NOT_RUN | | |
| AND-02 | NOT_RUN | | |
| AND-03 | NOT_RUN | | |
| AND-04 | NOT_RUN | | |
| AND-05 | NOT_RUN | | |
| AND-06 | NOT_RUN | | |
| AND-07 | NOT_RUN | | |
| AND-08 | NOT_RUN | | |
| AND-09 | NOT_RUN | | |
| AND-10 | NOT_RUN | | |
| AND-11 | NOT_RUN | | |
| AND-12 | NOT_RUN | | |
| AND-13 | NOT_RUN | | |
| AND-14 | NOT_RUN | | |
| AND-15 | NOT_RUN | | |
| AND-16 | NOT_RUN | | |
| AND-17 | NOT_RUN | | |
| AND-18 | NOT_RUN | | |
| AND-19 | NOT_RUN | | |
| AND-20 | NOT_RUN | | |

## 환경 기록

```yaml
installation_source:
apk_hash_command_or_tool:
apk_hash_observed:
package_identity_observed:
landscape_lock_observed:
touch_input_observed:
network_state_if_relevant:
battery_or_thermal_observation:
```

## 개인정보·증거 위생

- 실명, 전화번호, 이메일, 계정 ID와 연락처를 기록하지 않는다.
- IMEI, 시리얼 번호, 광고 ID와 기타 기기 고유번호를 기록하지 않는다.
- 알림, 메시지, 사진, 다른 앱 화면과 계정 프로필을 녹화하지 않는다.
- `device_alias`와 `tester_alias`는 `D01`, `T01` 같은 최소 식별자만 사용한다.
- 스크린샷·영상·로그 파일명에는 APK hash 축약값과 `AND-xx`를 사용한다.
- 원본 로그에 민감정보가 포함되면 공개 저장소에 올리지 않고 안전한 위치와 redacted excerpt만 기록한다.

## 판정 규칙

- 모든 AND-01~20이 canonical hash의 물리 Android 기기에서 PASS일 때만 `overall_gate`를 PASS 후보로 작성한다.
- 하나라도 FAIL이면 `overall_gate: FAIL`이다.
- hash·package·기기·증거 선행 조건이 없으면 `overall_gate: BLOCKED`다.
- 하나라도 미실행이면 `overall_gate: NOT_RUN`이다.
- 작성된 Template은 검토·적대적 재검증·정본 closure 전에는 Android PASS 권위가 아니다.
- Android 결과가 PASS 후보여도 Five-person Comprehension과 Production Cutover는 별도 Gate다.
