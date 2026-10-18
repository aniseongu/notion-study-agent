# 도구·MCP·플러그인 라우팅

상위 규칙: [AGENTS.md 6절](../../AGENTS.md).

## 라우팅 원칙

1. Notion 데이터가 필요하면 웹 검색이나 브라우저 자동화보다 공식 Notion 플러그인/MCP를 쓴다.
2. PDF/TXT 강의자료는 `ingest-learning-materials`, 학습 노트 게시에는
   `publish-learning-notes`를 쓴다.
3. 공식 PDF MCP는 로컬 PDF 페이지 검색·이동·스크린샷에, MarkItDown은 검색용 초벌 텍스트에
   쓴다. PDF 표·도식·수식·손필기·색 강조·배치는 원본 페이지 직접 확인이 기준이다.
4. 단순 캡처에는 `capture-to-notion`, 확정 recipe 실행에는 `run-notion-automation`, 상태 점검에는
   `audit-notion`을 쓴다.
5. 목적지가 불명확하거나 스키마가 바뀌었으면 다른 작업보다 `map-notion-workspace`를 먼저 쓴다.
6. Notion 공식/설치 스킬이 더 전문적인 흐름을 제공하면 함께 활용할 수 있다. 단, 대상과
   멱등성 규칙은 이 저장소가 우선이다.
7. Google Drive에만 있는 강의자료는 설치된 Drive 플러그인으로 가져오되, 출처를 index에 남기고
   Notion 게시 전 로컬 원본의 페이지를 검수한다.
8. OpenAI/Codex/plugin 관련 질문은 공식 OpenAI Docs 또는 OpenAI Docs MCP로 확인한다.
9. 새 외부 앱이 꼭 필요할 때만 플러그인을 검색·제안한다. 설치·권한 변경은 사용자가 요청한
   범위에서만 한다.

## Notion 조회의 응답량 줄이기

- 단건 탐색은 `find`처럼 **제목 검색으로 후보를 좁힌 뒤** ID·상위 위치·유형만 짧게 확인한다.
  처음부터 후보들의 본문을 전부 가져오지 않는다. 후보가 많으면 고유 명사나 상위 범위를 더해
  재검색하고, 여전히 둘 이상 적합하면 `AGENTS.md` 1.1에 따라 확인한다.
- 대상이 확정되면 그 페이지 본문과 필요한 데이터 소스 스키마를 가져온다. 쓰기 직전 재조회와
  과목별 `AI 활용 문서` 전문 live fetch는 응답량을 아끼려고 생략하거나 축약하지 않는다.
- DB의 단건 탐색은 고유 매칭 키로 필터링하고, 보고에는 필요한 속성·ID·링크만 남긴다.
  감사·대량 작업처럼 전체 건수가 필요한 경우에는 작은 결과 수 제한으로 완료를 추정하지 말고
  끝까지 페이지네이션한 뒤 로컬에서 집계한다.
- 도구가 과한 JSON을 반환하면 작업에 필요한 필드와 오류·페이지네이션 상태만 추려 다음 단계에
  전달한다. 원문 본문·자격 증명·개인 정보는 토큰 절약용 로그나 메모리에 복제하지 않는다.

## 로컬 파일 업로드

- 2026-10-15 연결한 공식 Notion CLI `ntn`은 **로컬 캡처·PDF 업로드에만 보조로 쓴다.**
  페이지 탐색·본문·DB 쓰기는 기존 공식 Notion 플러그인/MCP가 기본 경로다.
- 업로드 직전 `ntn doctor`로 같은 작업공간의 인증·Public API 접근을 확인한다. 로컬 파일은
  `ntn files create --plain --filename <파일명> < <로컬파일>`로 올리고, 반환 ID를
  `ntn files get <ID>`로 조회해 `uploaded`를 확인한다. 출력에는 ID만 보관하고 인증값은 남기지 않는다.
  현재 샌드박스에서는 OS 자격 증명 저장소가 보이지 않으므로 인증 검사는 승인된 샌드박스 밖
  실행의 `ntn doctor` 7/7을 기준으로 한다. 인증값을 환경변수·저장소 파일로 복사하지 않는다.
- 업로드 ID는 기존 `file-upload://<ID>` 자리표시자에 쓰고, 만료 전 페이지에 첨부한다.
  첨부 뒤에는 페이지 재조회로 이미지·파일 블록을 확인한다. 업로드만 완료된 것을 게시 완료로 세지 않는다.
