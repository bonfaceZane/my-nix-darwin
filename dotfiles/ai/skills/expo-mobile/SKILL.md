---
name: expo-mobile
description: Build and maintain Expo and React Native apps across iOS, Android, and web. Use for screens, navigation, native capabilities, Expo configuration, SDK-compatible dependencies, or device verification.
---

# Expo and React Native

Use this skill for projects built with Expo and React Native. Read the current
project's instructions first and follow its existing architecture, package
manager, navigation, styling, state, and testing conventions. Do not assume a
particular Expo SDK, router, UI kit, or folder layout.

## Strict baseline

- Check the app's actual SDK, dependencies, scripts, and platform support before
  recommending or changing an API. Do not guess version compatibility.
- Search for existing screens, components, hooks, and native integrations before
  adding another implementation of the same behavior.
- Do not define component functions inside another component's render path.
  Keep platform-specific code behind the project's established platform split
  or platform-selection pattern.
- Do not put secrets in client code, app configuration shipped to users, or
  `EXPO_PUBLIC_*` variables.
- Treat accessibility, loading/error states, and platform differences as part
  of the feature, not optional polish.
- Do not claim a native behavior is verified by Metro reload or a component
  test alone; use the project's device workflow when the behavior depends on
  the OS or a native module.

## Workflow

1. Identify the app package and its scripts. In a monorepo, use the workspace's
   documented task runner and project target rather than guessing a command.
2. Check the installed Expo SDK and React Native versions before changing
   dependencies or native configuration.
3. Prefer Expo's supported APIs and config plugins when they meet the need.
   Check current official documentation for version-sensitive APIs.
4. Keep platform-specific behavior explicit. Use `.ios` and `.android` files or
   `Platform.select` when the native implementations or interactions differ.
5. Consider loading, error, empty, permission-denied, offline, keyboard, safe
   area, and accessibility states when they apply to the feature.
6. Verify the change on the affected platform when a simulator, emulator, or
   device is available. State which platform and workflow were actually used.

## Dependencies and native configuration

- Use `npx expo install <package>` for Expo and React Native packages when the
  project uses Expo; it selects versions compatible with the installed SDK.
- Follow the repository's package manager and lockfile. Do not update unrelated
  dependencies as part of a feature change.
- Native dependency or app-config changes may require a development-client
  rebuild. A Metro reload alone does not apply native code changes.
- Run `npx expo-doctor` when checking Expo dependency/configuration health, if the
  project supports it.

## Configuration and data safety

- Expo inlines `EXPO_PUBLIC_*` values into client bundles. Never put passwords,
  private API keys, or other secrets in public variables or shipped app code.
- Keep environment-specific configuration aligned with the app's existing
  validation and build-profile setup.
- Do not assume an emulator can reach a host service through `localhost`; use
  the platform's documented host address and the project's configured endpoint.

## Useful commands

Use the project's scripts first. Common Expo commands, when supported, include:

- `npx expo start` to start Metro.
- `npx expo run:ios` or `npx expo run:android` to build and launch a native app.
- `npx expo prebuild` to generate native projects when the project uses that
  workflow. Generated native directories may be disposable or checked in; check
  repository instructions before changing or cleaning them.

## Related skills

- `ios-simulator` and `android-emulator` can help drive a device when available.
- `radon-ide` describes an optional editor-based run and inspection workflow.
