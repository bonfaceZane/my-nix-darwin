{ config, lib, pkgs, ... }:
let
  # Single source of truth for Cline's global MCP servers.
  #
  # The same file is validated by dotfiles/ai/validate.py, so the definitions the
  # validator checks and the definitions Cline loads can no longer drift. The
  # previous version of this module repeated every server inline, which is how
  # the Maestro command here and in the tracked JSON diverged.
  # Path note: this module lives in modules/homebrew, so the repository's dotfiles
  # directory is two levels up (../dotfiles would resolve to modules/dotfiles).
  clineMcpSource = ../../dotfiles/ai/dotfiles/cline/mcp.json;

  # Parsed at evaluation time: malformed JSON fails the build instead of shipping
  # a broken Cline configuration. Unlike the definitions below it, this file is
  # evaluated, so the parse really happens.
  clineMcpSettings = builtins.fromJSON (builtins.readFile clineMcpSource);
  clineMcpServerNames = builtins.attrNames clineMcpSettings.mcpServers;

  # Servers removed from the root config on purpose. The merge below is additive,
  # so without this list a pruned server would linger in Cline's live settings
  # forever. Keep it in sync with dotfiles/ai/README.md ("Removed entries").
  clinePruneServers = [ "radon" "filesystem" ];
in
{
  # Cline: global MCP servers (VS Code on macOS).
  # Change the path for Cursor / VS Code Insiders / Windsurf if needed.
  # `home.file` would symlink into the read-only /nix/store, and Cline writes to
  # this file itself (UI toggles, OAuth tokens), so it is copied instead -- and
  # only when the content actually changed, to avoid churn on every switch.
  home.activation.clineMcpSettings =
    lib.hm.dag.entryAfter [ "writeBoundary" "linkGeneration" ] ''
      target="${config.home.homeDirectory}/Library/Application Support/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json"

      # Migrate away from a previous home.file symlink into the read-only store.
      if [ -L "$target" ]; then
        run rm -f "$target"
      fi

      run mkdir -p "$(dirname "$target")"

      # Merge instead of overwrite: managed servers always take the values from
      # the tracked JSON, but servers Cline added and any other keys it wrote
      # survive.
      if [ -f "$target" ] && ${pkgs.jq}/bin/jq -e 'type == "object"' "$target" > /dev/null 2>&1; then
        # Per-server merge, managed fields winning: keys Cline owns on a server
        # (OAuth tokens, session ids) survive, anything declared in the tracked
        # JSON is authoritative, and servers we do not manage are untouched.
        # Exception: `autoApprove` is consent given in Cline's UI, so it is
        # preserved when present and our `[ ]` default only seeds it.
        # `disabled` stays authoritative so a disabled server cannot be turned
        # back on by the merge.
        if ${pkgs.jq}/bin/jq --slurpfile new "${clineMcpSource}" --argjson prune '${builtins.toJSON clinePruneServers}' '
             def obj: if type == "object" then . else {} end;
             def merge($m; $o):
               ($o | obj) as $base
               | ($base + $m)
                 # `+` is shallow: merge `env` explicitly so our PATH wins but
                 # any extra var Cline set on this server survives.
                 | if ($m | has("env"))
                   then .env = (($base.env | obj) + $m.env) else . end
                 | if ($base | has("autoApprove"))
                   then .autoApprove = $base.autoApprove else . end;
             .mcpServers = (
               reduce ($new[0].mcpServers | to_entries[]) as $s
                 ((.mcpServers // {}) | obj;
                  .[$s.key] = merge($s.value; .[$s.key]))
               # Pruned servers are deleted after the merge, including entries an
               # earlier generation added, so removals take effect.
               | with_entries(select(.key as $k | ($prune | index($k)) == null))
             )' \
             "$target" > "$target.tmp"; then
          if ! cmp -s "$target.tmp" "$target"; then
            run mv "$target.tmp" "$target"
          else
            run rm -f "$target.tmp"
          fi
        else
          run rm -f "$target.tmp"
          run install -m 0644 "${clineMcpSource}" "$target"
        fi
      else
        # Missing or unparseable (Cline may have been mid-write). Keep a copy so a
        # bad file is recoverable instead of silently lost.
        if [ -f "$target" ]; then
          run cp "$target" "$target.bak"
        fi
        run install -m 0644 "${clineMcpSource}" "$target"
      fi
    '';

  # Report the managed server set in the activation log, and force evaluation of
  # the parse above so invalid JSON cannot pass the build.
  home.activation.clineMcpReport = lib.hm.dag.entryAfter [ "clineMcpSettings" ] ''
    echo "Cline MCP servers: ${lib.concatStringsSep ", " clineMcpServerNames}"
  '';
}
