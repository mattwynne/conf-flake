{pkgs, lib, ...}:

{  
  nixpkgs = {
    config.allowUnfree = true;
  };

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  services.nix-daemon.enable = true;

  programs.zsh.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };

    brews = [
    ];

#    casks = [
#      "cursor"
#      "logseq"
#      "raycast"
#      "slack"
#      "tuple"
#      "tandem"
#      "warp"
#      "arc"
#      "readdle-spark"
#      "docker"
#    ];
  }; 

  system.defaults = {
    dock.autohide = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.matt = {pkgs, config, ...}: {
      home = {
        stateVersion = "23.11";
        username = lib.mkDefault "matt";
        homeDirectory = lib.mkForce "/Users/matt";

        packages = with pkgs; [
          _1password
          docker
        ];

        sessionVariables = {
          EDITOR = "vim";
          SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
        };

        file.".1password/agent.sock" = lib.mkIf pkgs.stdenv.isDarwin {
          source = config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
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
      programs.gh.enable = true;

      programs.home-manager.enable = true;
      programs.direnv.enable = true;
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
      enable = true;
      userName = "Matt Wynne";
      userEmail = "matt.wynne@mechanical-orchard.com";
    };
  };

};

nix.settings = {
  auto-optimise-store = true;
};
}
