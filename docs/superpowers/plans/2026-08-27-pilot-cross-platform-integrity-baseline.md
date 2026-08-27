# Pilot Cross-Platform Integrity Baseline Plan

**Issue:** #203

**Goal:** Restore the Switchy Godot live-editor Pilot contract on both Windows and Linux without weakening materialized-copy byte integrity.

**Root cause:** `BASE_SOURCE.json` pins LF source bytes while Windows `core.autocrlf=true` materializes tracked text with CRLF. The Pilot compares working-copy raw hashes to LF provenance hashes, so it rejects an otherwise clean checkout before its intended integrity tests run. The target-scene source baseline is also stale after a committed presentation change.

**Constraints:** No gameplay rule, scene behavior, asset, map, or PR #174 change. This is tooling-only and cannot alter SX-DEC-060 acceptance-candidate validity.

## Task 1 — RED cross-platform baseline test

- [ ] Add a focused test that proves canonical source comparison treats CRLF and LF representations of the same tracked text identically, while raw copy integrity remains byte-exact.
- [ ] Run the new test and confirm it fails under the existing raw-hash implementation.

## Task 2 — Separate canonical source hashing from byte-copy hashing

- [ ] Add a canonical text-source hash used only by Base/source baseline validation.
- [ ] Retain raw `sha256_file` for materialized-copy and protected-inventory integrity checks.
- [ ] Refresh only the committed target-scene baseline identity/hash.
- [ ] Run the full Pilot contract suite locally.

## Task 3 — CI and review

- [ ] Verify focused Python tests, full Pilot contract, project-contract validation, whitespace, and JSON parsing.
- [ ] Review source-vs-copy integrity boundaries and confirm no production files changed.
- [ ] Commit, open a PR linked to #203, require exact-head green CI, merge only when clean.

