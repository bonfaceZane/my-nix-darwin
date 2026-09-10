# AI client configuration

Shared instructions, client settings, and optional MCP configuration for Claude
Code, Codex, and Gemini CLI. Native file, search, shell, Git, and Nix tools are
sufficient to work on this Nix repository. MCP is optional: Maestro is useful for
mobile/web UI testing, not a prerequisite for editing or checking Nix files.

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

## Optional MCP

The shared Claude manifest, Gemini settings, and Codex seed use the documented
stdio `mcp` subcommand with explicit Homebrew paths:

- Command: `/opt/homebrew/bin/maestro`
- Arguments: `["mcp"]`
- Environment: `JAVA_HOME=/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home`

These paths target this Apple Silicon Mac and avoid reliance on interactive shell
or mise initialization for executable and Java discovery. They are not portable
to a different Homebrew prefix. Runtime operation still needs testing after
activation.

- **Claude:** with the optional manifest link above, use
  `claude --mcp-config ~/.claude/mcp.json`. Claude does not automatically discover
  that filename as user MCP configuration. Omit the flag when not using Maestro.
  Avoid `--strict-mcp-config` unless you deliberately want to exclude other
  configured servers. User-scope registration instead lives in mutable
  `~/.claude.json`, not in Claude's `settings.json`.
- **Codex:** new configurations enable `[mcp_servers.maestro]` by default because
  its prerequisites are declared. To opt out, set `enabled = false` in that
  table in your local config. Existing configs are not updated by seeding; the
  legacy migration preserves their contents rather than adding Maestro.
- **Gemini:** the existing `mcpServers.maestro` entry is retained in its settings.
  If the CLI is unavailable or unnecessary, exclude `maestro` using `mcp.excluded`
  in the appropriate settings scope, preserving other exclusions and user config.

Gemini's existing Radon integration is also retained, not propagated to other
clients. Its `npx -y radon-mcp@latest` command may download changing npm code and
uses a work-project path; review it in that project's context rather than treating
it as a reproducible Nix dependency. Neither Nx nor a separate Git MCP server is
required here. Use native Git, and configure Nx MCP only in a workspace that
already supplies Nx.

`dotfiles/ai/.gemini/settings.json` is a minimal project context overlay, not a
replacement for the canonical user settings. `dotfiles/ai/.agent/settings.json`
is a legacy other-client configuration, not a Claude/Codex/Gemini settings source.

## CLI availability and declarative installation

The Nix-managed Homebrew setup declares these prerequisites, pending activation:

- Tap `mobile-dev-inc/tap` and fully qualified formula
  `mobile-dev-inc/tap/maestro` for the mobile/web testing CLI.
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
