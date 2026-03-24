---
name: zig
description: Zig language development. Use for systems programming, build scripts, C interop, and Zig modules.
version: 1.0.0
---

# Zig

## Environment
- Zig latest via mise
- LLVM installed (for linking)

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

## Common patterns
- Use `std.debug.print` for debugging (not `std.log` unless you need log levels)
- Use `@import("std")` — standard library is comprehensive
- `defer` aggressively for cleanup
