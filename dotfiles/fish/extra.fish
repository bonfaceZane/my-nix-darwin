# ~/.config/fish/conf.d/extra.fish
# Symlinked from dotfiles/fish/extra.fish — edit there, not here.
# This file is auto-sourced by Fish. Use it for any custom Fish-specific config
# that isn't covered by home/shell.nix (functions, abbr, one-off set -gx, etc).

# Aider BYOK (DeepSeek). DEEPSEEK_API_KEY comes from the SOPS-managed shell env.
set -gx AIDER_MODEL "deepseek/deepseek-reasoner"
abbr --add aider-byok 'aider --model deepseek/deepseek-reasoner --no-auto-commits --no-check-update --no-show-model-warnings'
