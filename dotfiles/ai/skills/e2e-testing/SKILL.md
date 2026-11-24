---
name: e2e-testing
description: Design, implement, debug, or review end-to-end tests for user-critical application flows.
---

# End-to-end testing

Use the project's configured E2E runner and read its setup, test data, build
profiles, and CI workflow before changing tests. E2E tests should cover a small
set of critical integrated user journeys; use unit or component tests for
broader edge-case coverage.

## Workflow

1. Choose stable user-visible outcomes and selectors. Prefer accessibility
   labels, roles, and test IDs over layout coordinates or fragile text matches.
2. Make scenarios repeatable: control test data and account state, isolate tests
   where practical, and wait for observable conditions instead of fixed sleeps.
3. Keep setup and cleanup explicit. Do not use production accounts or mutate
   shared live data unless the user authorizes it.
4. Run the narrowest relevant flow first, then the configured suite when useful.
   Capture artifacts on failure and distinguish runner success from behavior
   verified on a real simulator/device.

For React Native and Expo, use Maestro for repeatable flows when the project has
it configured. Use `agent-device` for interactive exploration and visual or
accessibility inspection; that inspection complements repeatable E2E tests.
Follow `expo-mobile` and `react-native-testing` for mobile-specific constraints.

References: [Expo E2E guide](https://docs.expo.dev/guides/using-e2e/), [Maestro documentation](https://maestro.mobile.dev/).
