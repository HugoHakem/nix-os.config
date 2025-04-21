{ config, pkgs, user, ... }:

{
  imports = [
    ../../modules/linux/home-manager.nix
    ../../modules/shared
    ../../modules/shared/cachix
  ];

  # Turn on flag for proprietary software
  nix = {
    package = pkgs.nix;
    settings.allowed-users = [ "${user}" ];

    nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];

    gc = {
      user = "root";
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    # Deduplicate and optimize nix store
    optimise.automatic = true;
    
    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

services = { 
  # Let's be able to SSH into this machine
  openssh.enable = true;

    # Emacs runs as a daemon
  emacs = {
    enable = true;
    package = pkgs.emacs-unstable;
  };
};

# When emacs builds from no cache, it exceeds the 90s timeout default
systemd.user.services = {
  emacs = {
    serviceConfig.TimeoutStartSec = "7min";
  };
};

# It's me, it's you, it's everyone
users.users.${user} = {
  isNormalUser = true;
  extraGroups = [
    "wheel" # Enable ‘sudo’ for the user.
    "docker"
  ];
  shell = pkgs.zsh;
  # openssh.authorizedKeys.keys = keys;
};

# users.users.root = {
#   openssh.authorizedKeys.keys = keys;
# };

# # Don't require password for users in `wheel` group for these commands
# security.sudo = {
#   enable = true;
#   extraRules = [{
#     commands = [
#       {
#         command = "${pkgs.systemd}/bin/reboot";
#         options = [ "NOPASSWD" ];
#       }
#     ];
#     groups = [ "wheel" ];
#   }];
# };

fonts.packages = with pkgs; [
  dejavu_fonts
  emacs-all-the-icons-fonts
  feather-font # from overlay
  jetbrains-mono
  font-awesome
  noto-fonts
  noto-fonts-emoji
];

environment.systemPackages = with pkgs; [
  gitAndTools.gitFull
  inetutils
];

system.stateVersion = "21.05"; # Don't change this

}
