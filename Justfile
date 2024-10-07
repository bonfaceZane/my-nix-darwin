rebuild:
    darwin-rebuild switch --flake .#rafiki --show-trace

update: 
    nix flake update
    darwin-rebuild switch --flake .#rafiki