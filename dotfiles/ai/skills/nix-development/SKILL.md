---
name: nix-development
description: Develop, debug, or review Nix expressions, flakes, derivations, and dev shells in any Nix project.
---

# Nix development

Read the project's instructions and identify its Nix version, flake structure,
formatter, and evaluation/build checks first. Preserve its module boundaries and
pinned inputs unless the task specifically requires a change.

## Workflow

1. Trace the expression's callers and option/package ownership before editing.
   Prefer existing project abstractions and first-class module options over
   duplicate configuration.
2. Keep evaluation pure where practical. Do not read secrets during evaluation;
   pass secret file paths to runtime consumers instead of embedding values.
3. Use the repository's formatter and validation tasks. Check syntax, then
   evaluate or build the narrowest affected output; use `nix flake check` when
   its scope and cost are appropriate.
4. Treat evaluation, build, and activation as different levels of evidence.
   Never activate a machine configuration unless the user explicitly asks.
5. Report input/network failures and untested runtime behavior accurately.

For this machine's nix-darwin checkout, use the narrower
`nix-darwin-maintenance` workflow, which owns its specific paths and safety
rules.

References: [Nix language basics](https://nix.dev/tutorials/nix-language), [flakes](https://nix.dev/concepts/flakes).
