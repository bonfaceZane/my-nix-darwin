# Global Claude Code Rules

## Git Commits

- Always use atomic commits — each commit should contain one logical change only.
- Do not bundle unrelated changes into a single commit.

## Nix / Laptop Setup

- All nix configuration and laptop setup changes must be made in `~/Documents/baantu/my-nix-darwin` — this is the single source of truth.
- Do not edit nix or system config files directly outside of this repo.
- After making nix changes, apply them with: `darwin-rebuild switch --flake .#rafiki`

## Shell

- Primary shell is Fish. Prefer Fish syntax for shell snippets and scripts.
- Zsh is available as a fallback for scripts that require it.
- Common aliases: `p` = pnpm, `k` = kubectl.

## Editor

- Default editor is Helix (`hx`). Use `hx <file>` when suggesting how to open files.

## Package Managers

- For JavaScript/TypeScript projects, prefer `bun` or `pnpm`. Avoid npm unless the project requires it.
- Ruby gems are managed under `~/.gem`.
- Python uses pyenv shims.
- Runtime versions are managed with `mise`.

## Directory Structure

- `~/Documents/work/` — work projects (amv-apps monorepo and others). Git identity switches to work email automatically for repos here.
- `~/Documents/baantu/` — personal projects.
- Work git identity: `rafiki <bonface.zane@autoscout24.com>`
- Personal git identity: in `~/.gitconfig_personal`

## Secrets

- Secrets are managed with sops-nix and stored encrypted in `~/Documents/baantu/my-nix-darwin/secrets.yaml`.
- Secrets are decrypted to `/run/secrets/` at activation time — do not hardcode keys in files.
- SSH key at `~/.ssh/id_ed25519` is used for both git signing and sops age decryption.

## Claude Settings

- Personal Claude settings: `~/Documents/baantu/my-nix-darwin/dotfiles/.claude/settings.json`
- Work Claude settings: `~/Documents/baantu/my-nix-darwin/dotfiles/.claude-work/settings.json`
- `~/.claude/settings.json` auto-swaps based on current directory (Fish `_auto_claude_settings` function).
