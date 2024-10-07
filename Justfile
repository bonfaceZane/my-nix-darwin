rebuild:
    darwin-rebuild switch --flake .#rafiki --show-trace

update: 
    nix flake update
    darwin-rebuild switch --flake .#rafiki

clean:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d