---
name: audit-notion
description: Read-only audit of Notion pages or data sources for duplicates, missing required values, stale mappings, broken relations, or recipe drift. It reports findings but does not fix them.
---

# Audit Notion

## Workflow

1. Define the audit target and checks. Use a mapped URL/ID or resolve it with `map-notion-workspace`.
1b. For a course target, fetch that course's `AI 활용 문서` from Notion and read all of it
   ([course-ai-docs.md](../../rules/course-ai-docs.md)). Its explicit rules (structure, numbering, captions, properties) are valid
   audit checks; cite the section for each finding.
2. Fetch the live schema and query all relevant records with pagination.
3. Evaluate only evidence-backed checks: duplicate recipe keys, missing required properties, invalid option
   values, broken or unexpected relations, stale workspace mappings, and deviations from an approved
   recipe.
4. Separate confirmed findings from items that require a user decision. Include counts and direct Notion
   links where possible.
5. Report without mutating Notion. If the user later asks for fixes, create a plan and route the change to
   `run-notion-automation` or `capture-to-notion`.

Do not treat a stylistic preference as data corruption, and do not infer required fields solely from how
most rows happen to look.
