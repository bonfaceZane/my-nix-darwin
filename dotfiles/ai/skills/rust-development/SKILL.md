---
name: rust-development
description: Implement, refactor, debug, or review Rust code using Cargo workspaces, the repository's toolchain, and idiomatic error and ownership practices.
---

# Rust development

Follow the repository's `AGENTS.md`, `rust-toolchain.toml`, `Cargo.toml`,
workspace layout, feature policy, and CI commands. Use its pinned Rust version
and minimum supported Rust version instead of assuming the globally installed
toolchain is authoritative.

## Workflow

1. Trace the relevant crate, public API, feature gates, and existing tests before
   changing code. Keep changes within the owning crate unless a workspace-level
   change is required.
2. Prefer safe ownership and borrowing, explicit domain types, and `Result` for
   recoverable failures. Keep `unwrap`/`expect` out of fallible production paths
   unless an invariant is explicit and locally justified.
3. Keep `unsafe` blocks narrow, document their safety invariants, and avoid
   adding them when a safe API meets the need.
4. Add tests at the crate's existing level. Cover public behavior and relevant
   error cases without coupling tests to private implementation details.
5. Run the project's focused checks. Common checks are:

   ```sh
   cargo fmt --all --check
   cargo clippy --workspace --all-targets -- -D warnings
   cargo test --workspace
   ```

   Adapt flags for the project's features, MSRV, and CI policy.

Do not apply broad Clippy suggestions mechanically. Preserve compatibility,
readability, and performance intent, and explain any lint allowance at the
narrowest appropriate scope.

References: [Cargo](https://doc.rust-lang.org/cargo/), [Clippy](https://doc.rust-lang.org/clippy/).
