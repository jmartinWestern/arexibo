# Tasks: Nix Flake for NixOS Package (001-flake-nixos-package)

## Phase 1: Setup
- [ ] T001 Create feature branch and planning files in /specs/001-flake-nixos-package/
- [ ] T002 [P] Research Nix flake best practices for Rust binaries in /specs/001-flake-nixos-package/research.md
- [ ] T003 [P] Research flake-utils usage for multi-system support in /specs/001-flake-nixos-package/research.md

## Phase 2: Foundation
- [ ] T004 Create initial flake.nix in /flake.nix
- [ ] T005 Add flake-utils as an input in /flake.nix
- [ ] T006 Use flake-utils.lib.eachDefaultSystem to define supported systems in /flake.nix
- [ ] T007 Add nixpkgs as an input in /flake.nix
- [ ] T008 Define arexibo package using buildRustPackage in /flake.nix
- [ ] T009 Ensure all build inputs (Rust, Cargo, etc.) are specified in /flake.nix
- [ ] T009a [BLOCK] Constitution gate: Verify no changes to /src/ or /Cargo.toml before proceeding to implementation (per Constitution III)

## Phase 3: User Story 1 - Build Arexibo with Nix Flake (P1)
- [ ] T010 [P] [US1] Expose arexibo as the default package for all supported systems in /flake.nix
- [ ] T011 [US1] Ensure nix build produces a working arexibo binary in /flake.nix
- [ ] T012 [US1] Ensure nix run launches the built binary in /flake.nix
- [ ] T013 [US1] Ensure nix flake show displays arexibo as the default package in /flake.nix
- [ ] T014 [US1] Ensure nix profile install and system install work for arexibo in /flake.nix
- [ ] T014a [US1] User acceptance test: Confirm 100% of users can build, run, and install arexibo using standard Nix workflows (document in /specs/001-flake-nixos-package/quickstart.md)
- [ ] T014b [US1] Test error handling for missing/incompatible dependencies and non-NixOS systems (document expected error messages in /specs/001-flake-nixos-package/quickstart.md)

## Phase 4: User Story 2 - All NixOS Content in flake.nix (P2)
- [ ] T015 [US2] Ensure all NixOS packaging logic is present only in /flake.nix
- [ ] T016 [US2] Ensure no changes are made to Rust code for NixOS packaging (verify src/ and Cargo.toml)

## Phase 5: Polish & Cross-Cutting Concerns
- [ ] T017 [P] Add comments to /flake.nix explaining key sections
- [ ] T018 [P] Add or update /specs/001-flake-nixos-package/quickstart.md with build/run instructions
- [ ] T019 [P] Add or update /README.md with flake usage instructions
- [ ] T020 [P] Test on at least two different systems (e.g., x86_64-linux, aarch64-linux) using /flake.nix
- [ ] T021 [P] Ensure reproducibility: clean build from scratch using /flake.nix
- [ ] T022 [P] Review for minimal upstream divergence (no Rust code changes) in /src/ and /Cargo.toml
- [ ] T023 Constitution check: all requirements satisfied in /specs/001-flake-nixos-package/plan.md

---

## Dependencies
- Phase 1 (Setup) → Phase 2 (Foundation) → Phase 3 (US1) and Phase 4 (US2) (can be parallel)
- Phase 5 (Polish) can be started after Foundation, but some tasks depend on US1/US2 completion

## Parallel Execution Examples
- T002 and T003 (research) can be done in parallel
- T005, T006, T007, T008, T009 (flake.nix setup) can be parallelized if working on different sections
- T017–T022 (polish) can be parallelized after main implementation

## Implementation Strategy
- MVP: Complete all tasks for User Story 1 (T010–T014) to deliver a working Nix flake that builds and runs arexibo
- Incrementally deliver User Story 2 and polish tasks

## Format Validation
- All tasks follow strict checklist format: `- [ ] T### [P] [US#] Description with file path`
- Each user story has independently testable tasks
- All file paths are explicit

---

**Total tasks:** 23
**User Story 1 tasks:** 5
**User Story 2 tasks:** 2
**Parallel opportunities:** 10+ (see [P] markers and examples)
**MVP scope:** T010–T014 (User Story 1)
**Test criteria:** Each user story phase includes independent testable outcomes as per spec.md
