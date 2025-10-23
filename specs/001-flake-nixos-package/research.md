# Research: Nix Flake for NixOS Package

## Best Practices: Rust Binaries with Nix Flakes
- Use `buildRustPackage` from nixpkgs for reproducible Rust builds.
- Pin all dependencies via flake inputs and lockfile.
- Avoid patching upstream Rust code unless strictly necessary.
- Expose the Rust binary as the default package for all supported systems.
- Document all build inputs and outputs in flake.nix.
- Use `nix develop` for dev environments, and `nix run` for running the binary.
- Ensure no secrets or sensitive data are present in flake.nix (world-readable).

## Best Practices: flake-utils for Multi-System Support
- Use `flake-utils.lib.eachDefaultSystem` to build for all major platforms (`x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, `aarch64-darwin`).
- This enables `nix build`, `nix run`, and `nix develop` to work seamlessly across systems.
- Example pattern:
  ```nix
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in {
        packages.default = pkgs.buildRustPackage { ... };
      });
  ```
- Document supported systems and test on at least two architectures.

## Decision: Use Nix flake for packaging
- Rationale: Nix flakes provide reproducible, pure, and declarative packaging for NixOS and other Nix-enabled systems. They are the current best practice for new Nix/NixOS packages.
- Alternatives considered: Legacy Nix expressions (default.nix), external overlays, or patching upstream code. All were rejected in favor of a single flake.nix for simplicity and maintainability.

## Decision: No changes to Rust codebase
- Rationale: The fork’s sole purpose is to enable Nix/NixOS packaging. Upstream code should remain untouched to minimize divergence and ease future updates.
- Alternatives considered: Patch Rust code for Nix compatibility. Rejected unless strictly required for build success.

## Decision: All logic in flake.nix
- Rationale: Keeping all Nix expressions in flake.nix ensures maintainability, transparency, and compliance with project principles.
- Alternatives considered: Splitting logic into multiple Nix files. Rejected for simplicity and clarity.

## Decision: Expose arexibo as the default package
- Rationale: This enables `nix build`, `nix run`, and `nix profile install` to work seamlessly for users on all supported systems.
- Alternatives considered: Exposing as a non-default output. Rejected for usability and Nix flake convention reasons.

## Decision: Performance measurement
- Rationale: Ensures the build process is efficient and meets user expectations for turnaround time.
- Alternatives considered: No measurement. Rejected for lack of accountability.

## Decision: Error handling for dependencies and platforms
- Rationale: Users must receive clear feedback if dependencies are missing or if building on unsupported platforms.
- Alternatives considered: Rely on default Nix errors. Rejected for lack of user guidance.
