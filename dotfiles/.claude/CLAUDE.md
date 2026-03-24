# Global Claude Code Rules

## Git Commits

- Always use atomic commits — each commit should contain one logical change only.
- Do not bundle unrelated changes into a single commit.

## Nix / Laptop Setup

- All nix configuration and laptop setup changes must be made in `~/Documents/baantu/my-nix-darwin` — this is the single source of truth.
- Do not edit nix or system config files directly outside of this repo.
