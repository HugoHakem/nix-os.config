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
    # onActivation.cleanup = "uninstall";

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)
    # masApps = {
    #  "1password" = 1333542190;
    #  "wireguard" = 1451685025;
    # };
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
        vscode = {
          enable = true;
          extensions = with pkgs.vscode-marketplace; [
          # Add your extensions here
          ## nix interpreter
          bbenoist.nix
          ## ruff
          charliermarsh.ruff
          ## copilot
          github.copilot
          github.copilot-chat
          ## git utils
          donjayamanne.githistory
          eamodio.gitlens
          ## python
          ms-python.debugpy
          ms-python.python
          ms-python.vscode-pylance
          ## jupyter
          ms-toolsai.jupyter
          ms-toolsai.jupyter-keymap
          ms-toolsai.jupyter-renderers
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.vscode-jupyter-slideshow
          ## remote
          # ms-vscode-remote.vscode-remote-extensionpack # not handled
          ms-vscode-remote.remote-containers
          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-ssh-edit
          ms-vscode-remote.remote-wsl
          ms-vscode.remote-explorer
          ms-vscode.remote-server
          ## collaboration
          ms-vsliveshare.vsliveshare
          ## docker
          ms-azuretools.vscode-docker
          ## markdown
          davidanson.vscode-markdownlint
        ];
        ## to add package from open-vsx-release
        #  ++ (with prev.open-vsx-release; [
        #   rust-lang.rust-analyzer
        #   golang.go
        # ]);;
          keybindings = [
            # define keybinding to move a terminal into NewWindow
            {
              "key"= "alt+x o";
              "command"= "workbench.action.terminal.moveIntoNewWindow";
              "when"= "terminalHasBeenCreated && terminalIsOpen || terminalIsOpen && terminalProcessSupported";
            }
            # define others keybindings if necessary...
          ];
          userSettings = {
            "remote.SSH.showLoginTerminal"= true;
            "security.workspace.trust.untrustedFiles"= "open";
          };
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
