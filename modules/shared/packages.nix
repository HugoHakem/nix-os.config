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

  ## Package manager
  pixi # provide pixi globally but may prefer to provide it on per project basis

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
  starship

  # MISCELLANEOUS UTILITIES
  ## spell checker
  aspell 
  aspellDicts.en
  ## SQL
  sqlite
  ## Environment Management
  direnv

  # FONTS UTILITIES
  # for my oh-my-bash powerline theme
  powerline-fonts 
  nerd-fonts.symbols-only
  nerd-fonts.fira-code 
  nerd-fonts.fira-mono
  nerd-fonts.hack
  nerd-fonts.jetbrains-mono

  # EMACS UTILITIES
  # emacs-all-the-icons-fonts
  # libtool # for Emacs vterm
  # gnumake # Necessary for emacs' vterm

]
# If you need all the nerd-fonts
# ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)