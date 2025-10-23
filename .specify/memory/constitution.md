<!--
Sync Impact Report
Version change: [none] → 1.0.0
Modified principles: All placeholders replaced with concrete values
Added sections: All (initial constitution)
Removed sections: None
Templates requiring updates: ✅ All checked, no changes needed
Follow-up TODOs: None
-->

# Arexibo Nix Fork Constitution

## Core Principles

### I. Nix/NixOS-First Packaging
All development and maintenance in this repository MUST focus on building and maintaining arexibo as a Nix package and NixOS module. No other packaging or deployment targets are supported or maintained.

### II. Reproducibility and Purity
All packaging and build processes MUST be reproducible and pure, leveraging Nix best practices. Builds MUST not depend on external state or mutable system configuration.

### III. Minimal Upstream Divergence
No changes to the underlying Rust codebase are permitted unless strictly required for Nix/NixOS packaging. The fork exists solely to enable Nix-based builds and modules.

### IV. Documentation and Transparency
All packaging logic, module definitions, and build instructions MUST be documented in the repository, with all Nix expressions contained in flake.nix and related documentation files.

### V. Community and Upstream Respect
Contributions MUST respect the upstream arexibo project’s license and intent. Any changes or improvements outside Nix/NixOS packaging MUST be proposed upstream first.

## Additional Constraints

This repository is a fork of arexibo for the sole purpose of building the project as a nixpkg and NixOS module. No other use cases are supported.

## Development Workflow

All changes MUST be reviewed for compliance with the above principles. Pull requests MUST include justification for any deviation from minimal-diff or Nix/NixOS-only changes. Automated checks for reproducibility and purity are required before merging.

## Governance

This constitution supersedes all other practices in this repository. Amendments require documentation, approval, and a migration plan. All PRs and reviews must verify compliance with these principles. Complexity must be justified. Use README.md and flake.nix for runtime development guidance.

**Version**: 1.0.0 | **Ratified**: 2025-10-21 | **Last Amended**: 2025-10-21
