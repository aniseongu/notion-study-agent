# Notion CLI(`ntn`) 활용

기본 경로는 Notion MCP입니다. 페이지 탐색, 본문 읽기, 대화하며 고치는 쓰기는 MCP가 편합니다.
공식 CLI `ntn`은 **스크립트로 반복하는 일**에 보조로 씁니다. 명령과 옵션은 [공식 문서](https://developers.notion.com/cli)에서 확인하세요.

> 이 저장소의 기본 규칙([tool-routing.md](../.claude/rules/tool-routing.md) 「로컬 파일 업로드」)은 `ntn`을 **캡처·PDF 업로드에만** 씁니다. 아래 표의 업서트·CI 점검까지 쓰려면 그 절에 허용 범위와 인증 방식을 먼저 적어 넓히세요([CUSTOMIZE.md](CUSTOMIZE.md) 표 마지막 줄).

## 어디에 쓰나

| 쓰임 | 이유 | 문서 |
|---|---|---|
| 강의 캡처·PDF 일괄 업로드 | 파일을 올리고 업로드 ID만 받아 본문 `file-upload://<ID>` 자리에 넣음. 임시 URL을 직접 다룰 필요 없음 | [File uploads](https://developers.notion.com/cli/guides/file-uploads) |
| 매칭 키로 조회한 뒤 생성·수정 | `ntn datasources query --filter`로 키를 찾고 0개 → 생성, 1개 → 수정, 2개 이상 → 중단 | [Data sources](https://developers.notion.com/cli/guides/data-sources) |
| 정기 점검(CI) | 읽기 전용 쿼리로 중복·누락을 세고 결과만 남김 | [Authentication](https://developers.notion.com/cli/get-started/authentication) |
| MCP에 없는 API | `ntn api <경로>`로 공개 API를 그대로 호출 | [API requests](https://developers.notion.com/cli/guides/api-requests) |

## 시작

```bash
ntn login      # 브라우저에서 승인. 토큰은 OS 키체인에 저장됨
ntn doctor     # 작업공간과 API 접근 확인
```

CI에서는 `NOTION_API_TOKEN` 환경변수로 인증합니다. 토큰을 저장소 파일·로그·계획 문서에 적지 않습니다.
`NOTION_KEYRING=0`(토큰을 평문 파일로 저장)은 이 저장소 규칙과 맞지 않으니 쓰지 마세요.

## 캡처 업로드 예

```bash
ID=$(ntn files create --plain --filename algo-lec01-p012-heap.png \
      < materials/courses/algo/captures/algo-lec01-p012-heap.png | cut -f1)
ntn files get "$ID"     # uploaded 상태 확인
```

- 업로드한 파일은 **1시간 안에** 페이지에 붙여야 합니다. 붙이는 쓰기는 MCP나 `ntn api`로 하고, 붙인 뒤 페이지를 다시 읽어 이미지 블록을 확인합니다.
- 업로드만 끝난 것은 게시 완료가 아닙니다.
- 같은 파일을 다시 올리기 전에 로컬 업로드 표(`materials/courses/<slug>/uploads.json`)에서 파일명과 대상 페이지를 먼저 확인합니다.

## 규칙과의 관계

`ntn`으로 하는 쓰기도 [AGENTS.md](../AGENTS.md)의 같은 규칙을 따릅니다. 쓰기 직전 재조회, 매칭 키, 큰 변경의 교차검토, 쓰기 후 재조회는 CLI라고 생략하지 않습니다.
자세한 업로드 절차는 [tool-routing.md](../.claude/rules/tool-routing.md)의 「로컬 파일 업로드」에 있습니다.
