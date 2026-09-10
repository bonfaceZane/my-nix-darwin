"""Validate named repository config sources without reading secrets or activating Nix."""

from pathlib import Path
import re
import runpy
import tomllib

ROOT = Path(__file__).resolve().parent.parent


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
    skill = ROOT / ".agents/skills/nix-darwin-maintenance/SKILL.md"
    assert skill.read_text().startswith("---\nname: nix-darwin-maintenance\n")
    print(f"Dotfile sources OK: {len(sources)} references; project instructions and skill OK")


if __name__ == "__main__":
    main()