- CLI 인증 실패·작업공간 불일치 시 기존 MCP 업로드 경로를 쓴다. 같은 파일을 두 경로로
  무작정 재업로드하지 않고, 먼저 파일명·해시·대상 페이지 키와 이전 업로드 기록을 확인한다.

## Codex 위임으로 Claude 토큰 아끼기 (2026-10-04 사용자 지시)

강의 정리·문제은행처럼 초안 분량이 큰 작업은 Claude가 전부 쓰지 않는다. Claude는 **원본을 직접 보고
판단하는 일**과 **검수·게시**를 맡고, 긴 글 작성은 Codex에 넘긴다.

| 단계 | 담당 | 이유 |
|---|---|---|
| 원본 PDF 이미지 확인, 손필기 판독, 주차·범위 확정 | Claude | 시각 확인과 판독은 위임하면 근거가 사라짐 |
| 필기·슬라이드 메모를 담은 **입력 패킷** 작성 | Claude | 패킷이 곧 Codex의 유일한 근거 |
| 강의 페이지·문제 해설 등 긴 본문 초안 | Codex | 출력 토큰이 가장 많이 드는 부분 |
| 초안 검수(원본과 대조, 계산 재검산, 말투) → Notion 쓰기 → 재조회 | Claude | 게시 책임과 Notion 도구는 작업자에게 |
| 사전·사후 교차검토 | Codex | [cross-review.md](cross-review.md) |

- **패킷:** `materials/courses/<slug>/extracted/<주제>-packet.md`에 형식(기존 페이지 순서), 말투 규칙 요약,
  슬라이드별로 Claude가 이미지에서 확인한 필기·검산 메모, 캡처 파일명·캡션, 자리표시자(`{{IMG:파일}}`,
  `{{MENTION:페이지}}`)를 적는다. Codex에 PDF 판독을 맡기지 않는다.
- **호출:** 독립 초안은 병렬로 백그라운드 실행하고, 결과는 `-o`로 파일에 받는다.

```bash
codex exec --ignore-user-config --disable apps --disable plugins --model gpt-6-sol -c model_reasoning_effort=\"medium\" \
  --sandbox read-only --ephemeral --cd "$PWD" -o <초안.md> "<패킷 경로와 작성 지시>" < /dev/null
```

  `< /dev/null`이 없으면 stdin 대기로 멈춘다. 읽기 전용 샌드박스라 Codex는 파일·Notion을 바꾸지 못하고
  최종 답변만 `-o` 파일로 남긴다.
- **검수:** Codex 초안은 Claude가 원본 슬라이드·필기 메모와 대조해 고친 뒤에만 게시한다. 사실·계산
  오류가 있으면 Claude가 직접 고친다(같은 초안을 Codex에 다시 돌리는 왕복은 한 번까지).
- **검토·대조용 PDF는 텍스트로 준다**(2026-10-08 사용자 지시). 값·코드·슬라이드 문구 확인은 Claude가 미리 만든 쪽별
  텍스트 파일(`pdftotext -layout`을 `\f`로 나눠 쪽마다 `## <덱> pN` 머리글)로 하고, Codex 검토자에게는 그 파일을 grep하고
  이미지를 렌더링하지 말라고 적는다. 손필기·도식·배치 같은 시각 사실은 패킷에 "Claude 확인"으로 넣는다. docx·pptx·xlsx는
  `markitdown <파일> -o <out.md>` CLI가 낫다(PDF는 쪽 구분이 사라짐).
- 대화 중 필기를 이미 본 짧은 작업(Q&A 한 페이지 등)은 패킷을 만드는 비용이 더 크므로 Claude가 직접 쓴다.
- 서브에이전트(Claude)는 이미지 판독이 꼭 필요한 병렬 작업에만 쓰고, 순수 글쓰기에는 Codex를 우선한다.

## Codex 모델 선택 (2026-10-05 사용자 지시: 작업에 맞게 알아서 고른다)

모델은 고정값이 아니다. 작업 성격에 맞춰 Claude/Codex가 고르고, 쓴 모델을 결과 보고에 적는다.
이전 세대 모델도 쓸 만하다는 사용자 판단(2026-10-05)이 있으므로 비용이 낮고 품질이 충분하면 허용한다.

