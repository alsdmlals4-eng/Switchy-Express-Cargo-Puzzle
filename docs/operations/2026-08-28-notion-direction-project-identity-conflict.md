# Notion Direction Project-Identity Conflict

Status: `OPEN · NO_FOREIGN_CONTENT_MUTATION · 2026-08-28 KST`

Tracking: GitHub Issue #230

## Incident

The Switchy Express Notion Home page has a child page titled `01 · Direction · Planning` at ID `3c51b237-eb1c-81b7-ab76-da277d03577d`. Fresh readback showed that page contains the unrelated `괴이 기록국` project North Star, loop, visual lock, and release slice.

This is a `CONFLICT`, not historical Switchy material. The title and parent relationship alone are insufficient evidence of project ownership.

## Containment

- Did not overwrite, move, delete, archive, or relink the foreign Direction page or its child content.
- Updated only the confirmed Switchy Home and Visual pages with the merged `SX-DEC-061` state, then performed exact destination readback.
- Repository owners remain the current Switchy Direction source until a user explicitly authorizes a Notion rehome or replacement.

## Required User Decision

Choose exactly one safe disposition for the foreign Direction page:

1. Rehome it to its owning project, then create a new Switchy Direction page under the current Home.
2. Confirm it is an obsolete accidental page and authorize replacement after its child content has been inventoried and preserved.
3. Keep it untouched and use the repository/Visual owner only for the current Switchy Direction.

## Lesson

Notion parentage, title, and a familiar page ID do not establish project identity. Before a page becomes a current project source or write destination, validate that its core promise, current Decision, runtime context, and owner agree with the repository.

## Base Promotion Assessment

`NO_BASE_PROMOTION` — Base already requires fresh project-identity recovery and destination readback. The incorrect page relationship and project names are local workspace data.

## Evidence Boundary

This record is a documentation-integrity finding. It does not change gameplay, assets, runtime, test evidence, human evidence, or release readiness.
