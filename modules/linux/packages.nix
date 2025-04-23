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
  postgresql

  # Text and terminal utilities
  unixtools.ifconfig
  unixtools.netstat
  xclip # For the org-download package in Emacs
  xorg.xwininfo # Provides a cursor to click and learn about windows
  xorg.xrandr

  # Editor 
  vscode # added here because use casks for darwin
  emacs # emacs is installed in darwin specifically in the systemPackages

  # GPU utilities
  nvtopPackages.full
  btop
  htop

  # fonts
  dejavu_fonts
  emacs-all-the-icons-fonts
  feather-font # from overlay
  jetbrains-mono
  font-awesome
  noto-fonts
  noto-fonts-emoji
]
