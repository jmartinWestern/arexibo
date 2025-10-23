# Implementation Plan: Nix Flake for NixOS Package

**Branch**: 001-flake-nixos-package | **Date**: 2025-10-21 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-flake-nixos-package/spec.md`

## Summary

This feature provides a Nix flake (flake.nix) that builds arexibo as a NixOS package and module, with all packaging logic contained in flake.nix and no changes to the Rust codebase. The approach follows Nix/NixOS best practices for reproducibility, purity, and minimal upstream divergence.

## Technical Context

**Language/Version**: Rust 1.75
**Primary Dependencies**: Nix, Nixpkgs, flake-utils, Cargo, Rust toolchain
**Storage**: N/A (no persistent storage required for packaging)
**Testing**: Nix flake build/test, cargo test
**Target Platform**: NixOS (and other systems with Nix installed)
**Project Type**: Single-package (Rust binary packaged for NixOS)
**Performance Goals**: Build completes in under 10 minutes on a quad-core x86_64 system with 16GB RAM and SSD
**Constraints**: All NixOS packaging logic must be in flake.nix; no changes to Rust code
**Scale/Scope**: Single package, single binary output

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Nix/NixOS-First Packaging: All development and maintenance in this repository MUST focus on building and maintaining arexibo as a Nix package and NixOS module. No other packaging or deployment targets are supported or maintained.
- Reproducibility and Purity: All packaging and build processes MUST be reproducible and pure, leveraging Nix best practices. Builds MUST not depend on external state or mutable system configuration.
- Minimal Upstream Divergence: No changes to the underlying Rust codebase are permitted unless strictly required for Nix/NixOS packaging. The fork exists solely to enable Nix-based builds and modules.
- Documentation and Transparency: All packaging logic, module definitions, and build instructions MUST be documented in the repository, with all Nix expressions contained in flake.nix and related documentation files.
- Community and Upstream Respect: Contributions MUST respect the upstream arexibo project’s license and intent. Any changes or improvements outside Nix/NixOS packaging MUST be proposed upstream first.

**Gate Evaluation:**
- All MUST principles are satisfied by the current feature specification and plan. No violations detected.

## Project Structure

### Documentation (this feature)

```
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

*Fill ONLY if Constitution Check has violations that must be justified*

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |

