---
name: swift
description: Swift and iOS native development. Use for native iOS modules, Swift Package Manager, UIKit/SwiftUI, and Xcode project work.
version: 1.0.0
---

# Swift / iOS

## Environment
- Java 17 and LLVM installed via mise
- Fastlane available for deployment automation
- Target: iOS (amv-apps uses Expo-managed native layer)

## Key Patterns

### SwiftUI vs UIKit
- Prefer SwiftUI for new screens
- UIKit for RN native modules (use `RCTBridgeModule` or the new JSI/TurboModule API)

### React Native Native Modules (Swift)
New Architecture (TurboModules):
```swift
@objc(MyModule)
class MyModule: NSObject, RCTBridgeModule {
  static func moduleName() -> String { "MyModule" }
  // ...
}
```

### Async/Await
Prefer `async/await` over completion handlers. Use `Task { }` to bridge from sync context.

### Error handling
```swift
do {
  let result = try await someAsyncCall()
} catch let error as MyError {
  // handle
} catch {
  // fallback
}
```

### Swift Package Manager
```bash
# Add dependency in Xcode: File > Add Package Dependencies
# Or edit Package.swift directly
swift build
swift test
```

### Useful commands
```bash
# Build for simulator
xcodebuild -scheme MyApp -destination 'platform=iOS Simulator,name=iPhone 16'

# Run tests
xcodebuild test -scheme MyApp -destination 'platform=iOS Simulator,name=iPhone 16'

# List simulators
xcrun simctl list devices
```

## Expo Native Module (Swift side)
When adding Expo modules, use `expo-modules-core`:
```swift
import ExpoModulesCore

public class MyModule: Module {
  public func definition() -> ModuleDefinition {
    Name("MyModule")
    Function("doSomething") { ... }
  }
}
```
