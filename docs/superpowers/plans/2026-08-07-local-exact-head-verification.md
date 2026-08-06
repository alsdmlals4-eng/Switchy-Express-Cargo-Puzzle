# Windows + WSL2 Local Exact-HEAD Verification Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans task-by-task.

**Goal:** Reproduce the Python test matrix on Windows 3.11/3.12/3.13 and WSL2 Ubuntu 3.12, then run full Godot/GUT evidence once on Windows exact HEAD.

**Architecture:** PowerShell orchestrates four Python targets and writes `python-matrix.json`. A standalone Python validator checks the matrix. A hardened compatibility entry runs the original exact-HEAD verifier with bytecode disabled and stable Git failure codes.

**Tech Stack:** Python 3.11/3.12/3.13, PowerShell, WSL2 Ubuntu Python 3.12, Git, Godot 4.7.1, GUT 9.7.1.

## Global Constraints

- Decision `SX-DEC-047`, audit `SX-AUD-028`, batch `GMB-005`.
- No gameplay, workflow, `project.godot`, Scene, Resource, or binary asset changes.
- Hosted Actions remain `NOT_RUN`; every branch commit uses `[skip actions]`.
- Four Python targets must use the same full 40-character HEAD and clean worktree.
- All Python test execution disables bytecode generation.
- GUT discovery below six or any production mutation fails the full pack.

## Tasks

- [x] Write RED tests for four targets, matrix failure, WSL path conversion, WSL HEAD/status, bytecode isolation and documentation.
- [x] Implement the matrix validator and sanitized summary.
- [x] Implement hardened compatibility entry for stable Git failure codes.
- [x] Implement Windows + WSL2 PowerShell orchestration.
- [x] Run targeted unittest and compileall in the isolated tooling workspace.
- [x] Add changes to PR #103 with `[skip actions]` commits.
- [ ] Re-read PR exact HEAD, changed files, comments, reviews and mergeability.
- [ ] Synchronize `SX-DEC-047` and `SX-AUD-028` to Google Sheet with the exact PR HEAD.
- [ ] Run the full pack on the user's Windows checkout for the final exact PR HEAD.
- [ ] Bind matrix/manifest SHA-256 evidence to PR #103, then merge and verify `main`.
