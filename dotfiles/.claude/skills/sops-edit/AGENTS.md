# Sops Edit

Edits the encrypted `secrets.yaml` file. sops decrypts it in-memory, opens it in the editor, then re-encrypts on save.

## Secrets file location

`~/Documents/subira/my-nix-darwin/secrets.yaml`

## Current secrets

- `useremail` — personal email
- `anthropic_api_key` — personal Anthropic API key (loaded as `ANTHROPIC_API_KEY` in shell)
- `anthropic_api_key_work` — work Anthropic API key (currently unused; work uses AWS Bedrock)

## Steps

1. Edit the secrets file:
   ```bash
   sops ~/Documents/subira/my-nix-darwin/secrets.yaml
   ```
   sops uses the SSH key at `~/.ssh/id_ed25519` for decryption (via age).

2. Add or update values in plain YAML — sops handles encryption on save.

3. After editing, if a new secret was added, declare it in `home/default.nix` under `sops.secrets`:
   ```nix
   secrets.my_new_secret = { };
   ```

4. To expose the secret in the shell, add it to `home/shell.nix`:
   ```fish
   if test -f /run/secrets/my_new_secret
       set -gx MY_VAR (cat /run/secrets/my_new_secret)
   end
   ```

5. Rebuild to activate:
   ```bash
   darwin-rebuild switch --flake .#rafiki
   ```

6. Commit `secrets.yaml` and any nix changes as separate atomic commits.

## Note

Never hardcode secret values in nix files or dotfiles — always use sops.
