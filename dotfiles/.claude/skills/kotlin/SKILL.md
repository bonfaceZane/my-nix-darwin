---
name: kotlin
description: Kotlin and Android native development. Use for native Android modules, Gradle, Jetpack Compose, and Android-specific work.
version: 1.0.0
---

# Kotlin / Android

## Environment
- Java 17 via mise (required for modern Android tooling)
- Android SDK at `~/Library/Android/sdk`
- `ANDROID_HOME` and `ANDROID_SDK_ROOT` set in shell
- ADB and platform-tools in PATH

## Key Patterns

### Coroutines
Always use coroutines over threads:
```kotlin
viewModelScope.launch {
  val result = withContext(Dispatchers.IO) { api.fetchData() }
  _uiState.value = result
}
```

### React Native Native Modules (Kotlin)
New Architecture (TurboModules):
```kotlin
class MyModule(reactContext: ReactApplicationContext) :
    NativeMyModuleSpec(reactContext) {
  override fun getName() = NAME
  companion object { const val NAME = "MyModule" }
}
```

### Jetpack Compose
Prefer Compose for new UI. Use `remember` and `derivedStateOf` carefully to avoid recomposition:
```kotlin
@Composable
fun MyScreen(viewModel: MyViewModel = hiltViewModel()) {
  val state by viewModel.uiState.collectAsStateWithLifecycle()
  // ...
}
```

### Expo Native Module (Kotlin side)
```kotlin
class MyModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("MyModule")
    Function("doSomething") { ... }
  }
}
```

### Useful commands
```bash
# List connected devices/emulators
adb devices

# Install APK
adb install app-debug.apk

# Logcat filtered
adb logcat -s ReactNativeJS

# Gradle build
./gradlew assembleDebug
./gradlew test
```

## Common Issues
- Gradle daemon stale: `./gradlew --stop`
- SDK not found: check `ANDROID_HOME` is set
- Java version mismatch: verify `java -version` returns 17
