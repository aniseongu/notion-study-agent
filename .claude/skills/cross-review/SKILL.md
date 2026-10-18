---
name: cross-review
description: Have Codex (gpt-6-sol by default; model chosen per tool-routing.md) review Claude's material Notion plan or result, or Claude Opus 5.5 review Codex's, using a read-only packet and a PASS/BLOCK contract before risky execution or after a high-risk run.
---

# Cross Review

Read [cross-review.md](../../rules/cross-review.md) and use
[templates/review-packet.md](../../../templates/review-packet.md).

## Workflow

1. Identify the executor. Choose the opposite reviewer: Claude → Codex (`gpt-6-sol` default, pick per tool-routing.md and report the model); Codex → Claude `claude-opus-5-5`.
2. Build a minimal review packet with the user intent, exact targets, live schema evidence, counts, sample
   changes, invariants, idempotency key, conflict handling, verification, and recovery. For course work,
   include the `AI 활용 문서` fetch/last-edited times ([course-ai-docs.md](../../rules/course-ai-docs.md)) and a summary of the sections that apply.
3. Invoke the read-only command defined in the rule document. Give the reviewer the exact packet path and
   ask for the fixed `PASS/BLOCK` output contract.
4. Check that the reviewer changed no files. Evaluate findings against live evidence rather than accepting
   them automatically.
5. Resolve blockers and retry at most once. Escalate persistent or contradictory blockers to the user.
6. Record only durable lessons in `decisions.md` or `error-log.md`; do not paste the full review transcript.

If the opposite CLI is unavailable, perform an explicit second-pass self-review and disclose that no
cross-tool review occurred.
