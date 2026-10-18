# Notion 작업공간 맵

검증된 페이지와 데이터 소스만 기록한다. 이름이나 과거 대화만으로 ID를 추측하지 않는다.
처음 쓰는 사람은 `map-notion-workspace` 스킬로 아래 `<...>` 자리를 실제 값으로 채운다.
채운 파일에는 내 Notion ID가 들어가니 공개 저장소에 다시 올릴 때는 빼거나 자리표시자로 되돌린다.

## 등록된 루트/허브

| 이름 | 유형 | URL/ID | 용도 | verified_at | 확인 방법 |
|---|---|---|---|---|---|
| current Notion workspace | workspace | ID는 로컬 메모리에 저장하지 않음 | 연결 식별 | `<YYYY-MM-DD>` | Notion `fetch(self)` |
| 학업 | page | `https://app.notion.com/p/<STUDY_ROOT_ID>` | 학년·학기·과목 트리의 루트 | `<YYYY-MM-DD>` | search + fetch |

## 학업 작성 기준 페이지

과목마다 Notion에 `AI 활용 문서` 한 장을 두고 그 링크를 여기에 적는다. 양식은
[templates/ai-usage-doc.md](../../templates/ai-usage-doc.md), 공통 말투 예시는 [examples/ai-usage-docs/](../../examples/ai-usage-docs/)에 있다.

| 과목 | 페이지 | parent/path | verified_at | 확인 방법 |
|---|---|---|---|---|
| `<과목명>` | [AI 활용 문서](https://app.notion.com/p/<COURSE_AI_DOC_ID>) | 학업 / `<학년>` / `<학기>` / `<과목명>` | `<YYYY-MM-DD>` | search + fetch |

학교 LMS 과목 ID(`tools/<lms>-modules.js`로 확인, SETUP.md 1절):

| 과목 | LMS 과목 ID | 비고 |
|---|---|---|
| `<과목명>` | `<lms-course-id>` | 분반 혼동 주의 |

로컬 원본 자료 폴더: `<자료 폴더>/<과목>`. 사용자가 "○○ 폴더에 올렸다"고 하면 여기부터 본다.

이 링크는 탐색 시작점이다. 게시할 때마다 live fetch하고, 실제 Week/작품/개념 대상과 데이터
소스는 그 요청 범위에서 별도로 매핑한다.

## 데이터 소스

데이터 소스를 확인할 때 아래 형식으로 추가한다. database ID(컨테이너)와 data_source ID(스키마)를 따로 적는다.

### `<표시 이름>` (예: 문제은행)

- database URL/ID: `<DATABASE_ID>`
- data_source ID: `<DATA_SOURCE_ID>`
- parent: `<과목 페이지>`
- purpose:
- title property:
- unique/match key:
- verified_at:
- verified_with:

| 속성 | 타입 | 허용 값/관계 대상 | 필수 | 메모 |
|---|---|---|---|---|
| `주차` | select | Week 1, Week 2, … | 예 | 새 옵션 추가는 스키마 변경(승인 필요) |

## 페이지 템플릿/작성 기준

| 대상 | 기준 페이지/템플릿 | 적용 범위 | verified_at |
|---|---|---|---|
| 모든 한국어 학습 노트 | AI 활용 문서들의 공통 말투 synced block | 말투 | `<YYYY-MM-DD>` |
| `<과목>` 강의 페이지 | [Week 1](https://app.notion.com/p/<WEEK_PAGE_ID>) | 강의자료 기반 주차 페이지 예시 | `<YYYY-MM-DD>` |

## 관계 그래프

확인된 relation만 `A.property -> B.data_source_id` 형식으로 기록한다.

<!-- 예: 오답노트.관련 개념 -> 개념·오개념.<data_source_id> -->
