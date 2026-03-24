---
name: sqlite
description: SQLite database patterns. Use for schema design, queries, migrations, and SQLite usage in mobile (Expo/RN) or backend contexts.
version: 1.0.0
---

# SQLite

## In React Native / Expo
Use `expo-sqlite` (v14+, new async API):
```ts
import * as SQLite from 'expo-sqlite'

const db = await SQLite.openDatabaseAsync('myapp.db')

// Migrations / schema
await db.execAsync(`
  CREATE TABLE IF NOT EXISTS items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    created_at INTEGER NOT NULL
  );
`)

// Query
const rows = await db.getAllAsync<Item>('SELECT * FROM items WHERE id = ?', [id])
const row = await db.getFirstAsync<Item>('SELECT * FROM items LIMIT 1')

// Insert / update
await db.runAsync('INSERT INTO items (name, created_at) VALUES (?, ?)', [name, Date.now()])

// Transaction
await db.withTransactionAsync(async () => {
  await db.runAsync('INSERT INTO items ...', [...])
  await db.runAsync('UPDATE other_table ...', [...])
})
```

## Schema Design
- Always use `INTEGER PRIMARY KEY` (implicit rowid alias — fastest lookup)
- Store dates as `INTEGER` (Unix ms) not TEXT
- Use `NOT NULL` constraints aggressively
- Add indexes for columns used in WHERE clauses

## Migrations
Track schema version in `PRAGMA user_version`:
```ts
const { user_version } = await db.getFirstAsync<{ user_version: number }>('PRAGMA user_version')
if (user_version < 1) {
  await db.execAsync('ALTER TABLE items ADD COLUMN description TEXT')
  await db.execAsync('PRAGMA user_version = 1')
}
```

## Performance
- Wrap bulk inserts in a transaction (10-100x faster)
- Use `PRAGMA journal_mode = WAL` for concurrent reads
- Use `EXPLAIN QUERY PLAN` to verify indexes are used
- Avoid `SELECT *` — select only needed columns

## CLI (debugging)
```bash
sqlite3 path/to/db.sqlite
.tables
.schema items
EXPLAIN QUERY PLAN SELECT * FROM items WHERE name = 'foo';
```
