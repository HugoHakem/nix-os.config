{ config, pkgs, user,... }:

let
  vscodeExtensions = import ../../modules/shared/vscode-ext-list.nix {};
in
{
  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
    ../../modules/shared/cachix
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nix;
    settings.trusted-users = [ "@admin" "${user}" ];

    gc = {
      user = "root";
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs; [
    emacs
    (pkgs.writeShellScriptBin "glibtool" "exec ${pkgs.libtool}/bin/libtool $@")
    ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; }); 

  launchd.user.agents = {
    emacs = {
      path = [ config.environment.systemPath ]; 
      serviceConfig = {
        KeepAlive = true;
        ProgramArguments = [
          "/bin/sh"
          "-c"
          "/bin/wait4path ${pkgs.emacs}/bin/emacs && exec ${pkgs.emacs}/bin/emacs --fg-daemon"
        ];
      StandardErrorPath = "/tmp/emacs.err.log";
      StandardOutPath = "/tmp/emacs.out.log";
      };
    };
    install-vscode-extension = {
      path = [ config.environment.systemPath ];
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = false;
        ProgramArguments = [
          "/bin/zsh"
          "-c"
          ''
            # Loop through each extension and install if not already present
            for extension in ${toString vscodeExtensions}; do
              if ! /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --list-extensions | grep -q "$extension"; then
                echo "Installing VS Code extension $extension..."
                /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension $extension
              else
                echo "VS Code extension $extension already installed."
              fi
            done
          ''
        ];
        StandardOutPath = "/tmp/vscode-extension-install.log";
        StandardErrorPath = "/tmp/vscode-extension-install.err";
      };
    };
  };

  system = {
    stateVersion = 4;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = false;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };
}
