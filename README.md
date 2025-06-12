To bootstrap on a new machine:

    mkdir ~/.config
    nix shell -p git
    git clone https://github.com/mattwynne/conf-flake ~/.config/nix-darwin
    nix run nix-darwin -- switch --flake ~/.config/nix-darwin
