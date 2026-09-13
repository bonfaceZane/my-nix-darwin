"""Validate only the explicit, non-secret AI configuration sources (Python 3.11+)."""

import json
from pathlib import Path
import tomllib


DOTFILES = Path(__file__).resolve().parent.parent
JSON_FILES = (
    ".claude/settings.json",
    ".gemini/settings.json",
    ".cursor/mcp.json",
    ".cursor/settings.json",
    ".copilot/mcp-config.json",
    "ai/.mcp.json",
    "ai/.gemini/settings.json",
    "antigravity/mcp_config.json",
    "muse/settings.json",
    "opencode/opencode.json",
)

# Single canonical definition of the shared Maestro MCP server. Every client
# config below is checked against it, so a typo or drift fails here instead of
# silently disabling the server for one client.
MAESTRO = {
    "command": "/opt/homebrew/bin/maestro",
    "args": ["mcp"],
    "env": {
        "JAVA_HOME": "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home",
    },
}

# Transport is spelled differently per client, and Gemini does not require it at
# all. The value is the only legitimate difference between these definitions.
MAESTRO_CLIENT_TYPES = {
    "ai/.mcp.json": "stdio",
    ".cursor/mcp.json": "stdio",
    ".copilot/mcp-config.json": "local",
    ".gemini/settings.json": None,
}

# These manifests exist only for the shared server. A workspace-specific server
# (Nx, Radon, ...) must not be added globally; see AGENTS.md.
MAESTRO_MANIFESTS = (
    "ai/.mcp.json",
    ".cursor/mcp.json",
    ".copilot/mcp-config.json",
    ".gemini/settings.json",
)


def unique_keys(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"Duplicate JSON key: {key}")
        result[key] = value
    return result


def main():
    configs = {}
    for name in JSON_FILES:
        configs[name] = json.loads(
            (DOTFILES / name).read_text(), object_pairs_hook=unique_keys
        )
        print(f"JSON OK: dotfiles/{name}")

    codex = tomllib.loads((DOTFILES / ".codex/config.base.toml").read_text())
    print("TOML OK: dotfiles/.codex/config.base.toml")

    for name in (".gemini/settings.json", "ai/.gemini/settings.json"):
        config = configs[name]
        assert config["context"]["fileName"] == ["AGENTS.md", "GEMINI.md"]
        permissions = config.get("permissions", {})
        assert permissions.get("allow", []) == []
        assert permissions.get("ask", []) == []
        if permissions:
            for denied in ("Read(secrets.yaml)", "Read(.env*)", "Bash(sops:*)"):
                assert denied in permissions["deny"], f"Missing Gemini deny rule: {denied}"
        assert "contextFileName" not in config
        assert "autoApproveSafeEdits" not in config.get("general", {})
    assert configs[".gemini/settings.json"]["general"]["defaultApprovalMode"] == "default"
    assert codex["approval_policy"] == "on-request"
    assert codex["sandbox_mode"] == "workspace-write"
    assert codex["sandbox_workspace_write"]["network_access"] is False
    assert "enabled" not in codex["mcp_servers"]["maestro"]

    for name in MAESTRO_MANIFESTS:
        assert set(configs[name]["mcpServers"]) == {"maestro"}, (
            f"{name} must declare only the shared Maestro server"
        )

    for name, transport in MAESTRO_CLIENT_TYPES.items():
        expected = dict(MAESTRO)
        if transport is not None:
            expected["type"] = transport
        assert configs[name]["mcpServers"]["maestro"] == expected, (
            f"{name} Maestro definition drifted from MAESTRO"
        )

    assert codex["mcp_servers"]["maestro"] == MAESTRO, (
        "Codex Maestro definition drifted from MAESTRO"
    )
    assert "@AGENTS.md" in (DOTFILES / "ai/CLAUDE.md").read_text().splitlines()
    assert (DOTFILES / "ai/AGENTS.md").is_file()
    print("Instruction and Maestro configuration consistency OK")


if __name__ == "__main__":
    main()
