---
name: eas
description: EAS Build and EAS Update for deploying amv-apps to iOS and Android. Use for builds, OTA updates, and release management.
version: 1.0.0
---

# EAS Build & Update

## Build
```bash
# Build for a specific app and platform
eas build --platform=ios --profile=development
eas build --platform=android --profile=production

# Or via fish function
build ios development
build android production
```

## Profiles (eas.json)
- `development` — dev client build for local testing
- `qa` — internal QA distribution
- `acc` — acceptance / staging
- `production` — App Store / Play Store

## OTA Updates (Expo Updates)
```bash
# Push an OTA update (no app store review needed)
eas update --branch=main --message="fix: crash on login"

# Update for a specific channel
eas update --branch=production
```

OTA updates only work for JS bundle changes. Native code changes require a full build.

## Environment Management
Expo uses `.env.development`, `.env.qa`, `.env.acc`, `.env.production`. Switch via mise:
```bash
mise run dev        # development
mise run e2e-ios    # E2E with specific env
```

## Submitting to stores
```bash
eas submit --platform=ios --latest
eas submit --platform=android --latest
```

## Checking build status
```bash
eas build:list
eas build:view [BUILD_ID]
```

## Common Issues
- `Invalid credentials` — run `eas login`
- iOS provisioning errors — run `eas credentials` to manage profiles/certs
- Build cache stale — add `--clear-cache` flag
- Version mismatch — bump `version` in app.json and `versionCode`/`buildNumber`

## Key files
- `eas.json` — build profiles
- `app.json` / `app.config.ts` — Expo config, versioning
- `expo-updates` channel maps to EAS branches
