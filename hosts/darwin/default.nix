{ config, pkgs, user,... }:

{
  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/shared/cachix
  ];

  # Setup user, packages
  nix = {
    package = pkgs.nix;
    settings.trusted-users = [ "@admin" "${user}" ];

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system = {
    stateVersion = 4;

    # Turn off NIX_PATH warnings now that we're using flakes
    checks.verifyNixPath = false;
    
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

  # Load configuration that is shared across users
  # EMACS UTILITIES
  # environment.systemPackages = with pkgs; [
  #   emacs
  #   (pkgs.writeShellScriptBin "glibtool" "exec ${pkgs.libtool}/bin/libtool $@")
  #   ]; 

  # See https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-launchd.user.agents
  # launchd.user.agents = { 
  #   emacs = {
  #     path = [ config.environment.systemPath ]; 
  #     serviceConfig = {
  #       KeepAlive = true;
  #       ProgramArguments = [
  #         "/bin/sh"
  #         "-c"
  #         "/bin/wait4path ${pkgs.emacs}/bin/emacs && exec ${pkgs.emacs}/bin/emacs --fg-daemon"
  #       ];
  #     StandardErrorPath = "/tmp/emacs.err.log";
  #     StandardOutPath = "/tmp/emacs.out.log";
  #     };
  #   };
  # };
}
