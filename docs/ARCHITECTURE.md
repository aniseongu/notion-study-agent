# 구조 자세히 보기

README의 흐름도보다 깊게 보고 싶을 때 읽는 문서입니다. 파일끼리 어떻게 읽히는지, 스킬끼리 어떻게 이어지는지,
Notion 쪽 문서가 어떻게 배치되는지를 그림과 표로 정리했습니다.

## 1. 규칙 파일이 읽히는 순서

진입점은 도구마다 다르지만 모두 `AGENTS.md` 하나로 모입니다. `AGENTS.md`에는 항상 지킬 규칙만 두고, 자세한 절차는
`rules/`와 스킬로 나눴습니다. 에이전트는 필요한 rule·memory만 그때 읽습니다.

```mermaid
flowchart TD
    CL["CLAUDE.md<br>Claude Code 진입점"]
    CX[".codex/README.md<br>Codex 진입점"]
    AG["AGENTS.md<br>공용 규칙 원본"]
    SK[".claude/skills/*/SKILL.md<br>상황별 절차"]
    R[".claude/rules<br>notion-safety · course-ai-docs<br>learning-materials · content-style<br>tool-routing · cross-review · memory-policy"]
    M[".claude/memory<br>workspace-map · recipes · decisions<br>error-log · style-profile · meme-dictionary"]
    PL["PLANS.md → plans/"]
    TP["templates/<br>plan · review-packet · recipe · daily-log"]
    T["tools/<br>lint-notion-content · check-structure<br>transcribe · claude-review"]

    CL -- "@AGENTS.md import" --> AG
    CX -- "자동으로 읽음" --> AG
    CL -- "스킬 인덱스" --> SK
    CX -. "skills·rules·memory 심볼릭 링크" .-> SK
    AG -- "세부 규칙 링크" --> R
    AG -- "메모리 표" --> M
    AG --> PL --> TP
    SK -- "따르는 규칙" --> R
    SK -- "ID·recipe 조회" --> M
    SK -- "실행" --> T
    R -- "course-ai-docs → workspace-map<br>content-style → style-profile · meme-dictionary" --> M
```

| 파일 | 역할 |
| --- | --- |
| `AGENTS.md` | 절대 규칙, 작업 계약, 파이프라인, 교차검토, 완료 보고 형식. 공용 규칙은 여기만 고칩니다. |
| `CLAUDE.md` | Claude Code 진입점. 스킬 인덱스와 세션 시작 순서 |
| `.claude/rules/` | 주제별 세부 규칙 7개 |
| `.claude/memory/` | 다시 쓸 사실만 압축. 대화 전문이나 Notion 본문은 넣지 않음 |
| `.claude/skills/` | 상황별 절차. 폴더마다 `SKILL.md` |
| `templates/` | 계획, 검토 패킷, recipe, 일지, AI 활용 문서, 강의 다운로드 스킬 양식 |
| `tools/` | 린터, 구조 검사, 오디오 변환, 전사, Claude 검토 스크립트 |

## 2. 스킬끼리 이어지는 방식

강의 영상 다운로드 스킬은 학교마다 달라서 저장소에 없습니다. [templates/lecture-download-skill.md](../templates/lecture-download-skill.md)로
내 학교용을 만들면 점선 상자 자리에 들어갑니다. Notion에 쓰는 스킬은 10건 이상 수정, 여러 DB, 본문 교체처럼
**큰 변경일 때만** `cross-review`를 거칩니다.

```mermaid
flowchart TD
    LMS["내 학교 LMS 스킬<br>영상 → MP3 → TXT<br>(SETUP.md로 직접 만듦)"]
    ING["ingest-learning-materials<br>PDF·TXT 판독, 캡처 후보"]
    PUB["publish-learning-notes<br>과목 형식대로 게시"]
    BTB["build-textbook-problem-bank<br>교재 문제 전수"]
    CRV["cross-review<br>Codex ↔ Claude 검토"]
    MAP["map-notion-workspace<br>읽기 전용 매핑"]
    CAP["capture-to-notion"]
    RUN["run-notion-automation"]
    AUD["audit-notion<br>읽기 전용 점검"]
    ADP["adapt-to-my-setup<br>처음 한 번"]

    ADP -. "Notion 연결" .-> MAP
    LMS -. "TXT 확인 뒤" .-> ING
    ING -- "출처표·캡처 후보" --> PUB
    ING -- "강의 범위 확정" --> BTB
    PUB -. "같은 주차 문제" .-> BTB
    CAP -. "대상이 불명확하면" .-> MAP
    AUD -. "고칠 일은 넘김" .-> RUN
    PUB -. "큰 변경" .-> CRV
    BTB -. "큰 변경" .-> CRV
    CAP -. "큰 변경" .-> CRV
    RUN -. "처음 실행·대량" .-> CRV

    classDef todo fill:#fff,stroke:#999,stroke-dasharray:4 3,color:#555
    class LMS todo
```

