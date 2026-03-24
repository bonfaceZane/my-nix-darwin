# Android Development paths (vars set by home.sessionVariables)
export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools

eval "$(direnv hook zsh)"

# Tool PATH additions (vars set by home.sessionVariables)
export PATH="$PNPM_HOME:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"
export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH"
export PATH="$GEM_HOME/bin:$PATH"
export PATH="$HOME/.pyenv/shims:$PATH"
export PATH="$HOME/.local/share/mise/shims:$PATH"
export PATH="$PATH:$HOME/.maestro/bin"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Custom Functions (also defined in Fish via shell.nix)
function prebuild() {
  local app=${1:-"gpd"}
  yarn $app prebuild --clean
}

function run() {
  local app=${1:-"gpd"}
  local os=${2:-"ios"}
  yarn $app $os --device='Iphone Air'
}

function build() {
  eas build --platform=$1 --profile=$2
}

function osha() {
  npx npkill -D -y
}

eval "$(starship init zsh)"
