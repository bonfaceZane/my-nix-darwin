# AI client configuration

Shared instructions, client settings, and MCP configuration for Claude Code,
Codex, Gemini CLI, Copilot CLI, Cline, Cursor, Zed, OpenCode, and Antigravity.
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
| `.claude/settings.json` | `dotfiles/.claude/settings.json` |
| `.claude/CLAUDE.md` | `dotfiles/ai/CLAUDE.md` |
| `.claude/AGENTS.md` | `dotfiles/ai/AGENTS.md` |
| `.claude/mcp.json` | `dotfiles/ai/.mcp.json` (optional, explicit CLI input) |
| `.codex/AGENTS.md` | `dotfiles/ai/AGENTS.md` |
| `.gemini/settings.json` | `dotfiles/.gemini/settings.json` |
| `.gemini/AGENTS.md` | `dotfiles/ai/AGENTS.md` |
| `.cursor/mcp.json` | `dotfiles/.cursor/mcp.json` |
| `.cursor/settings.json` | `dotfiles/.cursor/settings.json` |
| `.cursor/rules/` | `dotfiles/.cursor/rules/` |
| `.copilot/mcp-config.json` | `dotfiles/.copilot/mcp-config.json` |
| `Library/Application Support/Code/User/mcp.json` | `dotfiles/vscode/mcp.json` |
| `~/Library/.../saoudrizwan.claude-dev/settings/cline_mcp_settings.json` | generated from `dotfiles/ai/dotfiles/cline/mcp.json` by `modules/homebrew/agents.nix` (copied, never symlinked) |
| `~/.config/zed` (MCP in `context_servers`) | `dotfiles/zed/settings.json` |
| `~/.config/opencode` (MCP in `mcp`) | `dotfiles/opencode/opencode.json` |
| `~/.gemini/antigravity/mcp_config.json` | `dotfiles/antigravity/mcp_config.json` |

If using a separate `CODEX_HOME`, such as `~/.codex-work`, give it its own
`AGENTS.md` link and mutable configuration. Codex's `AGENTS.override.md`, when
present, takes precedence over `AGENTS.md`; do not overwrite local overrides.

For the existing Nix-fetched `gh-stack` skill, link its complete immutable
upstream directory to `~/.agents/skills/gh-stack` for Codex and Gemini, and
`~/.claude/skills/gh-stack` for Claude. Preserve other installed skills. Gemini
also supports `~/.gemini/skills`, but does not need a duplicate link. The current
documented Codex user discovery directory is `~/.agents/skills`.

## Codex: initial seed, mutable local settings

`dotfiles/.codex/config.base.toml` is the version-controlled **initial seed**, not
a continuously enforced configuration layer. It contains only:

- `on-request` approvals and the `workspace-write` sandbox;
- sandbox network access disabled;
- an enabled Maestro MCP definition using the declared Apple Silicon Homebrew
  executable and Java runtime paths.

Home activation handles migration and seeding in this order:

1. **Before `linkGeneration`:** detach a legacy config symlink only if its
   resolved target is exactly this checkout's `dotfiles/.codex/config.toml`,
   preserving its contents in a private, writable local config before Home
   Manager removes the obsolete managed link. This is a content-preserving
   migration, not replacement with the seed. The ignored source is not modified.
2. **During `linkGeneration`:** Home Manager removes obsolete links it owns,
   including dangling old Home Manager links. The migration does not remove
   unrelated user-owned symlinks.
3. **After `linkGeneration`:** copy the seed into `CODEX_HOME/config.toml`
   **only when the destination is absent**. Thus an obsolete dangling Home
   Manager link can be removed first and its now-absent destination seeded.
   Existing files and remaining symlinks, including user-owned dangling
   symlinks, are not overwritten.

Do not symlink the live config to the immutable seed or reapply defaults on each
activation. Existing configurations retain their contents; seed changes affect
only destinations that are absent after Home Manager's link cleanup.

`dotfiles/.codex/config.toml` is intentionally ignored and remains local. It can
contain desktop-generated plugin settings, runtime paths, notifications, project
trust, and model selections. Do not track it, replace it with the seed, or validate
it as repository-owned configuration. Model selection belongs to the user and the
client's available model catalog; the seed imposes no model ID.

Keep authentication, caches, and client-generated state out of version control.
In particular, do not manage `auth.json` or mutable `~/.claude.json` as repository
symlinks. The seed policy and instruction links are separate: changing shared
instructions does not require rewriting a user's live Codex config.

## MCP servers

Every MCP-capable client on this machine declares the same mobile, React Native,
and Expo toolchain, using absolute Homebrew/mise paths because Dock- and
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
| `expo` | remote `https://mcp.expo.dev/mcp` (restricted, see below) | Expo docs, EAS build/workflow/EAS metadata, TestFlight and store read data |

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
- The remote Expo server authenticates with OAuth and needs `https://mcp.expo.dev/mcp`.
  Sign in once per client (`/mcp` in Claude Code, `codex mcp login expo`, the
  client's own login flow elsewhere).
- Antigravity and Zed declare the stdio servers only. Their remote-server schema
  key is not verified for the installed versions, and an unverified key would
  silently drop the server, so `expo` is omitted there on purpose.
- opencode declares the stdio servers only, for the same reason plus one more:
  its documented `permission` keys cover built-in tools, not MCP tools, and its
  defaults are permissive, so registering `expo` there would grant unattended
  actions. See "Expo MCP restrictions" below.
- VS Code keeps its gallery-managed `io.github.upstash/context7` entry (pinned
  version, `${input:CONTEXT7_API_KEY}`) instead of the canonical `context7`, and
  that entry is excluded from the strict comparison in the validator.
- Cline's live settings file is generated by `modules/homebrew/agents.nix` from
  `dotfiles/ai/dotfiles/cline/mcp.json` and merged server by server, so servers
  Cline added itself, OAuth tokens, and UI approval state survive. `radon` stays
  `disabled` until its invocation is verified.

## Expo MCP restrictions

The Expo server is the one remote, account-scoped entry in this set. Its 31 tools
include actions that spend EAS compute, publish to public store listings, rewrite
project dependencies, or move device data off the machine. Every client that can
express a deny rule refuses these outright:

`add_library`, `workflow_create`, `workflow_run`, `workflow_cancel`, `build_run`,
`build_cancel`, `build_submit`, `appstore_reply_review`,
`appstore_delete_review_response`, `playstore_reply_review`, `automation_tap`,
`automation_take_screenshot`, `collect_app_logs`.

Everything else (documentation, `learn`, build/workflow read tools, TestFlight and
store read tools, `expo_router_sitemap`, `automation_find_view`, `open_devtools`)
still requires explicit per-call approval, so nothing runs unattended.

| Client | Enforcement |
| --- | --- |
| Claude Code | `permissions.deny` lists all 13 tools as `mcp__expo__<tool>`; `permissions.ask` adds server-level `mcp__expo`, so any other expo tool still prompts. Deny rules hold even in auto mode. |
| Codex | `[mcp_servers.expo]` sets `default_tools_approval_mode = "prompt"` plus the 13-name `disabled_tools` list. This lives in the mutable `CODEX_HOME/config.toml` (`~/.codex` and `~/.codex-work`), which seeding never overwrites. |
| Gemini CLI | `trust: false` on the server, plus the 13 names in `excludeTools`. `trust: true` is what bypasses confirmations, so it must stay false. |
| VS Code | `chat.tools.global.autoApprove: false`, so every MCP tool call is confirmed before it runs. |
| Cline | `autoApprove` stays `[]` for every server, which is the only approval control Cline offers. The validator asserts it. |
| Cursor, Copilot CLI | Registered with the client's default per-call confirmation. The apps are not installed on this machine, so nothing enforces policy beyond that default. |
| Zed, Antigravity, opencode | The Expo server is not registered at all: their remote-server key is unverified, and opencode's documented `permission` keys cover built-in tools rather than MCP tools. |

Two additional guards are worth knowing:

- **Local capabilities are off.** They require the `expo-mcp` package in the app's
  dependencies plus `EXPO_UNSTABLE_MCP_SERVER=1`. The gp-apps project has neither,
  so simulator screenshots, device logs, and the React Native DevTools bridge are
  unavailable regardless of the client. The deny list also covers those tools, so
  enabling local capabilities later does not silently re-open them.
- **Reads are still data egress.** `build_logs` and `workflow_logs` can contain CI
  environment output, and store read tools return user reviews. Treat their
  results as sensitive and do not paste them into other tools.

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
- **OpenCode:** `mcp` entries use a command array plus `environment`. The Expo
  server is deliberately absent; see "Expo MCP restrictions" above.

Local prerequisites are declared in Nix-managed Homebrew (see below). The
work-specific Radon integration stays out of the global files because its
`npx -y radon-mcp@latest` command downloads changing npm code and it used a fixed
work-project path; configure it in that workspace's own settings instead. Neither
Nx nor a separate Git MCP server is required here: use native Git, and configure
Nx MCP only in a workspace that already supplies Nx.

`dotfiles/ai/.gemini/settings.json` is a minimal project context overlay, not a
replacement for the canonical user settings. The legacy `dotfiles/ai/.agent/settings.json`
has been removed; Cursor and Copilot now use their native entry points
(`dotfiles/.cursor/rules/agents.mdc` and `.github/copilot-instructions.md`).

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
