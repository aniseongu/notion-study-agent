---
name: map-notion-workspace
description: Map exact Notion pages, data sources, schemas, and relations before automation when the destination is new, ambiguous, or changed. This is read-only in Notion.
---

# Map Notion Workspace

Create or refresh [.claude/memory/workspace-map.md](../../memory/workspace-map.md) without changing
Notion.

## Workflow

1. Read `AGENTS.md` sections 1–3 and [notion-safety.md](../../rules/notion-safety.md).
2. Start from a user-provided Notion URL/ID when available. Otherwise search by the smallest distinctive
   title phrase. Narrow a noisy result by title or parent; keep the first candidate list to IDs, titles,
   types, and parents instead of fetching every body (see [tool-routing.md](../../rules/tool-routing.md)).
3. Fetch plausible candidates and identify them by ID, parent, object type, and purpose. If two candidates remain
   plausible, ask the user instead of choosing by recency.
3b. As soon as a candidate is identified as part of a course tree (before reading any schema), find that course's `AI 활용 문서` page, fetch and read all of it first (its
   page-structure rules tell you what the course tree should contain), and register its ID in the
   workspace-map table 「학업 작성 기준 페이지」, because every course job starts by reading it
   ([course-ai-docs.md](../../rules/course-ai-docs.md)).
4. For a database, resolve its data source and read the live property schema, status/select options, and
   relation targets.
5. Follow only relations needed for the requested workflow. Do not crawl the whole workspace.
6. Update the local map with `verified_at`, the verification method, exact IDs, match-key candidates, and
   known invariants. Mark uncertainty explicitly.
7. Re-read the edited map and report what is ready for automation and what still needs confirmation.

## Boundaries

- Do not create, update, move, archive, or delete any Notion object.
- Do not store page bodies, credentials, or personal data in the map.
- A cached mapping helps discovery but never replaces the live schema check before a write.
