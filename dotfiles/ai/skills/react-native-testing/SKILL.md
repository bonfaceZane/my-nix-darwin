---
name: react-native-testing
description: Plan and write useful tests for React Native apps, from pure logic and components to platform behavior and device flows. Use when adding or changing mobile UI or interactions.
---

# React Native testing

Start by checking the project's test scripts, runner, installed testing
libraries, and existing test patterns. Use the repository's configured tools;
do not add a new framework or install packages without a clear need.

The rules below are strict for new and changed behavior: test user-visible
outcomes at the appropriate level, keep tests deterministic, and distinguish
simulated coverage from real device verification.

## Choose the right test level

- **Pure logic:** Test formatting, validation, reducers, and other deterministic
  behavior without rendering React Native UI.
- **Component behavior:** Use the project's React Native component-testing
  library to render a component and interact with it as a user would.
- **Platform behavior:** Cover meaningful iOS and Android differences with the
  project's platform-specific test setup or device workflows.
- **Device flow:** Use the existing end-to-end tool when native permissions,
  navigation integration, keyboard behavior, or a multi-screen journey matters.

Prefer the lowest level that gives confidence in the behavior. A component test
does not prove that a native permission prompt, animation, or device integration
works on a real platform.

Do not claim OS-dependent behavior is verified based only on a mocked component
test. Use a simulator, emulator, or device when that behavior is in scope.

## Write behavior-focused tests

- Query controls by accessible role, label, or visible text when supported.
- Exercise user actions and assert the visible result, callback, or state change.
- Cover important loading, empty, error, retry, offline, and permission states
  that the component owns.
- For async work, wait for the user-visible result using the test library's
  async helpers instead of arbitrary delays.
- Prefer stable public behavior over snapshots of large trees or assertions on
  private implementation details.
- Mock platform APIs and external services at their boundary. Keep the real
  component behavior under test, and avoid broad mocks that hide integration
  errors.
- Keep tests independent: reset state and mocks, and avoid reliance on execution
  order or live network services.

## React Native details

- Check whether the code path depends on platform, safe areas, permissions,
  app state, keyboard, deep links, or native modules; choose tests that exercise
  those assumptions.
- Mock native modules only when the test environment cannot provide them, and
  keep mocks aligned with the API the app actually uses.
- Do not treat a simulated platform value as proof of native behavior. Use an
  iOS simulator or Android emulator/device for behaviors that depend on the OS.
- For end-to-end checks, use existing device skills and scripts such as the
  project's Maestro or simulator workflows when configured.

## Verification

Run the narrowest relevant test first, then the project's broader typecheck,
lint, or test task when appropriate. Report the command and platform actually
checked. If a test cannot run because a simulator, native dependency, or service
is unavailable, state that limitation rather than claiming device verification.
