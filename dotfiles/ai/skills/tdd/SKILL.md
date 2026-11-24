---
name: tdd
description: Use test-driven development when the user explicitly asks for TDD, test-first implementation, or a red-green-refactor workflow.
---

# Test-driven development

Adapted from Matt Pocock's [`tdd`](https://github.com/mattpocock/skills/blob/main/skills/engineering/tdd/SKILL.md) skill. Use this only for an explicit test-first request.

## Red, green, refactor

1. Read the project instructions, existing test setup, and behavior being
   changed. Choose the smallest public behavior seam that can demonstrate the
   requirement. For React Native, follow `react-native-testing` and `e2e-testing`
   when applicable.
2. Write one focused test for the requested behavior. Assert through the public
   interface and use a clear, independent expected result.
3. Run that test and confirm it fails for the intended reason. If it passes
   before the implementation or fails for unrelated setup, fix the test setup
   before proceeding.
4. Make the smallest implementation that passes. Avoid unrelated refactors or
   broad test additions.
5. Refactor only when it improves clarity without changing behavior, then run
   the focused test again. Run broader project checks when the user's request
   and project instructions call for them.

Use the project's current runner and package manager. Do not add a testing
framework or dependencies just to follow this workflow. If the project lacks a
usable test setup, explain the smallest option and get the user's direction
before adding one.

Source: [Matt Pocock's `tdd`](https://github.com/mattpocock/skills/blob/main/skills/engineering/tdd/SKILL.md), MIT-licensed.
