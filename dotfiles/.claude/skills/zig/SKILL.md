---
name: zig
description: Zig language development. Use for systems programming, build scripts, C interop, and Zig modules.
version: 1.0.0
---

# Zig

## Environment
- Zig latest via mise
- LLVM installed (for linking)

## Naming Conventions

| Thing | Convention | Example |
|-------|-----------|---------|
| Variables, fields, parameters | `snake_case` | `my_var`, `packet_count` |
| Functions | `camelCase` | `readBytes()`, `parseHeader()` |
| Types (structs, enums, unions, opaques) | `PascalCase` | `HttpRequest`, `TokenKind` |
| Comptime functions returning types | `PascalCase` | `ArrayList(T)` |
| Constants | `snake_case` | `max_size`, `default_port` |
| Enum fields | `snake_case` | `.not_found`, `.ok` |
| Namespaces / file modules | `snake_case` | `std.mem`, `std.fs` |

- Acronyms follow the surrounding case: `HttpServer` not `HTTPServer`, `parseUrl` not `parseURL`
- Abbreviations are fine when universally understood: `buf`, `len`, `idx`, `alloc`

## Key Patterns

### Build system
Zig uses `build.zig` — no separate Makefile needed:
```bash
zig build          # build
zig build test     # run tests
zig build run      # build and run
```

### Error handling — explicit, no exceptions
```zig
const result = try someFunction();  // propagates error
const result2 = someFunction() catch |err| { ... };
const result3 = someFunction() catch defaultValue;
```

### Memory — manual, no GC
```zig
const allocator = std.heap.page_allocator;
const buf = try allocator.alloc(u8, 1024);
defer allocator.free(buf);  // always defer free
```
Prefer `std.heap.ArenaAllocator` for request-scoped or batch allocations.

### Comptime
Use `comptime` for zero-cost generics and compile-time computation:
```zig
fn add(comptime T: type, a: T, b: T) T {
  return a + b;
}
```

### C interop
```zig
const c = @cImport({
  @cInclude("stdio.h");
});
c.printf("hello\n");
```

### Optionals
```zig
var maybe: ?i32 = null;
if (maybe) |value| { ... }
const val = maybe orelse 0;
```

### Testing
```zig
test "my test" {
  try std.testing.expectEqual(4, add(i32, 2, 2));
}
```
Run with `zig build test` or `zig test src/main.zig`.

## httpz Backend Folder Structure

For httpz-based backends, use this layout under `src/`:

```
src/
├── main.zig              # server init, calls router.registerRoutes
├── config.zig            # typed config loaded from env vars at startup
├── root.zig              # lib root (keep for library builds)
│
├── app/
│   ├── router.zig        # all route registrations in one place
│   ├── middleware/       # httpz middleware (logger, auth, etc.)
│   └── handlers/         # thin: parse request → call service → write response
│
├── db/                   # raw SQL queries only, no business logic
│   └── sqlite.zig
│
├── models/               # plain data structs, serialization, validation
│   └── user.zig
│
└── services/             # business logic: calls db/, returns models/
    └── user_service.zig
```

**Rules:**
- `handlers/` are thin — no SQL, no business logic
- `services/` own business logic and call `db/` directly
- `models/` are pure structs — no db or httpz imports
- `config.zig` is the only place that reads env vars
- `router.zig` keeps `main.zig` clean as routes grow

## Common patterns
- Use `std.debug.print` for debugging (not `std.log` unless you need log levels)
- Use `@import("std")` — standard library is comprehensive
- `defer` aggressively for cleanup
