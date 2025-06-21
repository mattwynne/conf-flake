{ pkgs, lib, ... }:

{
  nixpkgs = {
    config.allowUnfree = true;
  };

  nix = {
    enable = true;
    settings = {
      trusted-users = [
        "@admin"
        "matt"
      ];
    };
    linux-builder = {
      enable = true;
    };

    #     ephemeral = true;
    #     package = pkgs.darwin.linux-builder-x86_64;
    #   };
  };

  # Make both architectures available
  # nix.settings.extra-platforms = ["i686-linux" "aarch64-darwin"];

  # nix.linux-builder = {
  #     boot.binfmt.emulatedSystems = [ "x86_64-linux" ];  # <-- Now it's inside config
  #     nix.settings.extra-platforms = [ "x86_64-linux" "aarch64-linux" ];
  #   };
  # };
  # ids.gids.nixbld = 350;

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = "matt";
    defaults = {
      dock.autohide = true;
    };
  };

  environment.systemPackages = [
    # pkgs.devenv
  ];

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
    ];
  };

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    users.matt =
      { pkgs, config, ... }:
      {
        home = {
          stateVersion = "25.05";
          username = lib.mkDefault "matt";
          homeDirectory = lib.mkForce "/Users/matt";

          packages = with pkgs; [
            nixfmt-rfc-style
          ];

          sessionVariables = {
            EDITOR = "vim";
            # SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
            PATH = "$HOME/.local/bin:$PATH";
          };

          # file.".1password/agent.sock" = lib.mkIf pkgs.stdenv.isDarwin {
          #   source = config.lib.file.mkOutOfStoreSymlink
          #     "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
          # };

        };

        programs.zsh = {
          enable = true;
          syntaxHighlighting.enable = true;
          oh-my-zsh = {
            enable = true;
            theme = "robbyrussell";
            plugins = [
              "git"
            ];
          };
          initContent = builtins.readFile ./.zshrc-extras;
        };

        # programs.ssh = {
        # enable = true;
        #   matchBlocks."*" = {
        #     extraOptions = {
        #       IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
        #     };
        #   };
        # };

      };
  };
}
