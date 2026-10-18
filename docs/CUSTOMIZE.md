# 내 상황에 맞추기

이 저장소의 파일은 만든 사람이 실제로 쓰는 그대로입니다. 과목명, 교재, 모델 이름, 말투 규칙이 예시로 들어 있습니다.
내 상황에 맞추는 방법은 두 가지입니다.

1. **LLM에게 맡기기(권장).** [SETUP.md](../SETUP.md)를 채우고 `adapt-to-my-setup` 스킬을 실행합니다. 스킬이 아래 표를 보고 파일을 고칩니다.
2. **직접 고치기.** 아래 표에서 내 상황과 다른 줄만 골라 해당 파일의 그 절을 고칩니다.

어느 쪽이든 공용 안전 규칙(대상을 추측하지 않기, 쓰기 전에 다시 읽기, 큰 변경은 교차검토)은 그대로 둡니다.

## 꼭 바꿔야 하는 곳

| 파일 | 지금 들어 있는 것 | 바꿀 것 | SETUP.md |
|---|---|---|---|
| [.claude/memory/workspace-map.md](../.claude/memory/workspace-map.md) | 빈 템플릿(`<NOTION_ID>`) | 내 학업 페이지·과목별 `AI 활용 문서`·DB ID. `map-notion-workspace`가 채움 | 5 |
| [.claude/rules/learning-materials.md](../.claude/rules/learning-materials.md) 「주차 확정」 | 학교 LMS 주차 모듈 = Notion Week, 강의 다음 주 Q&A 번호 규칙 | 내 학교 LMS의 주차 표시 방식과 주차 스크립트 이름. LMS가 없으면 "강의자료 파일명의 주차" 같은 기준으로 바꿈 | 1 |
| [.claude/rules/learning-materials.md](../.claude/rules/learning-materials.md) 「강의 진도와 Supplementary」·「교수님 자료와 필기의 신뢰도」 | 작성자 수업에서 정한 진도·필기 규칙 | 내 수업에 맞는지 보고 남기거나 지움. **같은 규칙이 아래 두 스킬에도 있으니 함께 고침** | 4 |
| [.claude/skills/publish-learning-notes/SKILL.md](../.claude/skills/publish-learning-notes/SKILL.md) 3단계·6a | 3단계: `tools/<lms>-modules.js`로 주차 확인 / 6a: 마지막 필기 쪽까지가 진도, Supplementary는 항상 포함 | 3단계: 내 LMS 주차 조회 방법. 조회 도구가 없으면 "사용자가 확인한 주차표(`materials/index.md`)"로 바꿈 / 6a: 위 진도 규칙과 같게 | 1, 4 |
| [.claude/skills/build-textbook-problem-bank/SKILL.md](../.claude/skills/build-textbook-problem-bank/SKILL.md) | CS:APP, CLRS의 문제 종류와 번호 형식, 교수님 자료를 그대로 믿는 규칙 | 내 교재의 문제 종류(연습문제·장 끝 문제)와 번호 형식, 위 신뢰 규칙과 같게 | 4 |
| [.claude/memory/workspace-map.md](../.claude/memory/workspace-map.md) 「로컬 원본 자료 폴더」 | `<자료 폴더>/<과목>` | 내 강의자료 원본 폴더와 운영체제 경로 형식 | 3 |
| 새로 만드는 LMS 스킬([templates/lecture-download-skill.md](../templates/lecture-download-skill.md)) 6단계, [tools/transcribe.sh](../tools/transcribe.sh) 옵션 | 전사 도구 선택, `--language ko\|en` | 내 전사 도구와 과목별 강의 언어. 로컬 Whisper가 아니면 그 도구의 사용법을 6단계에 적음 | 2 |
| [.claude/memory/style-profile.md](../.claude/memory/style-profile.md) | 작성자 말투와 과목별 구성 요약 | 내 말투, 내 과목 | 4, 6 |
| [.claude/memory/meme-dictionary.md](../.claude/memory/meme-dictionary.md) | 빈 표 | 쓸 밈. 안 쓰면 비워 두고 아래 줄도 같이 고침 | 6 |
| [.claude/rules/content-style.md](../.claude/rules/content-style.md) 「학습 노트 문체」·「종결어미」, [examples/ai-usage-docs/공통 말투.md](../examples/ai-usage-docs/공통%20말투.md), [tools/lint-notion-content.py](../tools/lint-notion-content.py) `--tone` | 커뮤체 종결 비율, 욕설·밈 적극 사용, 린터의 `~다` 종결 30% 제한 | 내 말투 규칙. 말투를 바꾸면 공통 말투 예시도 같이 고치고, `~다` 제한이 필요 없으면 게시 전 검사에서 `--tone`을 빼거나 비율을 바꿈 | 6 |
| [AGENTS.md](../AGENTS.md) 1절 9번·5절·6절, [.claude/rules/cross-review.md](../.claude/rules/cross-review.md), [tools/claude-review.sh](../tools/claude-review.sh), `cross-review`·`build-textbook-problem-bank` 스킬 | `Asia/Seoul`, Codex `gpt-6-sol`·Claude `claude-opus-5-5` 같은 모델 이름, 밈 규칙 | 내 시간대와 지금 쓸 수 있는 모델. **값만** 바꾸고 검토 절차는 그대로 | 6, 7 |
| [.claude/rules/tool-routing.md](../.claude/rules/tool-routing.md) 「Codex 모델 선택」 | 작성 시점의 모델 선택표 | 내 계정에서 쓸 수 있는 모델(`codex debug models`로 확인) | 7 |
| [.codex/config.toml](../.codex/config.toml) | 기본 Codex 모델 | 내 기본 모델 | 7 |
| [CLAUDE.md](../CLAUDE.md) 스킬 인덱스 | 작성자가 쓰는 스킬 목록 | 새로 만든 스킬(강의 다운로드, 과목 전용)을 한 줄씩 추가 | 1, 4 |
| [.claude/rules/tool-routing.md](../.claude/rules/tool-routing.md) 「로컬 파일 업로드」 | Notion CLI는 캡처·PDF 업로드에만 쓰고 인증값을 환경변수로 옮기지 않음 | 스크립트 업서트나 CI 점검에 `ntn`을 쓰려면 이 절에 허용 범위와 인증 방식(`NOTION_API_TOKEN`은 CI 비밀 저장소에만)을 적음([NOTION-CLI.md](NOTION-CLI.md)) | 5 |

