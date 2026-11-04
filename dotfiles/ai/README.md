# AI client configuration

Shared instructions, client settings, and MCP configuration for Claude Code,
Codex, Gemini CLI, Copilot CLI, Cline, Cursor, Zed, and Antigravity.
Native file, search, shell, Git, and Nix tools are sufficient to work on this Nix
repository. MCP is optional here: the mobile set below is useful for app UI
testing and device automation, not a prerequisite for editing or checking Nix
files.

## Instructions and skills

`AGENTS.md` is the shared instruction source. Claude's `CLAUDE.md` imports it with
`@AGENTS.md`; Gemini loads both `AGENTS.md` and existing `GEMINI.md` files. Repository
instructions still provide project-specific guidance. Nx guidance applies only to
actual Nx workspaces, not every project on the machine.

The shared Home Manager file links are implemented below and take effect on
activation. Sources are relative to this repository; destinations are relative
to the user's home. Individual files are linked rather than entire client state
directories; preserve user-owned files when resolving collisions.

| Destination | Source |
| --- | --- |
| `.claude/settings.json` | `dotfiles/ai/clients/claude/settings.json` |
| `.claude/CLAUDE.md` | `dotfiles/ai/CLAUDE.md` |
| `.claude/AGENTS.md` | `dotfiles/ai/AGENTS.md` |
| `.claude/mcp.json` | `dotfiles/ai/clients/claude/mcp.json` (optional, explicit CLI input) |
| `.codex/AGENTS.md` | `dotfiles/ai/AGENTS.md` |
| `.gemini/settings.json` | `dotfiles/ai/clients/gemini/settings.json` |
| `.gemini/AGENTS.md` | `dotfiles/ai/AGENTS.md` |
| `Documents/work/amv-apps/.gemini/settings.json` (fallback only) | `dotfiles/ai/clients/gemini/workspace-settings.json` |
| `Documents/work/amv-apps/.mcp.json` (fallback only) | `dotfiles/ai/clients/claude/mcp.json` |
| `.cursor/mcp.json` | `dotfiles/ai/clients/cursor/mcp.json` |
| `.cursor/settings.json` | `dotfiles/ai/clients/cursor/settings.json` |
| `.cursor/rules/` | `dotfiles/ai/clients/cursor/rules/` |
| `.copilot/mcp-config.json` | `dotfiles/ai/clients/copilot/mcp-config.json` |
| `Library/Application Support/Code/User/mcp.json` | `dotfiles/ai/clients/vscode/mcp.json` |
| `~/Library/.../saoudrizwan.claude-dev/settings/cline_mcp_settings.json` | generated from `dotfiles/ai/dotfiles/cline/mcp.json` by `modules/homebrew/agents.nix` (copied, never symlinked) |
| `~/.config/zed` (MCP in `context_servers`) | `dotfiles/zed/settings.json` |
| `~/.gemini/antigravity/mcp_config.json` | `dotfiles/ai/clients/antigravity/mcp_config.json` |
| `~/.gemini/antigravity/browserAllowlist.txt` | `dotfiles/ai/clients/antigravity/browserAllowlist.txt` |
| `~/.config/muse/settings.json` | `dotfiles/ai/clients/muse/settings.json` |

If using a separate `CODEX_HOME`, such as `~/.codex-work`, give it its own
`AGENTS.md` link and mutable configuration. Codex's `AGENTS.override.md`, when
present, takes precedence over `AGENTS.md`; do not overwrite local overrides.

For the existing Nix-fetched `gh-stack` skill, link its complete immutable
upstream directory to `~/.agents/skills/gh-stack` for Codex and Gemini, and
`~/.claude/skills/gh-stack` for Claude. Preserve other installed skills. Gemini
also supports `~/.gemini/skills`, but does not need a duplicate link. The current
documented Codex user discovery directory is `~/.agents/skills`.

Store skills maintained by this Nix configuration under `dotfiles/ai/skills/`.
Home Manager links each skill directory individually into `~/.agents/skills/`
for Codex and Gemini and into `~/.claude/skills/` when Claude discovery is
needed. Keep repo-only skills in the repository's `.agents/skills/` directory.
The `nix-darwin-maintenance` skill is globally discoverable, but its description
limits its workflow to this repository.

The shared `expo-mobile` skill gives cross-project Expo and React Native
workflow guidance. `radon-ide` documents the optional Radon IDE workflow when a
project already has Radon available; it does not configure or install a global
Radon MCP server. Both are linked individually into `~/.agents/skills/` and
`~/.claude/skills/`.

`component-first` offers general React component reuse and extraction guidance,
while `react-native-testing` covers behavior-focused tests across component,
platform, and device levels. Both defer to each project's installed tooling and
local conventions.

The curated Figma skills cover using Figma, creating files and designs, generating
libraries and design-system rules, implementing designs, and working with Code
Connect components. They are linked individually into `~/.agents/skills/` and
`~/.claude/skills/` alongside the other repo-managed shared skills.

