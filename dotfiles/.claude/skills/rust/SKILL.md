---
name: rust
description: Rust development. Use for systems code, CLI tools, WebAssembly, or native modules written in Rust.
version: 1.0.0
---

# Rust

## Environment
- Rust latest via mise
- Clippy and rustfmt available
- Helix configured with rust-analyzer and clippy formatter

## Key Patterns

### Error handling — use `?` and `thiserror`
```rust
use thiserror::Error;

#[derive(Error, Debug)]
enum AppError {
  #[error("not found: {0}")]
  NotFound(String),
  #[error(transparent)]
  Io(#[from] std::io::Error),
}

fn do_thing() -> Result<String, AppError> {
  let content = std::fs::read_to_string("file.txt")?;
  Ok(content)
}
```

### Async — use Tokio
```rust
#[tokio::main]
async fn main() -> anyhow::Result<()> {
  let result = fetch_data().await?;
  Ok(())
}
```

### Ownership patterns
- Clone sparingly — prefer references
- Use `Arc<Mutex<T>>` for shared mutable state across threads
- Use `Rc<RefCell<T>>` for single-threaded shared mutation

### Iterators over loops
```rust
let total: u32 = items.iter()
  .filter(|i| i.active)
  .map(|i| i.value)
  .sum();
```

### Structs and traits
```rust
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
struct Item {
  id: u32,
  name: String,
}

impl Display for Item {
  fn fmt(&self, f: &mut Formatter) -> fmt::Result {
    write!(f, "Item({})", self.name)
  }
}
```

## Commands
```bash
cargo build
cargo test
cargo clippy -- -D warnings   # treat warnings as errors
cargo fmt
cargo run -- --arg value
```

## Common crates
- `anyhow` / `thiserror` — error handling
- `tokio` — async runtime
- `serde` / `serde_json` — serialization
- `clap` — CLI argument parsing
- `reqwest` — HTTP client
- `sqlx` — async SQL
