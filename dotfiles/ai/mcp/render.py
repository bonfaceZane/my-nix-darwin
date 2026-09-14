#!/usr/bin/env python3
"""Render and check the shared MCP server set in every client config.

`servers.json` next to this file is the single source of truth. `--write` applies
it to each client (client-specific servers and UI state are preserved), `--check`
reports drift without touching anything. `dotfiles/ai/validate.py` calls `check()`
so a dropped or mistyped server fails validation instead of silently disappearing
from one client.

Usage:
    python3 dotfiles/ai/mcp/render.py --check
    python3 dotfiles/ai/mcp/render.py --write
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

MCP_DIR = Path(__file__).resolve().parent
DOTFILES = MCP_DIR.parent.parent
CONFIG = MCP_DIR / "servers.json"

# Keys a client persists for its own UI; they carry no launch meaning and are
# preserved rather than rendered.
CLIENT_ONLY_KEYS = frozenset(
    {"autoApprove", "alwaysAllow", "timeout", "gallery", "version"}
)


def load_config() -> dict:
    return json.loads(CONFIG.read_text())


CONFIG_DATA = load_config()
SERVERS: dict = CONFIG_DATA["servers"]
PRIMARY: str = CONFIG_DATA["primary"]
EXPO_CRITICAL_TOOLS: tuple = tuple(CONFIG_DATA["expoCriticalTools"])

# Every client that receives the shared set. `remote` is None where the client's
# remote-server schema is unverified (Zed, Antigravity) or unenforceable
# (opencode), so the Expo server is deliberately not rendered there.
CLIENTS: dict = {
    "ai/.mcp.json": {
        "attribute": "mcpServers",
        "flavour": "plain",
        "remote": ("url", "http"),
        "context7": True,
    },
    ".cursor/mcp.json": {
        "attribute": "mcpServers",
        "flavour": "plain",
        "remote": ("url", "http"),
        "context7": True,
    },
    ".gemini/settings.json": {
        "attribute": "mcpServers",
        "flavour": "gemini",
        "remote": ("httpUrl", None),
        "context7": True,
    },
    ".copilot/mcp-config.json": {
        "attribute": "mcpServers",
        "flavour": "copilot",
        "remote": ("url", "http"),
        "context7": True,
    },
    "ai/dotfiles/cline/mcp.json": {
        "attribute": "mcpServers",
        "flavour": "cline",
        "remote": ("url", "streamableHttp"),
        "context7": True,
    },
    "antigravity/mcp_config.json": {
        "attribute": "mcpServers",
        "flavour": "plain",
        "remote": None,
        "context7": True,
    },
    "vscode/mcp.json": {
        "attribute": "servers",
        "flavour": "plain",
        "remote": ("url", "http"),
        # VS Code manages context7 through its own gallery entry with a pinned
        # version and an ${input:...} API key, so it is left untouched.
        "context7": False,
    },
    "zed/settings.json": {
        "attribute": "context_servers",
        "flavour": "zed",
        "remote": None,
        "context7": True,
    },
    "opencode/opencode.json": {
        "attribute": "mcp",
        "flavour": "opencode",
        "remote": None,
        "context7": True,
    },
}


def ordered_server_names() -> list:
    """Managed servers with the primary first, so every client lists it first."""
    return [PRIMARY] + sorted(name for name in SERVERS if name != PRIMARY)


def render_entry(name: str, flavour: str, remote) -> dict:
    definition = SERVERS[name]
    if remote is not None and "url" in definition:
        key, remote_type = remote
        entry = {key: definition["url"]}
        if remote_type:
            entry["type"] = remote_type
        if flavour == "gemini":
            entry["trust"] = False
            entry["excludeTools"] = list(EXPO_CRITICAL_TOOLS)
        return entry

    args = list(definition.get("args", []))
    env = dict(definition.get("env", {}))
    if flavour == "opencode":
        entry = {
            "type": "local",
            "enabled": True,
            "command": [definition["command"], *args],
        }
        if env:
            entry["environment"] = env
        return entry
    entry = {"command": definition["command"], "args": args}
    if env:
        entry["env"] = env
    if flavour == "plain":
        return {"type": "stdio", **entry}
    if flavour == "copilot":
        return {"type": "local", **entry}
    if flavour == "cline":
        return {"type": "stdio", **entry, "disabled": False, "autoApprove": []}
    return entry


def launch_fields(entry: dict, flavour: str) -> dict:
    """The subset of a client entry that the root config owns."""
    if flavour == "opencode":
        command, *args = entry.get("command", [])
        fields = {"command": command, "args": args}
        if entry.get("environment"):
            fields["env"] = entry["environment"]
        return fields
    return {
        key: value
        for key, value in entry.items()
        if key not in CLIENT_ONLY_KEYS and key not in {"disabled", "enabled", "remote"}
    }


def merge_entry(name: str, flavour: str, remote, existing: dict | None) -> dict:
    """Rendered launch fields on top of whatever the client had, extras intact."""
    merged = dict(existing or {})
    merged.update(render_entry(name, flavour, remote))
    return merged


def check() -> list:
    """Return a list of drift problems; empty means every client matches."""
    problems = []
    for relative, spec in CLIENTS.items():
        document = json.loads((DOTFILES / relative).read_text())
        servers = document.get(spec["attribute"], {})
        for name in ordered_server_names():
            if name == "context7" and not spec["context7"]:
                if "context7" not in servers and "io.github.upstash/context7" not in servers:
                    problems.append(f"{relative}: context7 is missing")
                continue
            if name == "expo" and spec["remote"] is None:
                if "expo" in servers:
                    problems.append(
                        f"{relative}: expo must not be registered "
                        "(no verified per-tool control)"
                    )
                continue
            if name not in servers:
                problems.append(f"{relative}: {name} is missing")
                continue
            expected = launch_fields(
                render_entry(name, spec["flavour"], spec["remote"]), spec["flavour"]
            )
            actual = launch_fields(servers[name], spec["flavour"])
            if actual != expected:
                problems.append(
                    f"{relative}: {name} drifted\n    expected {expected}"
                    f"\n    actual   {actual}"
                )
        first = next(iter(servers), None)
        if first is not None and first != PRIMARY and PRIMARY in servers:
            # Cosmetic only: client UIs rewrite their own files in their own order,
            # so primacy is not enforced here. `--write` still places the primary
            # server first, and AGENTS.md carries the behavioural instruction.
            pass
    return problems


def detect_indent(text: str) -> str:
    """Reuse the file's own indentation so rewrites stay small."""
    match = re.search(r"\n([ \t]+)\S", text)
    return match.group(1) if match else "  "