`agent-device` and `ios-simulator` remain individually installed in that shared
Codex directory and are linked into `~/.claude/skills/` for Claude discovery.
Do not link the whole skill directory: it would take ownership of user-installed
skills that Home Manager does not manage.

## Codex: tracked personal configuration

`dotfiles/ai/clients/codex/config.toml` is symlinked to `~/.codex/config.toml` by Home
Manager. Changes made through the Codex CLI or desktop app therefore write back
to this repository for review and version control.

The work profile remains independent at `~/.codex-work/config.toml`, selected by
`CODEX_HOME` inside `~/Documents/work`; it may use a different login and local
client state.

Keep authentication, caches, and other credentials out of version control. In
particular, do not manage `auth.json` as a repository symlink.

## MCP servers

Every MCP-capable client on this machine declares the same mobile and React Native
toolchain, using absolute Homebrew/mise paths because Dock- and
Finder-launched editors inherit a minimal `PATH`. `dotfiles/ai/validate.py` holds
the canonical definitions and fails the build when a client drifts, drops a
server, or changes an argument.

| Server | Definition | Purpose |
| --- | --- | --- |
| `maestro` | `/opt/homebrew/bin/maestro mcp`, `JAVA_HOME=/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home` | Maestro E2E flows, view hierarchy, screenshots |
| `mobile-mcp` | `/opt/homebrew/bin/npx -y @mobilenext/mobile-mcp@latest` | iOS and Android device/simulator control (accessibility-first) |
| `ios-simulator` | `/opt/homebrew/bin/npx -y ios-simulator-mcp@latest` | Simulator lifecycle, UI taps/typing, `simctl` output |
| `codegraph` | `/Users/rafiki/.local/share/mise/shims/codegraph serve --mcp` | Cross-language code intelligence for the current project |
| `context7` | `/opt/homebrew/bin/npx -y @upstash/context7-mcp@latest` | Current React Native/Expo/library documentation |

Notes that matter when editing these files:

- `dotfiles/ai/mcp/servers.json` is the single source of truth for this whole set.
  `python3 dotfiles/ai/mcp/render.py --write` (or `mise run mcp-render`) applies it
  to every client below, preserving each client's own servers, gallery metadata,
  and UI state; `--check` (`mise run mcp-check`) reports drift without writing.
  `validate.py` runs that same check, so a dropped or mistyped server fails
  validation instead of silently disappearing from one client.
- `codegraph` is the **primary** server (`primary` in the root config). It is
  rendered first in every client, and `AGENTS.md` instructs every agent to use it
  before ad-hoc searching for symbol, call-graph, and impact questions. Projects
  need `codegraph init` once; `codegraph status` shows index freshness.
- CodeGraph ships `codegraph install` / `codegraph install --print-config <agent>`
  for the same wiring. This repo deliberately deviates from the printed snippet on
  the command: a bare `codegraph` is not on a GUI-launched editor's `PATH` (their
  Antigravity snippet uses the versioned `installs/node/<version>/bin` path, which
  breaks on the next Node upgrade), so every client uses the stable mise shim
  `/Users/rafiki/.local/share/mise/shims/codegraph`. `codegraph install` also writes
  an auto-allow permission list for Claude Code, which this setup does not want.
  Note that the npm package literally named `codegraph` is an unrelated 469-byte
  package by a different author, so never replace the shim with `npx codegraph`.
- `MOBILEMCP_DISABLE_TELEMETRY=1` is set for `mobile-mcp`: the upstream server
  otherwise reports anonymous usage telemetry. Keep it unless you deliberately
  opt in.
- Expo MCP is not part of the global set. Configure it in an Expo project when
  that workspace needs EAS or store tooling, and review that client's OAuth and
  tool-approval behavior there.
- VS Code keeps its gallery-managed `io.github.upstash/context7` entry (pinned
  version, `${input:CONTEXT7_API_KEY}`) instead of the canonical `context7`, and
  that entry is excluded from the strict comparison in the validator.
- Cline's live settings file is generated by `modules/homebrew/agents.nix` from
  `dotfiles/ai/dotfiles/cline/mcp.json` and merged server by server, so servers
  Cline added itself, OAuth tokens, and UI approval state survive. `radon` stays
  `disabled` until its invocation is verified.

### Removed entries

Pruning that followed the same "one root config" rule, so nothing dead stays in a
client:

- `radon` (Cline): disabled and unverified, and this repository's own guidance says
  a workspace-specific Radon server must not be configured globally.
- Zed's `git` server: `@modelcontextprotocol/server-git` is not published on npm,
  so the entry could never have started. Git stays a native CLI tool.
- `filesystem` (Cline): the agent's built-in file tools already cover the workspace,
  and this server deliberately exposed two whole repositories beyond it.
- The empty `inputs` array in VS Code's `mcp.json`: nothing referenced it.
- `dotfiles/ai/.agent/settings.json`: a dead legacy overlay. Nothing linked it,
  `README.md` already claimed it was removed, and its GitKraken entry lives in
  Antigravity's own config.

