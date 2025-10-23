# AGENTS.md

## Build, Lint, and Test Commands
- Build: `cargo build --release`
- Install: `cargo install --path . --root /usr`
- Nix: `nix build`, `nix run`, `nix profile install`
- Run all tests: `cargo test`
- Run a single test: `cargo test <testname>`
- Lint: `cargo clippy`
- Format: `cargo fmt`

## Code Style Guidelines
- Use Rust 2021 edition conventions.
- Group imports: standard, external, then internal crates.
- Use explicit types; prefer `anyhow::Result` for errors.
- Naming: snake_case for functions/variables, CamelCase for types/structs.
- Use doc comments (`///`) for public items; regular comments for internals.
- Handle errors with `anyhow`, `with_context`, and `bail!` macros.
- Prefer immutable variables; use `let mut` only when needed.
- Keep functions short and focused; split logic as needed.
- No Cursor or Copilot rules are present.

Follow these guidelines for consistency and reliability when contributing or using agentic tools in this repository.
