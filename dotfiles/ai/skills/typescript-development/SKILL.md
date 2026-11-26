---
name: typescript-development
description: Implement, refactor, debug, or review TypeScript code while following the project's compiler, runtime, and test conventions.
---

# TypeScript development

Use the target repository's package manager, scripts, `tsconfig`, module system,
runtime, and lint/test setup. In a monorepo, work through its task runner and
workspace boundaries.

## Workflow

1. Read project instructions and inspect the relevant package scripts, compiler
   configuration, nearby types, and tests before changing code.
2. Preserve the intended runtime and module resolution. Do not copy compiler
   options between browser, Node, React Native, and library projects blindly.
3. Keep types precise at boundaries. Prefer `unknown` plus validation for
   untrusted data; avoid introducing `any`, unsafe casts, or duplicated models
   when existing schemas or API types define the contract.
4. Model mutually exclusive states with discriminated unions so invalid
   combinations are difficult to represent.
5. Use service factory functions to create and configure services when
   applicable, following the project's established architecture and patterns.
6. Keep side effects at clear boundaries. Separate I/O and framework work from
   pure transformations, and pass dependencies into services instead of hiding
   them in module-level state.
7. Handle errors intentionally: preserve useful context, define how errors
   cross module boundaries, and avoid silently discarding failures.
8. Handle async cancellation, stale results, and cleanup when required by the
   runtime or UI lifecycle.
9. Avoid unnecessary abstractions. Follow existing project patterns and add
   helpers or generics when they make behavior or ownership clearer.
10. Avoid nested ternary operators. Use named intermediate values, `if`/`else`,
   a `switch`, helper functions, or a lookup map when a conditional choice has
   multiple levels so the logic stays easy to read and change.
11. Add or update behavior-focused tests using the project's existing runner.
   Cover error and edge states when the changed behavior owns them.
12. Run the narrowest relevant typecheck and tests, then the project lint or
   build task when useful. Report skipped checks and their reason.

Use `strict` checking for new configurations when the runtime supports it, but
do not silently broaden or weaken an existing project's compiler settings.
Choose formatting and lint tools already adopted by that repository; do not run
multiple formatters over the same files without a defined ownership boundary.

For React and React Native work, also follow `component-first`, `expo-mobile`,
and `react-native-testing` when applicable.

For React and React Native, follow the shared code-style rule of one component
per source file and prefer functional composition, pure transformations, and
immutable data flow. Keep side effects at explicit boundaries and keep a
component's file cohesive rather than scattering trivial helpers.

References: [TypeScript compiler options](https://www.typescriptlang.org/docs/handbook/compiler-options), [module options](https://www.typescriptlang.org/docs/handbook/modules/guides/choosing-compiler-options).
