{ pkgs }:

with pkgs; [
 # Development and System Management Utilities
  bashInteractive
  coreutils
  cmake
  emacs
  gawk
  gnused # The one and only sed
  gnutar # The one and only tar
  gnumake # Necessary for emacs' vterm
  libtool
  killall # kill all the processes by name
  lsof # Files and their processes
  rsync # sync data
  ps # processes
  screen
  tmux
  tree
  tldr
  wget # fetch stuff
  zip
  unzip # extract zips
  unrar

  # Cloud-related Tools and SDKs
  google-cloud-sdk

  # Media and Fonts Utilities
  emacs-all-the-icons-fonts
  dejavu_fonts
  fd
  ffmpeg
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf

  # Text and Terminal Utilities
  bash-completion
  bat
  btop
  htop
  hunspell
  iftop
  jq
  jetbrains-mono
  ripgrep
  zsh-powerlevel10k

  # Python Utilities
  python310
  python310Packages.virtualenv # globally install virtualenv

  # Miscellaneous Utilities
  aspell
  aspellDicts.en
  neofetch
  nerdfonts
  wezterm
  sqlite
]
