{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [

  # App and package management
  appimage-run
  home-manager

  # Productivity tools
  bc # old school calculator

  # Testing and development tools
  direnv
  postgresql

  # Text and terminal utilities
  unixtools.ifconfig
  unixtools.netstat
  xclip # For the org-download package in Emacs
  xorg.xwininfo # Provides a cursor to click and learn about windows
  xorg.xrandr

  # Editor 
  vscode # added here because use casks for darwin
]
