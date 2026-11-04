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


def main():
    runpy.run_path(str(ROOT / "dotfiles/ai/validate.py"), run_name="__main__")
    for relative in ("mise.toml", "dotfiles/mise/config.toml"):
        with (ROOT / relative).open("rb") as source:
            config = tomllib.load(source)
        if relative == "mise.toml":
            tasks = config["tasks"]
            for task in tasks.values():
                for called in re.findall(r"mise run ([\w-]+)", task.get("run", "")):
                    assert called in tasks, f"Missing mise task: {called}"
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
    for name in (
        "nix-darwin-maintenance",
        "expo-mobile",
        "radon-ide",
        "component-first",
        "react-native-testing",
    ):
        skill = ROOT / f"dotfiles/ai/skills/{name}/SKILL.md"
        assert skill.read_text().startswith(f"---\nname: {name}\n"), f"Invalid skill: {name}"
    print(f"Dotfile sources OK: {len(sources)} references; project instructions and skills OK")


if __name__ == "__main__":
    main()
