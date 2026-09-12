{ pkgs, lib, ... }:

{
  nixpkgs = {
    config.allowUnfree = true;
  };

  nix = {
    enable = false;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = "matt";
    defaults = {
      dock.autohide = true;
    };
      # Following line should allow us to avoid a logout/login cycle
      # /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  };

  environment.systemPackages = [
    # pkgs.devenv
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
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
      "ghostty"
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
	    direnv
            nix-direnv
            tree
            (writeShellScriptBin "home-manager-reload" ''
              exec darwin-rebuild switch --flake ~/.config/nix-darwin "$@"
            '')
          ];

          sessionPath = [
            "$HOME/.local/bin"
          ];

          sessionVariables = {
            EDITOR = "vim";
            SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
          };

          # file.".1password/agent.sock" = lib.mkIf pkgs.stdenv.isDarwin {
          #   source = config.lib.file.mkOutOfStoreSymlink
          #     "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
          # };

        };

	programs = {
	  direnv = {
	    enable = true;
	    enableBashIntegration = true; # see note on other shells below
	    nix-direnv.enable = true;
	  };
          zsh = {
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
  };
}
