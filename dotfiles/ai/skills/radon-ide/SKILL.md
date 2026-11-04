---
name: radon-ide
description: Run, inspect, and debug Expo or React Native apps with Radon IDE in VS Code or Cursor. Use when Radon IDE or its MCP tools are already available in the current workspace.
---

# Radon IDE for React Native

Radon IDE by Software Mansion provides an editor panel for running and
debugging React Native and Expo apps. Its optional Radon AI MCP integration can
expose the running app and documentation tools to an agent.

## Before using it

- Check the current workspace's instructions for its app root, launch setup,
  development-client requirements, and preferred verification workflow.
- Confirm Radon IDE is installed and the project is open in a supported editor.
- Check whether Radon's MCP tools are available before relying on agent-driven
  screenshots, logs, component inspection, network inspection, or reloads.
- Treat Radon as an optional project tool. Do not add a global MCP entry,
  download an unpinned server package, or change workspace settings unless the
  user requests that setup.

## Typical inspection loop

1. Start the app using the project's configured Radon launch workflow.
2. Use the available reload tool after JavaScript changes.
3. Inspect a screenshot and runtime or bundler logs to confirm the visible
   result and check for errors.
4. Use the component tree or network inspection when they help explain a UI or
   request problem.
5. For native dependency or app-config changes, rebuild the development client
   as required by the project; a reload may not include native changes.
6. Report which device or platform was checked and whether Radon or another
   route was used.

## Troubleshooting and fallback

- Only one Metro/Expo server should own the configured port at a time. Follow
  the project's instructions to resolve a port conflict; do not kill an
  unrecognized process automatically.
- If Radon or its MCP connection is unavailable, use the project's documented
  Expo CLI, `ios-simulator`, or `android-emulator` workflow when available.
- If a reload appears ineffective, check the app and bundler logs and confirm
  whether a native rebuild is needed before changing application code.

Radon's documentation lookup may send a query and dependency information to
Software Mansion. Follow the project's and user's data-handling requirements
before using it with private project details.
