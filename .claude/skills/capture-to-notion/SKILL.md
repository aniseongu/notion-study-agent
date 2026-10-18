---
name: capture-to-notion
description: Turn a conversation, note, decision, learning, or how-to into a structured Notion page, updating an existing page when it is the correct canonical destination.
---

# Capture to Notion

Use this for content capture, not for broad database maintenance or bulk synchronization.

## Workflow

1. Read the relevant entry in [workspace-map.md](../../memory/workspace-map.md),
   [content-style.md](../../rules/content-style.md), and the safety rules linked from `AGENTS.md`.
1b. If the destination is inside a course tree (`학업 / … / <과목>`), fetch that course's `AI 활용 문서` from
   Notion and read all of it first ([course-ai-docs.md](../../rules/course-ai-docs.md)); its page structure and tone rules win.
2. Determine the content type, intended audience, source of truth, and whether this should update an
   existing page or create a new one.
3. Search for the canonical destination and related pages. Fetch the destination and its live schema.
4. Extract facts, decisions, rationale, actions, unresolved questions, and source links. Do not invent
   owners, dates, statuses, or tags.
5. Check the match key before creating. If an existing canonical page is found, update only the relevant
   fields or blocks and preserve the rest.
6. For a material rewrite or multiple destinations, make a plan and use the cross-review skill first.
7. Write through the connected Notion plugin/MCP, then fetch the result and compare required properties,
   body structure, relations, and links. Check whether the new page is discoverable from its confirmed
   parent or established index. Add a hub link only when that page is within the requested scope or an
   already established workflow; otherwise report the navigation gap without editing another page.
8. Report the result URL and whether it was created or updated. Add a recipe only if the workflow is meant
   to repeat.

## 내용 유형

| 유형 | 권장 구성 |
|---|---|
| 결정 | 결론 → 배경 → 검토한 대안 → 선택 이유 → 영향/후속 작업 |
| 회의/대화 정리 | 요약 → 결정 → 액션 아이템 → 미해결 질문 → 출처 |
| 사용법 | 목적 → 전제 조건 → 단계 → 검증 → 예외/문제 해결 |
| 개념/학습 | 한 줄 정의 → 핵심 설명 → 예시 → 관련 개념/출처 |
| 반복 작업 결과 | 범위 → 처리 수량 → 예외 → 검증 → 관련 recipe/plan |

If the destination is unknown, stop this workflow and use `map-notion-workspace` first.
