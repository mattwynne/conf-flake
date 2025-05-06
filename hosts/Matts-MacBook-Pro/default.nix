{ pkgs, lib, ... }:

{
  nixpkgs = {
    config.allowUnfree = true;
  };

  nix = {
    linux-builder.enable = true;
    optimise.automatic = true;
    settings.trusted-users = [ "@admin" "matt" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };


  programs.zsh.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };

    taps = [
      "purplebooth/repo"
    ];

    brews = [
      "PurpleBooth/repo/git-mit"
      "asdf"
    ];

    casks = [
      "orbstack"
      #   #"carpeliam/brew/gitshorty"
    ];
  };

  system.defaults = {
    dock.autohide = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.matt = { pkgs, config, ... }: {
      home = {
        stateVersion = "23.11";
        username = lib.mkDefault "matt";
        homeDirectory = lib.mkForce "/Users/matt";

        packages = with pkgs; [
          nixpkgs-fmt
          _1password-cli
          docker
          mob
          gh
          tree
          glow
          diceware
          watchexec
          google-cloud-sdk
        ];

        sessionVariables = {
          EDITOR = "vim";
          SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
          PATH = "$HOME/.local/bin:$PATH";
        };

        file.".1password/agent.sock" = lib.mkIf pkgs.stdenv.isDarwin {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
        };

        file.".local/bin/conf-flake-refresh" = {
          text = ''
            if [ -f ~/.ssh.config ]; then
              mv ~/.ssh/config ~/.ssh/config.bak
            fi
            nix run nix-darwin -- switch --flake ~/.config/nix-darwin --fallback
            echo
            echo "Nix-Darwin configuration updated!"
            echo "To apply changes in this shell, run:"
            echo "  source ~/.zshrc"
          '';
          executable = true;
        };
      };

      programs.ssh = {
        enable = true;
        matchBlocks."*" = {
          extraOptions = {
            IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
          };
        };
      };
      # programs.gh.enable = true;

      programs.home-manager.enable = true;
      programs.direnv.enable = true;
      programs.direnv.enableZshIntegration = true;
      programs.direnv.nix-direnv.enable = true;
      programs.zsh = {
        enable = true;
        syntaxHighlighting.enable = true;
        oh-my-zsh = {
          enable = true;
          theme = "robbyrussell";
          plugins = [
            "git"
            "docker"
          ];
        };
        initContent = builtins.readFile ./.zshrc-extras;
      };

      programs.vim = {
        enable = true;
        settings = {
          number = true;
          tabstop = 2;
          expandtab = true;
          shiftwidth = 2;
        };
      };

      # TODO: git signing (see https://github.com/zgagnon/conf-flake/blob/master/hosts/Zells-MacBook-Pro/default.nix#L148)
      programs.git = {
        extraConfig = {
          rerere.enabled = true;
        };
        enable = true;
        userName = "Matt Wynne";
        userEmail = "matt.wynne@mechanical-orchard.com";
        aliases = {
          co = "checkout";
          lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        };
      };
    };

  };
}

