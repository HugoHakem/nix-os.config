{ config, pkgs, lib, home-manager, user, ... }:

let
  # Define the content of your file as a derivation
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/sh
    emacsclient -c -n &
  '';
  # do not need for Emacs 29
  # sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
   ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    # This is a module from nix-darwin
    # Homebrew is *installed* via the flake input nix-homebrew
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true; # Ensures that global packages are available in the home manager configuration.
    users.${user} = { pkgs, config, lib, ... }:{ #configure user specific settings 
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          # sharedFiles
          additionalFiles
          { "emacs-launcher.command".source = myEmacsLauncher; }
        ];
        stateVersion = "23.11";
      };
    programs = 
      let 
        shared  = import ../shared/home-manager.nix { inherit config pkgs lib user; };
      in 
        shared // {
          zsh = shared.zsh // {
            initExtraFirst = (shared.zsh.initExtraFirst or "") + ''
              # Add VS Code CLI (code) to PATH on macOS refering to https://code.visualstudio.com/docs/setup/mac
              export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
            '';
          };
      };
      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
    manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    { path = "/Applications/Slack.app/"; }
    { path = "/Applications/Zotero.app/"; }
    { path = "/Applications/Notion.app/"; }
    { path = "/Applications/Google Chrome.app/"; }
    { path = "${pkgs.wezterm}/Applications/Wezterm.app/"; }
    { path = "/Applications/Visual Studio Code.app/"; }
    { path = "/System/Applications/Launchpad.app/"; }
   
    # {
    #   path = toString myEmacsLauncher;
    #   section = "others";
    # }
    
    # Add the share file to the dock in the section "others"
    # {
    #   path = "${config.users.users.${user}.home}/.local/share/";
    #   section = "others";
    #   options = "--sort name --view grid --display folder";
    # }

    # Add the download file to the dock in the section "others"
    # {
    #   path = "${config.users.users.${user}.home}/downloads";
    #   section = "others";
    #   options = "--sort name --view grid --display stack";
    # }
  ];

}