def write(dry_run: bool = False) -> list:
    """Apply the root config to every client. Returns the files changed."""
    changed = []
    for relative, spec in CLIENTS.items():
        path = DOTFILES / relative
        original = path.read_text()
        document = json.loads(original)
        servers = document.get(spec["attribute"], {})
        updated = {}
        for name in ordered_server_names():
            if name == "expo" and spec["remote"] is None:
                continue
            if name == "context7" and not spec["context7"]:
                continue
            updated[name] = merge_entry(
                name, spec["flavour"], spec["remote"], servers.get(name)
            )
        for name, entry in servers.items():
            if name not in updated:
                updated[name] = entry
        if servers == updated and list(servers) == list(updated):
            continue
        changed.append(relative)
        if dry_run:
            continue
        document[spec["attribute"]] = updated
        path.write_text(
            json.dumps(document, indent=detect_indent(original), ensure_ascii=False)
            + "\n"
        )
    return changed


def main() -> int:
    arguments = sys.argv[1:]
    if "--write" in arguments or "--dry-run" in arguments:
        dry_run = "--write" not in arguments
        changed = write(dry_run=dry_run)
        verb = "would rewrite" if dry_run else "rewritten"
        print(f"{verb}:", ", ".join(changed) if changed else "nothing to change")
        return 0
    problems = check()
    for problem in problems:
        print(f"MCP DRIFT: {problem}")
    if problems:
        return 1
    print(f"MCP config OK: {len(CLIENTS)} clients match {CONFIG.name}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
