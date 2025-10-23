# Tasks: Add NixOS Module

**Input**: Design documents from `/home/jmartin/development/rust/arexibo/specs/002-add-nixos-module/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions
- **Single project**: `src/`, `tests/` at repository root
- **Web app**: `backend/src/`, `frontend/src/`
- **Mobile**: `api/src/`, `ios/src/` or `android/src/`
- Paths shown below assume single project - adjust based on plan.md structure

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [X] T001 Create NixOS module structure in flake.nix

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Define NixOS module options in flake.nix
- [X] T003 Set up module configuration validation

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Enable Declarative Configuration (Priority: P1) 🎯 MVP

**Goal**: Allow users to configure Arexibo using declarative Nix options

**Independent Test**: Verify that setting options in NixOS configuration results in correct Arexibo startup parameters

### Implementation for User Story 1

- [X] T004 [US1] Implement enable option in flake.nix
- [X] T005 [US1] Implement host option in flake.nix
- [X] T006 [US1] Implement key option in flake.nix
- [X] T007 [US1] Implement displayId option in flake.nix
- [X] T008 [US1] Implement proxy option in flake.nix
- [X] T009 [US1] Implement dataDir option in flake.nix
- [X] T010 [US1] Implement displayName option in flake.nix
- [X] T011 [US1] Add configuration script generation

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - Systemd Integration (Priority: P2)

**Goal**: Ensure Arexibo runs as a proper systemd service

**Independent Test**: Check that systemctl status shows arexibo service running and managed by systemd

### Implementation for User Story 2

- [X] T012 [US2] Configure systemd service in flake.nix
- [X] T013 [US2] Set up user and group creation
- [X] T014 [US2] Configure service dependencies and startup
- [X] T015 [US2] Add security settings for systemd service
- [X] T016 [US2] Implement X server integration options

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [X] T017 [P] Update documentation in nixos-module.md
- [X] T018 [P] Update README.md with module usage
- [X] T019 Run quickstart.md validation
- [X] T020 Add module to flake outputs

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - Depends on US1 for basic configuration

### Within Each User Story

- Options implementation before service configuration
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- Options within a story can be implemented in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all options for User Story 1 together:
Task: "Implement enable option in flake.nix"
Task: "Implement host option in flake.nix"
Task: "Implement key option in flake.nix"
Task: "Implement displayId option in flake.nix"
Task: "Implement proxy option in flake.nix"
Task: "Implement dataDir option in flake.nix"
Task: "Implement displayName option in flake.nix"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence