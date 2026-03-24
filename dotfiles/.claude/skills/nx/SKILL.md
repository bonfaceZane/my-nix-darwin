---
name: nx
description: Nx monorepo task running and workspace management. Use when running builds, tests, linting, or working with Nx project configuration.
version: 1.0.0
---

# Nx Monorepo

## Rules
- Always run tasks through `nx`, never the underlying tool directly (e.g. `nx run myapp:build` not `tsc`)
- Use `nx affected` for CI to only run tasks on changed projects
- Use `nx run-many` to run a task across multiple projects

## Common Commands

```bash
# Run a task for one project
nx run myapp:build
nx run myapp:test
nx run myapp:lint

# Run across all projects
nx run-many --target=build
nx run-many --target=test --parallel=3

# Only affected by current changes
nx affected --target=build
nx affected --target=test

# Visualize project graph
nx graph

# List available targets for a project
nx show project myapp
```

## Understanding the workspace
Use the `nx_workspace` MCP tool first when asked about project relationships, dependencies, or architecture — it gives the authoritative graph.

## Project details
Use `nx_project_details` MCP tool to understand a specific project's targets, dependencies, and configuration before modifying it.

## Configuration questions
Use `nx_docs` MCP tool for Nx config questions instead of guessing — Nx APIs change between versions.

## Caching
Nx caches task outputs. If results look stale, clear with:
```bash
nx reset
```

## Adding a new library
```bash
nx g @nx/js:library my-lib --directory=libs/my-lib
```
