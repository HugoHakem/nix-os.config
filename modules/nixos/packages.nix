{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [

  # App and package management
  appimage-run
  gnumake
  cmake
  home-manager

  # Productivity tools
  bc # old school calculator

  # Testing and development tools
  direnv
  postgresql
  libtool # for Emacs vterm

  # Screenshot and recording tools
  flameshot

  # Text and terminal utilities
  tree
  unixtools.ifconfig
  unixtools.netstat
  xclip # For the org-download package in Emacs
  xorg.xwininfo # Provides a cursor to click and learn about windows
  xorg.xrandr

  # File and system utilities
  inotify-tools # inotifywait, inotifywatch - For file system events
  i3lock-fancy-rapid
  libnotify
  pcmanfm # File browser
  sqlite
  xdg-utils

  # Editor 
  vscode # added here because use casks for darwin
]
