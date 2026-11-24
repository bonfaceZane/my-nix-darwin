---
name: vercel-react-native
description: Apply Vercel's React Native performance guidance selectively and rigorously in Expo or React Native projects. Use for mobile UI, rendering, list, animation, navigation, image, or native performance work.
---

# Vercel React Native guidance

Use this as a strict review checklist for React Native and Expo work. The
upstream source is [Vercel Labs React Native skills](https://github.com/vercel-labs/agent-skills/tree/main/skills/react-native-skills),
licensed MIT. This local skill preserves the high-value guidance while making
project compatibility and measured outcomes mandatory.

## Mandatory decision rules

- Read the project's instructions, Expo SDK and React Native versions, package
  manifest, navigation and styling choices, and nearby implementation first.
- Treat a recommendation as a hypothesis until it fits the installed versions,
  existing architecture, target platforms, and user-visible requirement.
  Never add or replace a library solely because an upstream rule names it.
- Before a performance refactor, identify the measured or reproducible problem,
  establish a baseline, and state the metric or visible behavior expected to
  improve. If there is no demonstrated problem, prefer the simplest correct
  implementation and avoid speculative optimization.
- Do not perform a broad cleanup or rewrite while addressing a focused bug or
  feature. Keep changes local and preserve behavior, accessibility, and platform
  support.
- For Expo dependencies, verify SDK compatibility and use the project's package
  manager and Expo-compatible install workflow. Do not update unrelated packages.
- Validate performance in a release-like build on representative hardware when
  performance is the goal. Compare before and after using the same scenario;
  report the device, build mode, and observed result. A code review alone does
  not prove a performance improvement.

## Review by concern

### Rendering and state

- Ensure every rendered string is inside a React Native `Text` component.
- Avoid `condition && <View />` when the condition may be `0`, `NaN`, or another
  value React Native could render; use an explicit boolean or ternary.
- Keep state to user-meaningful source values and derive values that can be
  calculated cheaply. Keep subscriptions scoped to the smallest component that
  needs them.
- Stabilize callbacks, objects, and list item components only when identity
  churn causes measurable work or is required by a memoized consumer. Do not
  add `memo`, `useMemo`, or `useCallback` mechanically.

### Lists and images

- Use a virtualized list for long or unbounded collections; use `ScrollView` for
  short bounded content. Check the current list implementation and measure
  before migrating between `FlatList`, FlashList, LegendList, or another library.
- For a list issue, inspect stable keys, item complexity, pagination, image size,
  row identity, and unnecessary state subscriptions before changing libraries.
- Optimize image source dimensions and caching when image loading or memory is
  a demonstrated issue. `expo-image` can be a good Expo choice when it is
  installed or compatible, but is not a mandatory replacement for every image.
- For heterogeneous virtualized lists, consider item types only when profiling
  shows recycling or rendering costs justify the added complexity.

### Motion, navigation, and platform UI

- Prefer transform and opacity for smooth animations when they meet the design;
  avoid animating layout properties on a frame-by-frame path without measuring.
- Keep gesture and animation work on the appropriate native/UI thread when the
  project's installed animation stack supports it. Follow that stack's current
  API and compatibility requirements; do not add Reanimated or Gesture Handler
  automatically.
- Preserve the project's router and navigator. Consider native navigators or
  native UI only when platform behavior, user experience, or measured
  performance calls for it; do not replace navigation as a generic optimization.
- Respect safe areas, keyboard behavior, reduced motion, accessibility labels,
  and iOS/Android differences. Performance changes must not make controls harder
  to use or remove expected feedback.

## Verification

- Choose the narrowest checks supported by the project. For Expo tasks, follow
  `expo-mobile`; for repeatable integrated journeys, follow `e2e-testing`.
- When live UI inspection or visual verification is required, use `agent-device`
  and the applicable platform skill. Do not substitute a web preview or unit
  test for native-device evidence.
- State what was measured, what checks ran, and any device or build limitation.
  Never describe an optimization as faster without comparative evidence.
