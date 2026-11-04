---
name: component-first
description: Design and refactor React components with reuse, clear ownership, and simple APIs. Use when adding UI, extracting repeated markup, or deciding where a component belongs.
---

# Component-first React

Build UI by composing existing components and primitives. These rules are strict
for UI changes: search before creating, preserve a single implementation for
shared behavior, and do not add abstractions without a real owner or use case.
Follow the project's documented exceptions.

## Decide in this order

1. **Reuse:** Search the app's existing components and design system before
   creating a new one. Prefer an existing component when it fits or can support
   the difference with a small, meaningful prop.
2. **Compose locally:** If the UI is unique to one feature, compose existing
   primitives near that feature. Keep feature-specific behavior with its owner.
3. **Extract:** Move a component to a shared location when it has multiple real
   consumers, represents app-wide UI, or needs an independent API and tests.
4. **Create:** Add a new abstraction when the existing options do not fit and the
   new component has a clear owner and responsibility.

## Component boundaries

- Put JSX in a React component file and non-UI logic in ordinary modules where
  the project supports that separation.
- Keep screen or page components focused on composing feature UI. Small local
  helpers are fine when they do not obscure the screen or create unstable
  component identity.
- Do not define component functions inside another component's render path.
  This creates a new component type on each render and can remount its subtree.
- Place shared components according to the repository's established structure;
  do not impose a new folder convention on an existing codebase.
- Keep data fetching, business rules, and platform services out of purely
  presentational components when the project has a clearer owner for them.
- Do not duplicate shared UI, accessibility behavior, or interaction logic. Add
  a supported variant to the owning component or compose existing primitives.
- Do not create generic wrappers, boolean prop matrices, or speculative
  component frameworks for a single use case.

## Props and variation

- Design props around what callers need to express, not the component's internal
  implementation details.
- Every prop must represent a real caller need; remove props that only expose
  internal mechanics or have no current use.
- Give optional props predictable defaults when there is a safe default.
- Use a small set of clear variants for real design differences. Prefer slots,
  children, or composition when callers need to provide distinct content.
- Do not turn every difference into a prop. If one caller's needs make the API
  hard to understand, keep that UI feature-local instead.
- Keep one source of truth for repeated interaction behavior, accessibility,
  styling, and gesture handling when those pieces must stay consistent.

## Refactor safely

1. Find the existing implementations and their callers.
2. Identify which differences are meaningful and which are accidental drift.
3. Extract only the shared responsibility; keep feature-specific decisions at
   the feature boundary.
4. Update callers together and remove superseded copies.
5. Add or adjust focused tests and follow the repository's formatting and type
   checks.

For React Native, also follow the app's platform split, accessibility, design
system, and native component conventions. Consult the `expo-mobile` skill when
it is available.
