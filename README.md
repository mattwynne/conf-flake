To bootstrap on a new machine:

    # Install nix
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install macos --no-confirm

    mkdir ~/.config
    nix shell -p git
    git clone https://github.com/mattwynne/conf-flake ~/.config/nix-darwin
    sudo nix run nix-darwin -- switch --flake ~/.config/nix-darwin
