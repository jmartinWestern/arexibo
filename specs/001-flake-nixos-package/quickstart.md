# Quickstart: Building and Using arexibo with Nix Flake

## Prerequisites
- Nix installed (with flakes enabled)
- Supported platform: NixOS or any Linux with Nix

## Build the package
```sh
nix build
```

## Run arexibo directly
```sh
nix run
```

## Install to user profile
```sh
nix profile install
```

## Use as a NixOS module
- See `nixos-module.md` and `nixos-example.md` for configuration examples.

## User Acceptance & Error Handling
- 100% of users can build, run, and install arexibo using:
  - `nix build` (produces working binary)
  - `nix run` (launches arexibo)
  - `nix profile install` (installs to user profile)
- Arexibo is exposed as the default package for all supported systems (x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin).
- All packaging logic is in flake.nix. No changes to Rust code are required.
- For troubleshooting, consult the README and flake.nix comments.
- Build time should be measured and documented (see plan.md for hardware baseline).
- **Error handling:**
  - If dependencies are missing, Nix will display a clear error (e.g., "missing build input: qt6.full").
  - On unsupported platforms, Nix will display "unsupported system" or "no matching output for system".
  - For non-NixOS systems, users may need to install additional libraries or use a compatible Nixpkgs version.
- If you encounter errors, check your Nix installation, enable flakes, and ensure all system dependencies are present.
