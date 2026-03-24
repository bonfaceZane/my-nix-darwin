---
name: react-native-skills
description: React Native and Expo best practices for building performant mobile apps. Use when building React Native components, optimizing list performance, implementing animations, or working with native modules. Triggers on tasks involving React Native, Expo, mobile performance, or native platform APIs.
license: MIT
metadata:
  author: vercel
  version: '1.0.0'
---

# React Native Skills

Comprehensive best practices for React Native and Expo applications. Contains
rules across multiple categories covering performance, animations, UI patterns,
and platform-specific optimizations.

## When to Apply

Reference these guidelines when:

- Building React Native or Expo apps
- Optimizing list and scroll performance
- Implementing animations with Reanimated
- Working with images and media
- Configuring native modules or fonts
- Structuring monorepo projects with native dependencies

## Rule Categories by Priority

| Priority | Category         | Impact   | Prefix               |
| -------- | ---------------- | -------- | -------------------- |
| 1        | List Performance | CRITICAL | `list-performance-`  |
| 2        | Animation        | HIGH     | `animation-`         |
| 3        | Navigation       | HIGH     | `navigation-`        |
| 4        | UI Patterns      | HIGH     | `ui-`                |
| 5        | State Management | MEDIUM   | `react-state-`       |
| 6        | Rendering        | MEDIUM   | `rendering-`         |
| 7        | Monorepo         | MEDIUM   | `monorepo-`          |
| 8        | Configuration    | LOW      | `fonts-`, `imports-` |

## Quick Reference

### 1. List Performance (CRITICAL)

- Use **FlashList** (`@shopify/flash-list`) instead of FlatList for large lists
- Memoize list item components with `React.memo`
- Stabilize callback references with `useCallback`
- Avoid inline style objects in list items
- Extract functions outside render to prevent re-creation
- Optimize images in lists (use `expo-image`)
- Move expensive work outside list items
- Use item types for heterogeneous lists via `getItemType`

### 2. Animation (HIGH)

- Animate only `transform` and `opacity` properties (GPU-composited)
- Use `useDerivedValue` for computed animations instead of `useAnimatedStyle` chains
- Use `Gesture.Tap` instead of `Pressable` inside `GestureDetector`
- Prefer Reanimated v3 `useSharedValue` + `useAnimatedStyle`
- Never directly mutate shared values inside `useAnimatedStyle`

### 3. Navigation (HIGH)

- Use **native stack** (`@react-navigation/native-stack`) over JS stack
- Use **native tabs** (Expo Router `NativeTabs` or `@react-navigation/bottom-tabs` with native) over JS tabs
- Always type screen params with a `ParamList`

### 4. UI Patterns (HIGH)

- Use `expo-image` for all images (better performance, caching, SF Symbols)
- Use `expo-image` for image galleries / lightboxes
- Use `Pressable` over `TouchableOpacity`
- Handle safe areas in ScrollViews with `contentInsetAdjustmentBehavior="automatic"`
- Use `contentInset` for headers overlapping scroll content
- Use native context menus when possible
- Use native modals when possible (`presentation: "modal"` in Expo Router)
- Use `onLayout` to measure views, not `measure()`
- Use `StyleSheet.create` or Nativewind for styling — no arbitrary inline objects

### 5. State Management (MEDIUM)

- Minimize state subscriptions (select only needed slices)
- Use dispatcher pattern for passing callbacks down component trees
- Show fallback/skeleton on first render before data loads
- Destructure props for React Compiler compatibility
- Handle Reanimated shared values carefully with React Compiler

### 6. Rendering (MEDIUM)

- Always wrap text strings in `<Text>` components
- Avoid falsy `&&` for conditional rendering — use ternary instead:
  ```tsx
  // Bad: {count && <Badge />}  — renders "0" when count is 0
  // Good: {count > 0 && <Badge />}  or  {count ? <Badge /> : null}
  ```

### 7. Monorepo (MEDIUM)

- Keep native dependencies in the app package, not shared packages
- Use single dependency versions across packages (hoisting)

### 8. Configuration (LOW)

- Use config plugins for custom fonts (`expo-font` config plugin)
- Organize design system imports in a dedicated folder (`ui/`, `design-system/`)
- Hoist `Intl` object creation outside component render functions
