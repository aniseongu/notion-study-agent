---
name: run-notion-automation
description: Execute an approved repeat or batch Notion workflow from a local recipe with dry-run counts, idempotent matching, cross-review, bounded writes, and read-back verification.
---

# Run Notion Automation

This skill executes a known workflow. If no approved recipe exists, create a plan and review it; do not
silently invent a bulk automation contract.

## Workflow

1. Read the selected entry in [recipes.md](../../memory/recipes.md), its workspace mappings, and
   [notion-safety.md](../../rules/notion-safety.md).
1b. If the targets belong to a course, fetch that course's `AI 활용 문서` from Notion and read all of it
   ([course-ai-docs.md](../../rules/course-ai-docs.md)). Stop if the recipe contradicts the live doc; fix the recipe first.
2. Re-fetch target data sources and compare the live schema with the recipe. Stop on a property type,
   option, or relation-target mismatch that changes meaning.
3. Read the complete input and target sets with pagination. Normalize the recipe's match key and classify
   every item as `create`, `update`, `skip`, or `ambiguous`.
4. Write or refresh a plan containing total counts and three representative proposed changes. Do not
   execute ambiguous items.
5. Run the opposite-tool preflight review using `cross-review`. Resolve blockers before writing.
6. Execute in bounded batches. Record returned IDs and classify failures. After a timeout, re-read before
   retrying so a successful but unacknowledged write does not duplicate data.
7. Re-fetch changed objects. Verify counts, match-key uniqueness, required fields, preserved fields, and
   relations. Add the results to the review packet and request postflight review for high-risk runs.
8. Report `created / updated / skipped / failed / ambiguous`, links, and any unverified remainder.

Do not broaden the recipe's source, target, or field mapping because nearby data looks related.

## Lessons from past restructuring runs

- **Bulk property moves** (e.g. renumbering a select): add the new option first (schema change needs approval), build the target list from a live filter query with an expected count
  and `has_more:false`, move in dependency order (A→B only after A's old value reads 0 rows), update every view filter that names the old value, then verify with `GROUP BY` counts and `COUNT(DISTINCT key)`.
- **Large writes from a long chat**: hand bulk typing to subagents with a small context, one scratch folder each, and keep the match key (e.g. problem number) as the idempotency check.
  Subagents cannot save a fetch result to disk and may not spawn children, so do their counts in the prompt or reread the page yourself.
- **Oversized `fetch` results** are saved to a file by the harness. Count headings, images, mentions, and placeholders with a short Python script on that file instead of reading it.
- **Opposite-tool review**: `codex exec … < /dev/null` with a long timeout. If it BLOCKs for missing evidence only, add the evidence to the packet (counts, verification report) and re-run once; record the model used.
- **Claims must match evidence**: say "structure checked on all N pages" and "sentence-level compare on k pages" separately; screenshots are skipped unless the user asks (token cost).
