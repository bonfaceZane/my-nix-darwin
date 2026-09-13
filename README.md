# my-nix-darwin

Single-user Apple Silicon macOS configuration for `rafiki`, composed with nix-darwin and Home Manager. Keep the checkout at `~/Documents/subira/my-nix-darwin`: editable dotfile links intentionally refer to that location.

## Build and apply

Requires Nix, nix-darwin, and Homebrew for the declared Brew apps. Python 3.11+ runs the lightweight validation without installing anything.

```sh
python3 scripts/validate-config.py
mise run build       # Build only; no system activation
mise run switch      # Activate with sudo; may upgrade Homebrew apps
```

Without mise:

```sh
darwin-rebuild build --flake .#rafiki --show-trace --impure
sudo -E darwin-rebuild switch --flake .#rafiki --show-trace --impure
```

New files must be tracked by Git before a normal Git-backed flake build sees them. Review and stage only intended files. `mise tasks` lists additional commands; `update`, `gc`, `clean`, and `rollback` are explicit maintenance operations, not routine validation.

## Structure and ownership

```text
flake.nix / flake.lock      Composition and pinned inputs
modules/                   System nix-darwin modules
  systems.nix              macOS defaults, keyboard, login shell, sudo
  homebrew/                Brew taps, formulae, casks, activation policy
  apps.nix                 System app aggregator
  system-packages.nix      Global Nix packages
  host-users.nix            Host/user configuration
  nix-core.nix              Nix daemon configuration
home/                      Home Manager modules
  default.nix              Explicit imports and user SOPS declarations
  app-settings/            Fish/Zsh, Git, Starship, mise
  apps.nix / core.nix       User packages and program options
  dotfiles.nix             Dotfile links and writable Codex seed
services/                  System services
packages/                  Local package definitions
scripts/                   Validation and maintenance helpers
dotfiles/                  Editable application configuration sources
  ai/                      Shared AI instructions, MCP manifest, validation
  .claude/ .gemini/         Client-native settings
  .cursor/ .copilot/        Cursor rules/MCP and Copilot MCP
  .codex/config.base.toml   Portable seed, not a live configuration
.agents/skills/             Repository-specific maintenance workflow
AGENTS.md                  Contribution and safety instructions
CLAUDE.md / GEMINI.md       Client entry points to those instructions
mise.toml                  Build/activation/validation tasks
```

Keep explicit imports and the current module boundaries; a single host does not need a generic host framework or automatic module discovery. See [home/README.md](home/README.md) and [modules/README.md](modules/README.md).

## Dotfile sync

`home/dotfiles.nix` is the link inventory. Most app settings are out-of-store symlinks to this checkout, so edits to their sources are visible without rebuilding; the application may need reloading. Adding/changing links requires activation. Home Manager owns generated shell, Git, Starship, and other first-class program configuration—do not also symlink over these generated files.

Not every directory in `dotfiles/` is automatically deployed. App-specific paths are intentional: Zed/mise/Helix/Zellij/WezTerm/Ghostty use `~/.config`, Nushell uses `~/Library/Application Support/nushell`, while Claude/Codex/Gemini use their native hidden home directories. Do not force every app into `~/.config`.

AI settings, instructions, and skills are linked individually so authentication and session state remain writable and outside Git. **Codex is seed-only:** existing config and app-generated integrations are preserved. During migration, only the old symlink resolving to this checkout's ignored Codex config is detached into a private local copy. Future seed edits do not overwrite local settings. See [dotfiles/ai/README.md](dotfiles/ai/README.md) for exact paths and MCP startup.

Work-project links under `~/Documents/work/amv-apps` are deliberately explicit. Review these before using this configuration for another user or machine.

## AI tooling

Claude Code, Codex, and Gemini CLI are declared through Nix-managed Homebrew. Shared instructions and `gh-stack` skills keep workflows consistent; the project maintenance skill explains this repository's module ownership and checks. Cursor and Copilot consume the same shared instructions through their native entry points. Native file/search/shell/Git/Nix tools are sufficient for contributing here—more MCP servers or broader permissions do not automatically make an agent more capable.

Maestro's mobile-testing CLI/MCP is declared separately from the unrelated `Maestro.app` GUI. MCP schemas differ per client; Claude loads the shared manifest explicitly, Gemini has native settings, and new Codex profiles get a native TOML definition. Existing Codex profiles require an intentional local merge. Gemini's existing work-specific Radon integration still uses `npx ...@latest`; it is not pinned or validated by this repository.

## Secrets and account selection

Secrets are managed by SOPS. Edit encrypted secrets locally with `sops secrets.yaml`; never paste decrypted contents into chat, logs, tracked settings, or a Nix expression. Use `config.sops.secrets.<name>.path` for runtime consumers rather than reading secret values during Nix evaluation. Do not assume a `/run/secrets` path: Home Manager's configured paths are authoritative.

Parent mise settings select `CODEX_HOME=~/.codex` under `~/Documents/subira` and `~/.codex-work` under `~/Documents/work`. Authentication stays separate and client-owned. This only affects processes receiving that environment; GUI-launched IDE AI providers do **not** automatically switch accounts by directory. API billing is separate from ChatGPT subscriptions. No OpenAI key provisioning is implied by these settings.

## Validation boundaries and remaining cleanup

- `python3 scripts/validate-config.py` checks named non-secret JSON/TOML, instruction references, MCP consistency, task references, and dotfile source existence/capitalization.
- `nix-instantiate --parse PATH` checks syntax; a build/evaluation is needed for option types and integration.
- `git diff --check` checks whitespace.
- Runtime permissions, GUI behavior, authentication, and MCP handshakes require testing after activation. No check here guarantees a working live connection.

Some tools are still declared through both Homebrew and Nix (including Git, mise, Starship, skim, and PostgreSQL). Choose a single owner in a deliberate package migration, not a broad cleanup that changes PATH or service data unexpectedly. `modules/gems.nix` is unused legacy code, not an active Ruby module. Unused inputs and legacy dotfiles can be retired separately once their consumers are confirmed.
