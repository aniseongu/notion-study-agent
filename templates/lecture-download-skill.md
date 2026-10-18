<!--
학교 LMS용 강의 다운로드 스킬 양식입니다. 이 파일은 스킬로 로드되지 않습니다.
LLM이 이 양식을 바탕으로 .claude/skills/<lms>-lecture-to-txt/SKILL.md 와 tools/<lms>-*.js|py 를 만듭니다.
<...> 자리는 학교 사이트를 실제로 읽어 보고 채웁니다. 추측으로 채우지 않습니다.
-->
---
name: <lms>-lecture-to-txt
description: Download the user's own <학교 LMS 이름> lecture video, encode it to mp3, and produce a transcript TXT for the user to review. Stops before Notion.
---

# <학교 LMS 이름> Lecture → MP3 → TXT

범위는 사용자가 확인할 로컬 TXT까지다. Notion에는 쓰지 않는다. 확인된 TXT는 사용자가 요청할 때
`ingest-learning-materials` → `publish-learning-notes`로 넘긴다.

## 지켜야 할 것 (학교와 무관하게 그대로 둠)

- 사용자가 수강 중인 강의, 사용자가 지정한 항목만 개인 학습용으로 받는다. 과목 전체 일괄 다운로드와 공개 전 항목은 받지 않는다.
- DRM·암호화 스트림은 우회하지 않는다. 직접 재생되는 파일(예: progressive mp4)이 아니면 멈추고 알린다.
- 로그인은 사용자가 Playwright 브라우저에서 직접 한다. 비밀번호·쿠키·토큰·학번을 입력하거나 요청하거나 출력하거나 저장하지 않는다.
- CAPTCHA·추가 인증이 나오면 즉시 멈추고 사용자에게 넘긴다. 탐지 우회는 쓰지 않는다.
- 사이트에는 읽기(GET)만 한다. 출석·진도 기록을 바꾸는 요청은 보내지 않는다.

## 사이트 구조 (LLM이 읽고 채움)

| 항목 | 값 |
|---|---|
| 과목 주소 형식 | `<예: https://<lms>/courses/<id>>` |
| 로그인 페이지 판별 | `<리다이렉트되는 주소>` |
| 주차·모듈 목록을 얻는 방법 | `<페이지 DOM / 공개 API 경로>` |
| 영상 항목 식별자(매칭 키) | `<content_id 같은 고유 값>` |
| 영상 파일 주소를 얻는 방법 | `<재생 페이지에서 찾은 mp4 주소 규칙>` |

## 만들 도구

- `tools/<lms>-list.js`: 로그인된 과목 페이지에서 `browser_evaluate`로 실행. 주차·제목·길이·공개 상태·식별자를 돌려준다. 인증값은 반환하지 않는다.
- `tools/<lms>-modules.js`: 주차별 모듈 표(주차 → 항목 제목·슬라이드 범위). `learning-materials.md` 「주차 확정」이 쓴다.
- `tools/<lms>-download.py`: 식별자로 mp4를 `materials/courses/<slug>/video/`에 받고, `tools/lecture-to-audio.sh`로 mp3를 만든다. 파일명은 `<제목> [<식별자>].mp4`이고 같은 파일이 있으면 건너뛴다.

## 순서

1. 과목 주소로 이동한다. 로그인 페이지면 사용자에게 로그인을 부탁하고 기다린다.
2. `tools/<lms>-list.js`로 목록을 보여 주고 받을 항목을 사용자에게 확인한다.
3. 과목 slug를 정한다(`materials/courses/<slug>/`, 없으면 `_template` 복사).
4. 다운로드·mp3 변환 후 `created / skipped / failed`를 그대로 보고한다.
5. `ffprobe`로 mp4와 mp3 길이를 비교한다(차이 1초 미만).
6. 전사: SETUP.md 2절의 도구. 로컬이면 `tools/transcribe.sh [--language ko|en] <slug> <mp3>`.
7. 전사 범위(시작·끝·누락 구간)를 `materials/index.md`에 적는다.

## 처음 만들 때 시험

수강 중인 강의 하나로 1~7을 끝까지 돌려 보고, 결과 파일과 이 스킬의 표를 사용자에게 보여 준 뒤 `CLAUDE.md` 스킬 인덱스에 추가한다.