## 그대로 둬도 되는 곳

| 파일 | 이유 |
|---|---|
| [.claude/rules/notion-safety.md](../.claude/rules/notion-safety.md), [cross-review.md](../.claude/rules/cross-review.md), [course-ai-docs.md](../.claude/rules/course-ai-docs.md), [memory-policy.md](../.claude/rules/memory-policy.md) | 누구에게나 같은 안전 규칙 |
| `map-notion-workspace`, `capture-to-notion`, `run-notion-automation`, `audit-notion`, `cross-review`, `ingest-learning-materials`, `answer-study-questions` 스킬 | 과목·학교와 무관한 절차 |
| [templates/](../templates/), [tools/lint-notion-content.py](../tools/lint-notion-content.py), [tools/check-structure.sh](../tools/check-structure.sh) | 형식 검사와 양식 |
| [tools/lecture-to-audio.sh](../tools/lecture-to-audio.sh), [tools/transcribe.sh](../tools/transcribe.sh) | 내 컴퓨터의 영상 → mp3 → Whisper 전사. 학교와 무관 |

규칙 곳곳의 `(YYYY-MM-DD 사용자 지시)` 표시는 작성자가 그 규칙을 정한 기록입니다. 지우거나 내 날짜로 바꿔도 됩니다.

## LLM에게 줄 프롬프트

### 전체를 한 번에 맞추기

```text
SETUP.md를 읽고 adapt-to-my-setup 스킬로 이 저장소를 내 상황에 맞게 고쳐줘.
Notion에는 아직 쓰지 말고, 바꿀 파일과 절 목록부터 보여줘.
```

### 내 학교 사이트용 강의 영상 다운로드 만들기

학교마다 사이트 구조가 달라 다운로드 스크립트는 직접 넣지 않았습니다. LLM이 내 학교 사이트를 읽고 새로 만들게 합니다.

```text
templates/lecture-download-skill.md를 바탕으로 우리 학교 LMS용 강의 다운로드 스킬을 만들어줘.
LMS 주소는 SETUP.md 1절에 있어. 브라우저는 내가 직접 로그인할게.
사이트는 읽기만 하고, 내가 수강 중인 강의 하나로 먼저 시험해줘. 비밀번호·쿠키는 파일에 남기지 마.
```

### 과목 `AI 활용 문서` 만들기

과목마다 Notion에 이 문서가 있어야 에이전트가 그 과목의 구조와 말투를 따릅니다.

```text
templates/ai-usage-doc.md 양식으로 <과목명> AI 활용 문서 초안을 만들고 싶어.
한 번에 질문 하나씩 해서 자료 우선순위, 페이지 구조, 문제은행 규칙, 말투를 정해줘.
Notion에는 쓰지 말고, 다 정하면 materials/guides/에 전문을 저장해줘. Notion에는 내가 붙여 넣을게.
```

[AGENTS.md](../AGENTS.md) 1절 12번은 "과목 Notion 작업은 그 과목의 `AI 활용 문서`를 먼저 읽고 시작한다"는 규칙입니다. 문서가 아직 없을 때는
에이전트가 과목 트리에 쓸 수 없으므로, 초안은 로컬에 두고 **Notion 과목 페이지 아래에 직접 붙여 넣으세요.** 붙여 넣은 뒤부터는
에이전트가 그 문서를 읽고 작업을 시작합니다.

### 내 Notion 연결하기

```text
map-notion-workspace 스킬로 SETUP.md 5절의 학업 페이지를 읽기 전용으로 매핑해서 workspace-map.md를 채워줘.
```

### 한 과목만 끝까지 자동으로 처리하는 스킬 만들기

자주 반복하는 과목이 있으면 전용 스킬을 따로 두면 편합니다.

```text
<과목명> Week N을 처리할 때마다 하는 일을 스킬로 만들고 싶어.
publish-learning-notes와 build-textbook-problem-bank 절차를 바탕으로 .claude/skills/<slug>-weeks/SKILL.md를 만들고,
CLAUDE.md 스킬 인덱스에 한 줄 추가해줘.
```
