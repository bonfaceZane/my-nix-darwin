---
name: expo-react-native
description: Expo + React Native development for the amv-apps monorepo. Use for RN component work, native modules, navigation, and platform-specific code.
version: 1.0.0
---

# Expo React Native

## Stack
- React Native 0.79.5, React 19, Expo v53
- Hermes JS engine (default)
- New Architecture enabled on autotrack
- iOS + Android targets
- Yarn Workspaces monorepo at `~/Documents/work/amv-apps`

## Apps
- `gaspedaal` — Gaspedaal.nl car trading platform
- `autotrack` — AutoTrack.nl vehicle tracking

## Key Patterns

### Running apps
```bash
yarn gaspedaal ios --device='iPhone Air'
yarn autotrack android
```
Or use the `run` fish function: `run gaspedaal ios`

### Prebuild (native code generation)
```bash
yarn gaspedaal prebuild --clean
```
Or use: `prebuild gaspedaal`

### Navigation
Uses React Navigation (native-stack, bottom-tabs). Always type screen params with a `ParamList`.

### Styling
Use StyleSheet.create — no inline styles. Linear gradients via `expo-linear-gradient`. Animations via Reanimated v3.

### Lists
Use `@shopify/flash-list` instead of FlatList for performance.

### New Architecture (autotrack only)
- Fabric renderer and TurboModules enabled
- Use `useAnimatedStyle` carefully — no direct mutation
- Avoid legacy `findNodeHandle`

### Platform-specific code
```ts
import { Platform } from 'react-native'
Platform.select({ ios: ..., android: ... })
// or file extensions: Component.ios.tsx / Component.android.tsx
```

### Secure storage
Use `expo-secure-store` for sensitive data, never AsyncStorage for secrets.

## Common Issues
- Metro cache stale: `watchman watch-del-all && yarn start --reset-cache`
- Pod issues: `cd apps/gaspedaal/ios && pod install`
- Hermes bytecode mismatch: clean prebuild
