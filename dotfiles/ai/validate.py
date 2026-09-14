"""Validate only the explicit, non-secret AI configuration sources (Python 3.11+)."""

import importlib.util
import json
import sys
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
    "ai/dotfiles/cline/mcp.json",
    "muse/settings.json",
    "opencode/opencode.json",
    "vscode/mcp.json",
    "vscode/settings.json",
    "zed/settings.json",
)

# VS Code settings files are JSONC: they legitimately contain comments.
JSONC_FILES = ("vscode/settings.json",)

# The shared MCP server set (definitions, primary server, Expo policy) lives in
# dotfiles/ai/mcp/servers.json and is rendered and checked by dotfiles/ai/mcp/
# render.py. This validator delegates that check and reads the canonical
# definitions from the same place, so there is exactly one source of truth for
# every client's servers.
_RENDER_PATH = Path(__file__).resolve().parent / "mcp" / "render.py"
# Importing the renderer must not litter the dotfiles tree with bytecode caches.
sys.dont_write_bytecode = True
_RENDER_SPEC = importlib.util.spec_from_file_location("mcp_render", _RENDER_PATH)
render = importlib.util.module_from_spec(_RENDER_SPEC)
_RENDER_SPEC.loader.exec_module(render)

EXPO_CRITICAL_TOOLS = render.EXPO_CRITICAL_TOOLS
CANONICAL_SERVERS = render.SERVERS
PRIMARY_SERVER = render.PRIMARY


def unique_keys(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"Duplicate JSON key: {key}")
        result[key] = value
    return result


def load_jsonc(path):
    """Parse JSON with `//` and `/* */` comments (VS Code settings style)."""
    text = path.read_text()
    out = []
    index = 0
    in_string = False
    escaped = False
    length = len(text)
    while index < length:
        char = text[index]
        if in_string:
            out.append(char)
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            index += 1
            continue
        if char == '"':
            in_string = True
            out.append(char)
            index += 1
            continue
        if char == "/" and index + 1 < length and text[index + 1] == "/":
            while index < length and text[index] != "\n":
                index += 1
            continue
        if char == "/" and index + 1 < length and text[index + 1] == "*":
            index += 2
            while index + 1 < length and not (
                text[index] == "*" and text[index + 1] == "/"
            ):
                index += 1
            index += 2
            continue
        out.append(char)
        index += 1
    return json.loads("".join(out), object_pairs_hook=unique_keys)


def main():
    configs = {}
    for name in JSON_FILES:
        if name in JSONC_FILES:
            configs[name] = load_jsonc(DOTFILES / name)
        else:
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
                assert denied in permissions["deny"], (
                    f"Missing Gemini deny rule: {denied}"
                )
        assert "contextFileName" not in config
        assert "autoApproveSafeEdits" not in config.get("general", {})
    assert configs[".gemini/settings.json"]["general"]["defaultApprovalMode"] == "default"

    cline_servers = configs["ai/dotfiles/cline/mcp.json"]["mcpServers"]
    assert cline_servers["maestro"]["disabled"] is False, (
        "Cline Maestro must not be disabled"
    )
    assert cline_servers["maestro"].get("alwaysAllow", []) == [], (
        "Cline Maestro must not auto-approve tools"
    )
    for name, entry in cline_servers.items():
        assert entry.get("autoApprove", []) == [], f"Cline {name} must not auto-approve"

    assert codex["approval_policy"] == "on-request"
    assert codex["sandbox_mode"] == "workspace-write"
    assert codex["sandbox_workspace_write"]["network_access"] is False
    assert "enabled" not in codex["mcp_servers"]["maestro"]
    assert codex["mcp_servers"]["maestro"] == CANONICAL_SERVERS["maestro"], (
        "Codex Maestro definition drifted from the canonical definition"
    )
    # The Codex seed disables sandbox network access, so npm-backed servers
    # (mobile-mcp, ios-simulator, context7) and the remote Expo server are
    # configured in the live CODEX_HOME instead of the seed.
    assert set(codex["mcp_servers"]) == {"maestro"}, (
        "Codex seed must declare only Maestro; use the live config for npm servers"
    )

    # Every client config is rendered from dotfiles/ai/mcp/servers.json; drift is a
    # failure here rather than a server that silently stops working in one client.
    problems = render.check()
    assert not problems, "MCP configuration drift:\n  " + "\n  ".join(problems)

    # Expo restriction policy. A missing rule must fail here rather than quietly
    # handing a client the ability to spend compute or publish to a store.
    claude_permissions = configs[".claude/settings.json"]["permissions"]
    for tool in EXPO_CRITICAL_TOOLS:
        rule = f"mcp__expo__{tool}"
        assert rule in claude_permissions["deny"], f"Claude must deny {rule}"
    assert "mcp__expo" in claude_permissions["ask"], (
        "Claude must require approval for every non-denied expo tool"
    )

    gemini_expo = configs[".gemini/settings.json"]["mcpServers"]["expo"]
    assert gemini_expo.get("trust") is False, (
        "Gemini must not trust the expo server (trust bypasses tool prompts)"
    )
    assert set(EXPO_CRITICAL_TOOLS) <= set(gemini_expo.get("excludeTools", [])), (
        "Gemini excludeTools is missing critical expo tools"
    )

    vscode_settings = configs["vscode/settings.json"]
    assert vscode_settings.get("chat.tools.global.autoApprove") is False, (
        "VS Code must not auto-approve MCP tools globally"
    )

    opencode = configs["opencode/opencode.json"]
    assert "expo" not in opencode.get("mcp", {}), (
        "opencode has no verified per-MCP-tool permission key; keep expo out"
    )

    assert PRIMARY_SERVER in configs["ai/.mcp.json"]["mcpServers"], (
        "the primary server must be available to every client"
    )
    assert "@AGENTS.md" in (DOTFILES / "ai/CLAUDE.md").read_text().splitlines()
    assert (DOTFILES / "ai/AGENTS.md").is_file()
    print(
        f"Instruction, MCP, and Expo-policy consistency OK "
        f"(primary: {PRIMARY_SERVER}, {len(CANONICAL_SERVERS)} shared servers)"
    )


if __name__ == "__main__":
    main()
