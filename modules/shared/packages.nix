{ pkgs }:

with pkgs; [
 # Development and System Management Utilities
  bashInteractive
  coreutils
  cmake
  git
  gawk
  gnused # The one and only sed
  gnutar # The one and only tar
  gnumake # Necessary for emacs' vterm
  libtool # for Emacs vterm
  killall # kill all the processes by name
  lsof # Files and their processes
  rsync # sync data
  ps # processes
  screen
  tmux
  tree
  tldr
  wget # fetch stuff
  curl # fetch stuff
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
  hunspell
  iftop
  jq
  jetbrains-mono
  ripgrep
  xdg-utils
  zsh-powerlevel10k

  # GPU utilities
  nvtopPackages.full
  btop
  htop

  # Python Utilities
  python310
  python310Packages.virtualenv # globally install virtualenv

  # Environment Management
  direnv

  # Miscellaneous Utilities
  aspell
  aspellDicts.en
  neofetch
  nerdfonts
  wezterm
  sqlite
]
