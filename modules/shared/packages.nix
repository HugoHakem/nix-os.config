{ pkgs }:

with pkgs; [
  # General packages for development and system management
  gnumake
  libtool
  nerdfonts
  alacritty
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  killall
  neofetch
  openssh
  sqlite
  wget
  zip
  emacs
  cowsay


#  # Encryption and security tools
 # age
 # age-plugin-yubikey
 # gnupg
 # libfido2

  # Cloud-related tools and SDKs
  #docker
  #docker-compose

  # Media-related packages
  emacs-all-the-icons-fonts
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf

  # Node.js development tools
  #nodePackages.npm # globally install npm
  #nodePackages.prettier
  #nodejs

  # Text and terminal utilities
  htop
  hunspell
  iftop
  jetbrains-mono
  jq
  ripgrep
  #tree
  #tmux
  screen
  unrar
  unzip
  zsh-powerlevel10k

  # Python packages
  python310
  python310Packages.virtualenv # globally install virtualenv
]
