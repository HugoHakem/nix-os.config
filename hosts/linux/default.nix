{ config, pkgs, user, ... }:

{
  imports = [
    ../../modules/linux/home-manager.nix
    ../../modules/shared/cachix
  ];

  # Turn on flag for proprietary software
  nix = {
    package = pkgs.nix;
    settings.trusted-users = [ "root" "${user}" ];

    nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];

    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 30d";
    };
    
    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

services = { 
  # Let's be able to SSH into this machine
  ssh-agent.enable = true;
  
  # EMACS UTILITIES
  # Emacs runs as a daemon
  # emacs = {
  #   enable = true;
  #   package = pkgs.emacs-unstable;
  # };
};

# EMACS UTILITIES
# When emacs builds from no cache, it exceeds the 90s timeout default
# systemd.user.services = {
#   emacs = {
#     serviceConfig.TimeoutStartSec = "7min";
#   };
# };
}