| 작업 | 기본 모델 | effort | 비고 |
|---|---|---|---|
| 강의 페이지·문제 해설 같은 긴 본문 초안 | `gpt-6-sol` | medium | 사용자가 `gpt-6.1-sol`은 느려 잘 안 쓴다고 함(2026-10-05). 이전 세대 workhorse로 충분 |
| 중요한 Notion 변경 교차검토(`cross-review`) | `gpt-6-sol` | high | 판단이 어려우면 `gpt-6.1-sol` high, 수학·증명 검산이 핵심이면 `gpt-6-astra` |
| 파일 triage, 누락 탐지, 형식·링크 점검, 대량 분류, 읽기 전용 Notion 조회 | `gpt-6-luna` | low~medium | 빠르고 저렴, 판단이 얕은 일에만 |
| 짧은 초안·말투 보강·재검산, 한도 절약 | `gpt-5.6-sol`, `gpt-5.6-terra` | medium | 더 이전 세대. 충분하면 허용 |
| 품질이 모자랄 때의 상향 | `gpt-6.1-sol` (느림), `gpt-6-astra` (가장 비쌈) | high | 예외로만. 느리면 작업을 쪼개 병렬로 돌린다 |

- **고르는 방법:** `~/.codex/models_cache.json`(또는 `codex debug models`)의 현재 목록을 보고, 처음 쓰는 모델은
  `codex exec ... "OK만 답하라"` 프로브를 한 번 한다. 2026-10-05 전역 CLI 0.159.0에서 `gpt-6.1-sol`,
  `gpt-6-astra`, `gpt-6-luna` 프로브가 모두 성공했다.
- **실패하면:** 모델이 거부되면(계정 자격·카탈로그 오류, GitHub `openai/codex` 이슈 #49396·#49703 유형) 위 표의
  다음 후보로 한 단계씩 내려가고 오류와 최종 모델을 보고한다. 읽기 전용·`--ephemeral` 인자는 모델이 바뀌어도 유지한다.
- **근거와 재확인:** OpenAI의 [GPT-6.1 Sol 발표](https://openai.com/index/introducing-gpt-6-1-sol/),
  [9to5Mac 요약](https://9to5mac.com/2026/09/22/openai-upgrading-chatgpt-and-codex-with-two-more-gpt-6-models/),
  [DataCamp 비교](https://www.datacamp.com/blog/gpt-6-1-sol), GitHub `openai/codex` 이슈를 2026-10-05에 확인했다.
  DataCamp의 가격($/1M 토큰 입력/출력: 6.1 Sol 2/10, Astra 10/50, Luna 0.10/0.50)은 2차 출처다.
  모델 라인업은 몇 주 단위로 바뀌므로 30일이 지나면 웹 검색과 `models_cache.json`으로 다시 확인한다.
- 사용자가 모델을 지정하면 그 지시가 우선한다.

## Codex에서 Notion 작업 (플러그인·MCP)

Codex도 Notion을 직접 읽고 쓸 수 있다. 2026-10-05 `codex plugin list`로 `notion@openai-curated-remote` 0.1.8이
installed·enabled임을 확인했고, `codex exec`(플러그인 활성)가 `codex_apps/notion.search`·`notion.fetch`로
과목 `AI 활용 문서`를 찾아 URL을 돌려주는 읽기 전용 프로브를 통과했다.

- **작업자 경로(Codex가 Notion을 읽거나 씀):** `--disable apps --disable plugins`를 **쓰지 않는다**. 사용자 설정과
  Notion 플러그인이 로드돼야 한다. 쓰기는 `AGENTS.md`의 대상 확정·재조회·멱등성·교차검토 규칙을 그대로 따른다.
  플러그인 권한이 넓어도 승인된 범위만 쓴다.
- **검토자 경로(Codex가 Claude 작업을 검토):** 반대로 `--ignore-user-config --disable apps --disable plugins
  --sandbox read-only`로 Notion·MCP를 모두 끈다. 검토자는 packet만 읽는다.
- **초안 위임(위 절):** Notion 도구가 필요 없으므로 검토자 경로와 같은 인자를 쓴다.
- Codex CLI에 Notion MCP를 직접 붙이는 `codex mcp add notion --url https://mcp.notion.com/mcp`는 플러그인이 동작하지
  않을 때만 사용자 요청 범위에서 쓴다. 두 경로를 한 세션에 중복으로 켜지 않는다.
- 플러그인 도구 이름과 연결 상태는 세션마다 다시 확인한다.

## 연결 실패

- 도구 이름이 안 보이면 현재 세션에 로드되지 않은 것이다. 과거 설치 기록만으로 호출을
  시도하지 않는다.
- 인증 실패, 권한 부족, 대상 미공유를 서로 구분한다.
- 연결을 새로 만들었다면 재시작이 필요한지 확인하고, 필요한 경우 그 시점에서 작업을 멈춰
  사용자에게 알린다.

구체적인 현재 상태와 명령은 [docs/INTEGRATIONS.md](../../docs/INTEGRATIONS.md)에 있다.
