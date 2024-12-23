rebuild:
    darwin-rebuild switch --flake .#rafiki --show-trace --impure

update: 
    nix flake update
    darwin-rebuild switch --flake .#rafiki --show-trace --impure

clean:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

show:
    nix flake show

check:
    nix flake check

build:
    nix run nix-darwin -- switch --flake .#rafiki --show-trace --impure