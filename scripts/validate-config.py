"""Validate named repository config sources without reading secrets or activating Nix."""

from pathlib import Path
import json
import re
import runpy
import tomllib

ROOT = Path(__file__).resolve().parent.parent


def unique_keys(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"Duplicate JSON key: {key}")
        result[key] = value
    return result


def validate_opencode_configs():
    """Check the global OpenCode config and its per-project template."""
    global_relative = "dotfiles/opencode/opencode.json"
    global_config = json.loads(
        (ROOT / global_relative).read_text(), object_pairs_hook=unique_keys
    )
    assert global_config["plugin"] == ["@openviking/opencode-plugin"]
    assert global_config["lsp"], "OpenCode LSP servers must be declared"
    for instruction in global_config["instructions"]:
        assert (ROOT / "dotfiles/opencode" / instruction).is_file(), (
            f"Missing OpenCode instruction: {instruction}"
        )
    print(f"JSON OK: {global_relative} ({len(global_config['lsp'])} LSP servers)")

    local_relative = "dotfiles/opencode/opencode.local.json"
    local_config = json.loads(
        (ROOT / local_relative).read_text(), object_pairs_hook=unique_keys
    )
    assert local_config["model"] == global_config["model"], (
        "Local OpenCode model must match the global model"
    )
    assert local_config["instructions"] == ["AGENTS.md"]
    print(f"JSON OK: {local_relative}")


def main():
    runpy.run_path(str(ROOT / "dotfiles/ai/validate.py"), run_name="__main__")
    validate_opencode_configs()
    for relative in ("mise.toml", "dotfiles/mise/config.toml"):
        with (ROOT / relative).open("rb") as source:
            config = tomllib.load(source)
        if relative == "mise.toml":
            tasks = config["tasks"]
            for task in tasks.values():
                for called in re.findall(r"mise run ([\w-]+)", task.get("run", "")):
                    assert called in tasks, f"Missing mise task: {called}"
        else:
            assert "aider-chat" in config["tools"], "Aider must be a declared mise tool"
        print(f"TOML OK: {relative}")

    wiring = (ROOT / "home/dotfiles.nix").read_text()
    sources = set(re.findall(r'\$\{dotfiles\}/([^"\n]+)', wiring))
    for relative in sorted(sources):
        path = ROOT / "dotfiles" / relative
        # This is a legacy migration comparison, not a required source.
        if relative == ".codex/config.toml":
            continue
        assert path.exists(), f"Missing dotfile source: {relative}"
        current = ROOT / "dotfiles"
        for part in Path(relative).parts:
            assert part in {p.name for p in current.iterdir()}, f"Wrong capitalization: {relative}"
            current = current / part
    assert '"${dotfiles}/amv/pre-push"' in wiring
    assert '".codex/settings.json"' not in wiring
    for name in ("AGENTS.md", "CLAUDE.md", "GEMINI.md"):
        assert (ROOT / name).is_file(), f"Missing project instructions: {name}"
    assert (ROOT / ".github/copilot-instructions.md").is_file(), "Missing Copilot instructions"
    assert (ROOT / "dotfiles/.cursor/rules/agents.mdc").is_file(), "Missing Cursor rules"
    skill = ROOT / ".agents/skills/nix-darwin-maintenance/SKILL.md"
    assert skill.read_text().startswith("---\nname: nix-darwin-maintenance\n")
    print(f"Dotfile sources OK: {len(sources)} references; project instructions and skill OK")


if __name__ == "__main__":
    main()
