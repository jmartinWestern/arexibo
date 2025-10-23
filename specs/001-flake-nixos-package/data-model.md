# Data Model: Nix Flake for NixOS Package

## Entities

### flake.nix
- Represents: The Nix flake file containing all packaging logic and metadata for arexibo, including exposing arexibo as the default package for all supported systems.
- Attributes: Package definition, module definition, build inputs, outputs, default package exposure.

### arexibo package
- Represents: The resulting NixOS package built from the Rust source code.
- Attributes: Binary output, version, dependencies, NixOS module options.

## Relationships
- flake.nix defines and builds the arexibo package.
- arexibo package is consumed as a NixOS package or module.
