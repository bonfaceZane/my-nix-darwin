#!/bin/bash

# run curl to download the latest nix package
curl \
  --proto '=https' \
  --tlsv1.2 \
  -sSf \
  -L https://install.determinate.systems/nix \
  | sh -s -- install


#   run script to install nix-darwin
curl \
  --proto '=https' \
  --tlsv1.2 \
  -sSf \
  -L https://install.determinate.systems/nix-darwin \
  | sh -s -- install

# Wire OpenCode globally and write a local config for this checkout.
bash "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles/setup.sh" all "$PWD"