Zed's `memory` entry was kept but repaired: it used a bare `npx`, which a
Dock-launched Zed cannot resolve, so it now uses the absolute Homebrew path plus an
explicit `PATH`.

Client-specific behaviour:

- **Claude:** with the optional manifest link above, use
  `claude --mcp-config ~/.claude/mcp.json`. Claude does not automatically discover
  that filename as user MCP configuration. Omit the flag when not using these
  servers. Avoid `--strict-mcp-config` unless you deliberately want to exclude
  other configured servers. User-scope registration instead lives in mutable
  `~/.claude.json`, not in Claude's `settings.json`.
- **Codex:** the tracked seed keeps only `[mcp_servers.maestro]`. The seed sets
  `sandbox_workspace_write.network_access = false`, so the npm-backed servers
  (`mobile-mcp`, `ios-simulator`, `context7`) belong in the mutable
  `CODEX_HOME/config.toml`, which enables network access. Register them there with
  `codex mcp add`, which keeps the file schema-valid. `codegraph` is safe in
  either place because it does not download anything.
- **Gemini and Copilot:** both retain the shared `maestro` server plus the stdio
  set. Gemini spells remote servers `httpUrl`, Copilot CLI uses
  `type: local`/`http`.

Local prerequisites are declared in Nix-managed Homebrew (see below). The
work-specific Radon integration stays out of the global files because its
`npx -y radon-mcp@latest` command downloads changing npm code and it used a fixed
work-project path; configure it in that workspace's own settings instead. Neither
Nx nor a separate Git MCP server is required here: use native Git, and configure
Nx MCP only in a workspace that already supplies Nx.

`dotfiles/ai/clients/gemini/workspace-settings.json` is a minimal project context
overlay, not a replacement for the canonical user settings. The legacy
`dotfiles/ai/.agent/settings.json`
has been removed; Cursor and Copilot now use their native entry points
(`dotfiles/ai/clients/cursor/rules/agents.mdc` and `.github/copilot-instructions.md`).

## CLI availability and declarative installation

The Nix-managed Homebrew setup declares these prerequisites, pending activation:

- Tap `mobile-dev-inc/tap` and fully qualified formula
  `mobile-dev-inc/tap/maestro` for the mobile/web testing CLI.
- Tap `facebook/fb` and formula `facebook/fb/idb-companion`, which provides `idb`
  for `ios-simulator-mcp`'s taps, swipes, typing, and accessibility dumps. The
  simulator-lifecycle tools work without it; the UI tools do not.
- Formula `openjdk` for Maestro's Java runtime (Java 17+ required). The MCP
  definitions explicitly supply its `JAVA_HOME`.
- Cask `claude-code`, which provides the standalone `claude` executable in
  Homebrew's `bin` directory.

The separate `maestro` cask is the unrelated **runmaestro.ai AI-agent command
center** (`Maestro.app`), not the testing CLI. A Dock entry for `Maestro Studio.app`
or a Fish PATH entry for `~/.maestro/bin` does not supply the testing CLI either.
The fully qualified formula avoids confusing these products.

Neither `maestro` nor `claude` was found on the audit process's PATH before these
changes. Declaring packages and explicit paths is not proof of a working local
runtime: activation and subsequent client/MCP checks remain necessary. No packages
were installed or live MCP connections attempted as part of the dotfile audit.
Missing optional CLIs do not block normal Nix/Git work.

## Permissions and validation

Shared instructions describe sensitive-path and approval expectations, but prose
is not an enforced security boundary. Claude retains its existing permission
rules; Gemini uses normal `default` approval mode, not auto-edit or YOLO. The
Codex seed does not loosen existing local permissions because it must never be
applied over an existing configuration.

Run with existing Python 3.11+ from the repository root:

```sh
python3 dotfiles/ai/validate.py
```

This validates the named repository JSON files, the Codex seed's TOML,
and instruction/Maestro consistency. It does not read mutable Codex config,
credentials, or home-directory state, launch clients, or download packages. It is
not a full client-schema or live MCP handshake test. Once optional CLIs and home
links are available, check instruction/skill discovery and `/mcp` in each client.

## References

- [Claude MCP scopes](https://code.claude.com/docs/en/mcp), [memory](https://code.claude.com/docs/en/memory), and [skills](https://code.claude.com/docs/en/skills)
- [Codex configuration](https://developers.openai.com/codex/config-reference/) and [skill discovery](https://developers.openai.com/codex/skills/)
- [Gemini configuration](https://geminicli.com/docs/reference/configuration) and [skills](https://geminicli.com/docs/cli/skills/)
- [Maestro CLI installation](https://docs.maestro.dev/maestro-cli/how-to-install-maestro-cli) and [MCP](https://docs.maestro.dev/get-started/maestro-mcp)
- Homebrew metadata: [Maestro GUI cask](https://formulae.brew.sh/api/cask/maestro.json), [Claude Code CLI cask](https://formulae.brew.sh/api/cask/claude-code.json)
