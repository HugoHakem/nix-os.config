{ pkgs }:

with pkgs; [
  # DEVELOPMENT UTILITIES
  ## Base stuff
  bashInteractive
  coreutils
  cmake
  fd # fd is a simple, fast and user-friendly alternative to find.
  gawk
  gnused # the one and only sed
  git
  
  tree # print working directory
  tldr # get more help
  rsync # synchronize file 

  ## Fetch stuff
  wget 
  curl 

  ## Run background process
  screen
  tmux

  ## Manage processes
  killall # kill all the processes by name
  lsof # files and their processes
  ps # processes
  
  ## Manage file format
  dpkg # debian package manager 
  gnutar # the one and only tar
  unrar # rar archive
  unzip # extract zips
  zip
  
  ## Cloud-related Tools and SDKs
  google-cloud-sdk

  # Text and Terminal Utilities
  bash-completion
  bat # as a `cat` replacement
  hunspell
  iftop
  jq
  jetbrains-mono
  ripgrep
  xdg-utils
  zsh-powerlevel10k

  # MISCELLANEOUS UTILITIES
  ## spell checker
  aspell 
  aspellDicts.en
  ## my terminal
  wezterm
  ## SQL
  sqlite
  ## Environment Management
  direnv
  ## Video processing needs
  # ffmpeg

  # PYTHON UTILITIES # Rather defined in templates for python project specific.
  # python310
  # python310Packages.virtualenv # globally install virtualenv

  # EMACS UTILITIES
  # emacs-all-the-icons-fonts
  # libtool # for Emacs vterm
  # gnumake # Necessary for emacs' vterm

  # FONTS UTILITIES
  # dejavu_fonts
  # font-awesome
  # hack-font
  # noto-fonts
  # noto-fonts-emoji
  # meslo-lgs-nf
]
# If you need all the nerd-fonts
# ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)