| 스킬 | 언제 | 다음 단계 |
| --- | --- | --- |
| `adapt-to-my-setup` | 처음 받았을 때 | `map-notion-workspace` |
| 내 학교 LMS 스킬 | 강의 영상을 받아 TXT까지 | `ingest-learning-materials` |
| `ingest-learning-materials` | PDF·필기·TXT가 들어왔을 때 | `publish-learning-notes`, `build-textbook-problem-bank` |
| `publish-learning-notes` | 주차 노트를 Notion에 쓸 때 | 같은 주차 문제은행 |
| `build-textbook-problem-bank` | 강의 범위 교재 문제를 넣을 때 | 큰 변경이면 `cross-review` |
| `capture-to-notion` | 대화·결정을 한 페이지로 남길 때 | 대상이 불명확하면 `map-notion-workspace` |
| `run-notion-automation` | 확정된 반복 작업 | 처음 실행·대량이면 `cross-review` |
| `audit-notion` | 중복·누락 점검(읽기 전용) | 고칠 일은 `run-notion-automation` 등으로 |
| `answer-study-questions` | 문제 풀이만 | Notion에 쓰지 않음 |

## 3. Notion 쪽 배치

`학업 / 학년 / 학기 / 과목` 트리 아래에 과목마다 `AI 활용 문서`를 둡니다. 모든 과목 문서가 공통 말투 블록(synced block)을
공유하고, 과목별 문서가 그 과목의 페이지·DB 작성법을 정합니다. 아래는 한 과목을 펼친 예입니다. 어떤 페이지·DB를 둘지는
과목마다 다르며, 그 과목의 `AI 활용 문서`에 적습니다.

```mermaid
flowchart TD
    ROOT["📚 학업"] --> Y["학년"] --> S["학기"]
    S --> C["과목 (예: 알고리즘)"]
    S --> C2["다른 과목들"]
    TONE[["🗣️ 공통 말투<br>synced block"]]
    TONE -. "같은 블록을 공유" .-> AI
    TONE -. "같은 블록을 공유" .-> C2

    subgraph course["과목 페이지 내부"]
        AI["🧠 AI 활용 문서<br>구조·자료 우선순위·말투 기준"]
        W["🗓️ 수업<br>Week 1 … Week N"]
        QA["📝 Q&A · 퀴즈 · 과제"]
        TOOLS["학습 도구<br>시험대비 정리 · 예상 문제 · 치트시트"]
        DB1[("문제은행 DB")]
        DB2[("개념·오개념 DB")]
        DB3[("오답노트 DB")]
    end

    C --> AI
    C --> W & QA & TOOLS
    C --> DB1 & DB2 & DB3
    W -. "페이지 아래 주차 필터 보기" .-> DB1
    DB3 -. "관련 개념 상호 링크" .- DB2
    AI -. "작성 기준" .-> W
    AI -. "작성 기준" .-> DB1
```

| Notion 문서 | 무엇을 담나 | 저장소에서 연결되는 곳 |
| --- | --- | --- |
| `AI 활용 문서` | 자료 우선순위, 페이지 구성, 캡처·문제은행 규칙, 말투 | `course-ai-docs.md`가 선독 절차를, `workspace-map.md`가 페이지 ID를 가짐. 양식은 `templates/ai-usage-doc.md` |
| 공통 말투 블록 | 모든 과목 노트의 한국어 말투 | `style-profile.md`가 요약 사본. 예시는 `examples/ai-usage-docs/` |
| Week N | 강의자료 순서대로 정리한 주차 노트와 캡처 | `publish-learning-notes`, `materials/index.md`의 캡처 출처 |
| 문제은행 DB | 교재 연습문제 원문·풀이 | `build-textbook-problem-bank`, 매칭 키 `data source ID + 정규화한 문제 번호` |
| 개념·오개념 / 오답노트 DB | 개념별 보완, 틀린 문항 | 과목 `AI 활용 문서`가 생성 기준을 정함 |

## 4. 큰 변경의 교차검토

```mermaid
sequenceDiagram
    participant U as 사용자
    participant W as 작업자 (Claude)
    participant R as 검토자 (Codex, 읽기 전용)
    participant N as Notion

    U->>W: 요청
    W->>N: AI 활용 문서·대상 페이지·스키마 fetch
    W->>W: plans/에 계획, 매칭 키, 예상 건수
    W->>R: review packet
    R-->>W: PASS 또는 BLOCK + 근거
    alt BLOCK
        W->>W: 근거 확인 후 수정
        W->>R: 다시 검토 (같은 문제가 두 번이면 사용자 판단)
    end
    W->>U: 예상 건수와 샘플 3건
    U->>W: 승인
    W->>N: 작은 배치로 쓰기
    W->>N: 다시 fetch해 대조
    W->>U: created / updated / skipped / failed / ambiguous
```

Codex가 작업자일 때는 반대로 Claude가 읽기 전용으로 검토합니다. 검토자는 Notion과 MCP 도구를 모두 끈 상태에서 패킷만 읽습니다.
명령은 [cross-review.md](../.claude/rules/cross-review.md)에 있습니다.
