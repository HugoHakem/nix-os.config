{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [

  # App and package management
  home-manager

  # Productivity tools
  bc # old school calculator

  # Testing and development tools
  postgresql

  # Text and terminal utilities
  unixtools.ifconfig
  unixtools.netstat
  xclip # clipboard manipulation tool
  xorg.xwininfo # Provides a cursor to click and learn about windows
  xorg.xrandr

  # Editor 
  vscode # added here because use casks for darwin
  
  # GPU utilities
  nvtopPackages.full
  btop
  htop

  # EMACS UTILITIES
  # emacs # In darwin, is specifically installed in the systemPackages
]
