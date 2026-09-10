"""Validate only the explicit, non-secret AI configuration sources (Python 3.11+)."""

import json
from pathlib import Path
import tomllib


DOTFILES = Path(__file__).resolve().parent.parent
JSON_FILES = (
    ".claude/settings.json",
    ".gemini/settings.json",
    "ai/.mcp.json",
    "ai/.gemini/settings.json",
    "ai/.agent/settings.json",
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
        assert "permissions" not in config
        assert "contextFileName" not in config
        assert "autoApproveSafeEdits" not in config.get("general", {})
    assert configs[".gemini/settings.json"]["general"]["defaultApprovalMode"] == "default"
    assert codex["approval_policy"] == "on-request"
    assert codex["sandbox_mode"] == "workspace-write"
    assert codex["sandbox_workspace_write"]["network_access"] is False
    assert "enabled" not in codex["mcp_servers"]["maestro"]

    servers = (
        configs["ai/.mcp.json"]["mcpServers"]["maestro"],
        configs[".gemini/settings.json"]["mcpServers"]["maestro"],
        codex["mcp_servers"]["maestro"],
    )
    for server in servers:
        assert server["command"] == "/opt/homebrew/bin/maestro"
        assert server["args"] == ["mcp"]
        assert server["env"] == {
            "JAVA_HOME": "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
        }
        assert not server.get("trust", False)
    assert "@AGENTS.md" in (DOTFILES / "ai/CLAUDE.md").read_text().splitlines()
    assert (DOTFILES / "ai/AGENTS.md").is_file()
    print("Instruction and Maestro configuration consistency OK")


if __name__ == "__main__":
    main()
