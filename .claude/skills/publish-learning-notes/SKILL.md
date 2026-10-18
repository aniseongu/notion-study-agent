---
name: publish-learning-notes
description: Publish lecture PDFs or TXT notes into the user's existing Notion course structure by following the live course AI usage guide, matching established Korean tone, preserving source boundaries, inserting verified PDF captures, and reading back the result.
---

# Publish Learning Notes

Use this after or together with `ingest-learning-materials`. This is the main workflow for requests such as
“이 PDF/TXT를 하던 대로 노션에 정리해줘.”

## Workflow

1. Read `AGENTS.md`, [learning-materials.md](../../rules/learning-materials.md),
   [style-profile.md](../../memory/style-profile.md), and `materials/index.md`.
2. **Before any other step that touches the course**, fetch the exact course's `AI 활용 문서` page from Notion
   and read all of it (see [course-ai-docs.md](../../rules/course-ai-docs.md)), then at least one representative existing page of the
   same kind. Never rely on the local style summary, a skill's copy, or a past session; record the fetch time,
   the doc's last-edited time, and the sections that apply in the plan or result. If the fetch fails, stop.
3. Fix the week from the school LMS first: read the course's weekly modules with `tools/<lms>-modules.js` (created from SETUP.md)
   (see `learning-materials.md` 주차 확정), map deck/slide ranges to weeks, and compare with the Notion course
   pages before choosing a destination. Then search the target course tree for the intended Week, work, concept, assignment, or database item. Fetch
   the canonical destination and live schema before deciding to create or update. The default content key is
   `course parent ID + content kind + canonical label`. Content kind is one of `lecture-week`, `qa`,
   `work`, `concept`, `assignment`, or `problem`. Normalize weeks to `Week N`; for named works and concepts,
   Unicode-normalize, trim, and collapse whitespace without translating or changing the title. Zero matches
   may create, one match updates, and multiple matches stop as ambiguous.
4. A lecture-recording transcript (`수업 녹음(자동 전사)`) is a near-verbatim record, not a source structure.
   Always pair it with the same week's lecture material (PDF/slides): the material gives the outline, terms,
   and order; the transcript adds the professor's explanations, examples, and emphasis beside the matching
   slide. If the material is missing, stop and ask the user for it instead of publishing from the transcript.
   Confirm all source pages were ingested. Keep lecture, personal notes, textbook reinforcement, peer
   summaries, preparation, and external research visibly distinct according to the course guide.
5. To save Claude tokens, write a source packet (format, style rules, per-slide notes Claude verified from the
   page images, capture list, placeholders) and let Codex draft long pages, in parallel when independent; Claude
   then checks the draft against the sources before writing. See the Codex delegation section in
   [tool-routing.md](../../rules/tool-routing.md). Short pages whose sources Claude already read may be written
   directly. Draft in the established style: concise Korean student notes, specific headings, complete reasoning,
   varied endings, no canned AI preamble. Preserve English originals, questions, choices, code, formulas,
   quotes, and submission text.
5a. When current exam information or past exam types are provided, apply
   [learning-materials.md](../../rules/learning-materials.md) 「시험정보를 공부법에 반영하기」 to **new** notes: connect each
   confirmed type to a concrete practice action, label past student reviews as historical, and keep previously
   published Week/Q&A/exam answer bodies intact unless the user asks to revise them. For a requested separate
   `시험대비 정리` page, use the course's `학습 도구` section and match by
   `(course parent ID, 학습 도구, 시험대비 정리)` before creating.
   Respect any `유형만 확인` limit without solving those questions.
6. Follow the professor's sequence and notation. Integrate valid handwriting beside its concept; show a
   correction as original value → corrected value → reason. Do not replace the course method with a
   shorter general method.
6a. Coverage: the last handwritten body slide marks the lecture's progress (later body slides belong to the next
   week). Supplementary Review/Ex/Exercise slides at the end of a deck are always covered, even with no
   handwriting. Put each one in the Week whose topic it practices
   ([learning-materials.md](../../rules/learning-materials.md) 「강의 진도와 Supplementary」).
6b. Before writing, run `tools/lint-notion-content.py` on every body file (no `&gt;`-style entities, no fragile LaTeX such as `\operatorname`/`\mathbin`/`\widehat`/`cases`; bit-ops and assembly stay in code spans). Rules: [content-style.md](../../rules/content-style.md) "Notion 본문 표기".
7. Upload only verified captures and place each directly under the relevant explanation without an image caption.
   For local files, use [tool-routing.md](../../rules/tool-routing.md) 「로컬 파일 업로드」 after checking CLI authentication;
   retain the connected Notion plugin/MCP for page attachment and read-back.
   Record the source and observation in the local provenance index. Before upload, match `target page ID + source_id + PDF page/slide + crop slug`
   against the image file names and the local upload table (no captions or source toggles are written on the page); reuse or skip an exact match and stop on conflicting
   matches. Native text is preferred for text-only slides.
8. For every lecture week, prepare the textbook problem list with
   [build-textbook-problem-bank](../build-textbook-problem-bank/SKILL.md) for the same covered range and put it in
   the same plan as the page changes.
9. For a material rewrite, multiple pages, 10+ records, or a first problem-bank run, create a plan and run
   the opposite-tool preflight review. Otherwise make the smallest scoped write.
10. When step 9 required a review, write only after it passes. Write the page and then the problem bank (once) through the official Notion
    plugin/MCP, then fetch the result. Check placement, section order,
   omissions, equations/code, source labels, images/captions, links, properties, and duplicate keys.
11. Report the Notion links, created/updated/skipped/failed/ambiguous counts, source coverage, capture count,
    live guide used, and cross-review verdict.

If the live guide conflicts with the user's current explicit instruction, follow the user and state the
deviation. If the target or source authority remains ambiguous, stop before writing.
