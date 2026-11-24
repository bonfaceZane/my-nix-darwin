---
name: storybook-stories
description: Author and update React Native Storybook stories with complete controls, notes, backgrounds, actions, state coverage, accessibility, and agent-device visual verification.
---

# React Native Storybook Stories

Use this skill for every React Native Storybook story creation or update. Read the project's `AGENTS.md`, inspect its Storybook configuration, installed addons, component API, and nearby stories before editing. Follow the project's supported React Native Storybook APIs; do not assume web Storybook behavior applies unchanged.

## Required checklist

Audit every exported story in the changed file. A story change is incomplete until every applicable item below passes. Do not skip an applicable item because a nearby story omits it. For any inapplicable item, be able to give a concrete reason in the final summary.

### Controls

- Exploratory or configurable stories MUST use typed args and expose each meaningful user-adjustable prop through Controls.
- Enum controls MUST list valid values. Booleans, text, and numbers MUST use suitable control types.
- Exclude callbacks, internal state, and implementation-only props from Controls.
- Static examples may omit Controls only when their purpose is to show a fixed state. When meaningful props warrant exploration, include a separate interactive story.
- Every control MUST affect the rendered example; remove inert controls.

### Notes

- Every component story MUST include useful Markdown `parameters.notes` at meta or story level. Omit notes only for a self-explanatory primitive with no meaningful setup, variants, interaction, or usage constraints, and state why.
- Notes MUST describe the component's purpose and relevant setup, variants, interaction, and usage constraints. Keep notes aligned with the current API; generic placeholders do not pass.
- Prefer shared meta-level notes and add story-level notes for details unique to one example.

### Backgrounds

- Provide a relevant background choice whenever the surrounding surface can materially affect contrast, visibility, or interpretation, including transparent components and theme/surface comparisons.
- Inspect the project's preview and decorators first. Use its existing background mechanism when suitable; otherwise use the installed React Native backgrounds addon's supported API.
- Choose named, meaningful backgrounds. Do not add arbitrary or duplicate background options.
- If changing the surrounding surface cannot affect how the component appears or is understood, omit backgrounds and be ready to explain why.

### Actions

- Stories demonstrating user interaction MUST log each meaningful user-triggered callback through the installed Storybook Actions API.
- Controlled stories MUST update local state and log the emitted value in the same callback. Actions do not replace state updates or change component behavior.
- Do not log render-time callbacks, internal setters, or callbacks unrelated to the example.

### State coverage

- Include examples or Controls for every materially different user-visible state supported by the component API. Check selected/unselected, enabled/disabled, loading, error, empty, and long-content states where supported.
- Every covered state MUST be directly visible or reachable through a clearly named control. Hidden or unreachable states do not count.
- Add boundary content when it can reveal truncation, wrapping, clipping, or overflow. Do not invent unsupported props or redundant states.

### Accessibility

- Interactive examples MUST provide meaningful accessible names and expose the component's actual role and state to assistive technology.
- Keep visible and spoken labels aligned. Add a custom accessibility label only when it conveys a meaningful distinction.
- Include accessibility-relevant states such as selected, disabled, and invalid whenever the component supports them.
- Inspect the component's accessibility implementation; visible text alone is not proof of accessibility.

### Visual verification with agent-device

- For every new story and every material visual/layout/state change, use the `agent-device` CLI to open the app, navigate to the affected stories, and inspect both screenshots and the accessibility hierarchy.
- Load the global `agent-device` skill and the applicable `ios-simulator` or `android-emulator` skill before device interaction. Use the project's documented build and Storybook launch commands.
- Check both platforms when behavior or layout may differ by platform; otherwise check at least one available platform.
- Static source inspection, a Jest render, a web preview, or a Metro reload alone does not satisfy native visual verification.
- If `agent-device` is unavailable, stop and ask the user to expose the existing installation or install it. Do not install, upgrade, or invoke a mutable `npx` version autonomously.
- If the simulator/emulator, build, or Storybook launch is unavailable, state the exact limitation and do not claim the story was visually verified.
- Use the project's E2E runner for repeatable automated flows where configured. E2E automation does not replace the required `agent-device` visual inspection for a story/UI change.

## Native Storybook tooling and MCP

- Before adding an addon, agent skill, or MCP integration, confirm it supports the project's exact Storybook version and the native `@storybook/react-native` renderer. Read the installed package documentation and peer dependency range; do not infer native support from React Native Web or browser Storybook support.
- Treat external Storybook skills as references unless their framework and version support explicitly includes this native setup. Keep this project-appropriate workflow authoritative and avoid adding overlapping instructions that conflict with it.
- Consider Storybook's MCP addon only when a concrete agent workflow benefits from querying a running Storybook instance, and only after verifying compatibility with the installed React Native Storybook version. MCP requires the Storybook dev server; it does not drive or visually inspect a native simulator, so it never replaces `agent-device`. Do not install addons or configure an MCP server unless the user requests that integration.
- Check the current official [Storybook AI integration docs](https://storybook.js.org/docs/ai/connect) and [MCP docs](https://storybook.js.org/docs/ai/mcp/overview), but treat framework support tables and package compatibility as version-specific.

## Repeatable visual regression

- For important stories that need ongoing regression coverage, consider a small Maestro screenshot flow that opens stable Storybook story IDs, waits for animations to settle, and captures a curated set on fixed simulator configurations. The project already uses Maestro; prefer extending its established setup over introducing a second E2E runner.
- Review image diffs before accepting new baselines. Keep the baseline set focused; do not require a screenshot baseline for every story by default.
- Automated screenshot flows complement, but do not replace, the required `agent-device` inspection of new or materially changed stories. The [React Native Storybook testing guide](https://storybookjs.github.io/react-native/docs/intro/testing/) documents the current native visual-testing options; verify guidance against the installed version before changing configuration.

## Completion gate

Before finishing, audit every exported story against all six categories above: controls, notes, backgrounds, actions, state coverage, and accessibility; also complete required visual verification. Run the focused formatter and project type-check whenever Storybook TypeScript or metadata changes. Run tests according to project guidance and the user's request. Report each validation and any unperformed check honestly.
