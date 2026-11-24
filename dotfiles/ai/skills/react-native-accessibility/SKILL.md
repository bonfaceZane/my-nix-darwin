---
name: react-native-accessibility
description: Review or implement accessibility for Expo and React Native mobile experiences, including screen-reader semantics, touch, text scaling, motion, and platform behavior. Use when accessibility is requested or an interactive mobile UI changes; not for web-only work.
---

# React Native mobile accessibility

Treat accessibility as part of completing the user flow, not a final pass that
adds labels. Follow the app's architecture and installed React Native/Expo
versions; iOS and Android expose similar concepts through different native
behavior.

## Implement for the people and tasks affected

- Read the app's instructions, SDK and React Native versions, UI components,
  navigation, and existing accessibility patterns before choosing APIs.
- Identify the changed user flow and relevant access modes: VoiceOver,
  TalkBack, switch or voice control, keyboard or external input where supported,
  text enlargement, contrast preferences, and reduced motion.
- Prefer platform and React Native controls with built-in accessibility
  behavior. Add custom semantics only to fill a demonstrated gap; do not add a
  dependency merely to follow a generic checklist.
- Keep the change focused. Scale the review to the affected flow and report
  platform-specific behavior instead of assuming iOS and Android are identical.

## Semantics and navigation

- Ensure interactive and meaningful elements expose an understandable name,
  role, and current state/value. Use visible text as the label where it already
  describes the control. Keep labels concise; add a hint only when the result of
  an action is not clear from its label.
- Describe informative images and custom content. Hide decorative imagery from
  assistive technology when the framework supports it.
- Keep screen-reader traversal aligned with the content's visual and logical
  order. Group related content when it improves understanding; do not merge a
  container in a way that hides independently useful controls.
- Make dialogs and sheets discoverable, operable, and dismissible with assistive
  technology. Preserve a logical return point after dismissal.
- Make validation errors, loading completion, and other important dynamic
  changes perceivable without repeatedly or assertively interrupting users.
- Provide an accessible alternative for actions otherwise available only via a
  custom gesture, drag, or swipe.
- Test localized labels and reading direction when the app supports multiple
  locales. Avoid hard-coded English accessibility text.

## Visual, touch, and cognitive access

- Support system text enlargement without clipping, truncation of essential
  information, or unusable layouts. Check larger accessibility text sizes on
  iOS and font/display scaling on Android.
- Do not use color as the only way to communicate status or meaning. Check text
  and control contrast against the project's applicable design or conformance
  target.
- Give touch controls comfortable hit areas and spacing. Apple recommends a
  44-by-44-point hit region for buttons; Android recommends at least 48-by-48
  dp for interactive targets. These are platform units and guidance, not
  interchangeable measurements. WCAG's CSS-pixel target-size criteria do not
  translate directly into native point/dp dimensions.
- Respect reduced-motion preferences and avoid flashing content. Do not make
  time limits or disappearing feedback the only way to complete or understand a
  flow unless the product requirement makes them essential; provide a workable
  alternative where possible.
- Use clear labels and instructions, explain errors with a recovery path, and
  preserve predictable navigation. Do not infer an individual's access needs
  from a diagnosis or disability category.

## Verify the affected flow

- Use automated checks and component tests where the project already supports
  them, but do not treat a passing test or static scanner as proof that native
  assistive technology can complete the flow.
- For live UI inspection, use `agent-device` with the applicable iOS or Android
  skill, following `expo-mobile`. Exercise the changed flow with VoiceOver or
  TalkBack and inspect its spoken labels, roles, states, focus order, and
  available actions. Check both platforms when their implementation or result
  can differ.
- Check text scaling, contrast-related settings, and reduced motion when they
  affect the change. Use platform accessibility inspectors or scanners as
  additional evidence, not substitutes for operating the app.
- Report the platform, access mode, flow, evidence, and remaining gaps. Do not
  claim a full accessibility audit or WCAG conformance from a narrow check.
- Follow the user's and project's testing policy. Do not add or run tests unless
  requested; report when device verification could not be performed.

## References

- [React Native accessibility](https://reactnative.dev/docs/accessibility)
- [Apple Human Interface Guidelines: Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)
- [Apple Human Interface Guidelines: Buttons](https://developer.apple.com/design/human-interface-guidelines/buttons)
- [Android: Make apps more accessible](https://developer.android.com/guide/topics/ui/accessibility/views/apps-views)
- [Android: Principles for improving app accessibility](https://developer.android.com/guide/topics/ui/accessibility/views/principles-views)
- [W3C: Guidance on Applying WCAG 2.2 to Mobile Applications](https://www.w3.org/TR/wcag2mobile-22/) — informative Group Draft Note, not a normative native-app conformance standard.
- [W3C: WCAG 2.2 Target Size (Minimum)](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum) — CSS-pixel criterion; do not substitute it for platform-native sizing guidance.
