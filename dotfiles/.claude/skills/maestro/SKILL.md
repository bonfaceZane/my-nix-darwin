---
name: maestro
description: Maestro E2E testing for iOS and Android in the amv-apps monorepo. Use when writing, running, or debugging E2E test flows.
version: 1.0.0
---

# Maestro E2E Testing

## Setup
Maestro is installed at `~/.maestro/bin`. Tests live in the amv-apps repo.

## Running tests
```bash
# iOS
mise run e2e-ios

# Android
mise run e2e-android

# Run a specific flow
maestro test path/to/flow.yaml

# Run with tags
maestro test --include-tags=smoke path/to/flows/
```

## Writing flows (YAML)
```yaml
appId: nl.gaspedaal.app  # or nl.autotrack.app
---
- launchApp
- tapOn: "Inloggen"
- inputText:
    text: "test@example.com"
    label: "E-mailadres"
- tapOn: "Volgende"
- assertVisible: "Dashboard"
```

## Key commands
| Command | Usage |
|---------|-------|
| `launchApp` | Launch the app (clears state by default) |
| `tapOn` | Tap by text, id, or point |
| `inputText` | Type into focused/labeled input |
| `assertVisible` | Assert element is on screen |
| `assertNotVisible` | Assert element is absent |
| `scrollUntilVisible` | Scroll until element appears |
| `swipe` | Swipe gesture |
| `runScript` | Run JavaScript for dynamic logic |

## Selectors
```yaml
- tapOn:
    id: "login-button"         # testID / accessibilityLabel
- tapOn:
    text: "Doorgaan"           # visible text
- tapOn:
    point: "50%,75%"           # screen coordinates
```

## Debugging
```bash
# View device hierarchy (find element IDs)
maestro studio

# Record a flow interactively
maestro record
```

## Tips
- Add `testID` props to key elements in RN for reliable selectors
- Use `runScript` for waits and conditional logic
- Keep flows focused — one user journey per file
- Use `- runFlow: shared/login.yaml` to reuse common flows
