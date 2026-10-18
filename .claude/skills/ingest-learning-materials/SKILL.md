---
name: ingest-learning-materials
description: Ingest user-provided lecture PDFs, annotated PDFs, slides, or TXT notes for a course; extract searchable text, inspect original pages visually, select evidence-based captures, and update the local provenance index before Notion authoring.
---

# Ingest Learning Materials

Use this before writing a lecture or study page from PDFs/TXT. Read
[learning-materials.md](../../rules/learning-materials.md) and
[style-profile.md](../../memory/style-profile.md).

## Workflow

1. Identify the course, requested scope, source files, and whether each file is a professor handout,
   annotated copy, personal TXT note, textbook, peer summary, or external supplement. Do not infer a file's
   authority only from its name.
2. Fetch the course's `AI 활용 문서` page from Notion (ID in `workspace-map.md`) and read all of it, following
   [course-ai-docs.md](../../rules/course-ai-docs.md). Its course-specific source order, page structure, and boundaries override
   generic defaults. Record the fetch time and last-edited time in `materials/index.md` notes or the plan.
3. Register every input in `materials/index.md` with a stable source ID, local path, type, page count when
   relevant, and role. Use a checksum when duplicate filenames are plausible.
4. For TXT, read the original directly. For PDF/Office files, use MarkItDown when connected to make a
   searchable draft under `extracted/`; if unavailable, use a local extractor and record the fallback.
   Treat extracted Markdown as navigation data, never visual ground truth.
5. Use the official PDF MCP or local rendering (`pdfinfo` + `pdftoppm`, then an image viewer) to inspect original pages visually. For annotated/image-heavy
   PDFs, inspect in groups of at most three pages and confirm each requested page was actually visible.
   Compare original and annotated copies when both exist.
6. Record page/slide ranges, missing or unreadable content, source conflicts, calculations needing
   recheck, and capture candidates. Recalculate numerical examples and code output where feasible.
7. Create only useful captures under `captures/`, named `<source-id>-pNNN-<slug>.png`. Update the index with
   PDF page, slide number, purpose, and whether handwriting is included.
8. Produce a source-grounded outline separating lecture content, personal notes, textbook reinforcement,
   peer material, and external additions. Hand it to `publish-learning-notes` for Notion writing.

Do not upload or write to Notion in this skill unless the user explicitly asks to combine ingestion and
publishing; then continue with `publish-learning-notes` rather than improvising a second workflow.
