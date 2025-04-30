{ config, pkgs, lib, user, git_name, git_email, ... }:

let
  sharedPrograms = import ../shared/programs.nix { inherit config pkgs lib user git_name git_email; };
  sharedFiles = import ../shared/files.nix { inherit config pkgs user; };
  additionalFiles = import ./files.nix { inherit user; };

  # vscode install extensions
  vscodeExtensionsScript = builtins.toPath ./../shared/config/vscode/install-extensions.sh;
  vscodeCodeBin = "${pkgs.vscode}/bin/code";
  vscodeExtensionsFile = builtins.toPath ./../shared/config/vscode/extensions.txt;

in
{
  imports = [
    ../shared/mutable.nix
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix {};
    file = sharedFiles // additionalFiles;
    stateVersion = "21.05";
    activation = {
      install-vscode-extensions = lib.hm.dag.entryAfter ["writeBoundary"] ''
        echo "Installing VS Code extensions..."
        ${pkgs.zsh}/bin/zsh ${vscodeExtensionsScript} "${vscodeCodeBin}" ${vscodeExtensionsFile}
      '';
    };
  };

  programs = sharedPrograms // {
    bash = {
      enable = true;
      enableCompletion = true;
      historyControl = ["ignoreboth"];
      historyFile = "1000";
      historyFileSize = 2000;
      shellAliases = {
        # some more ls aliases
        ll = "ls -alF";
        la = "ls -A";
        l = "ls -CF";
        alert = ''
  notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e 's/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//')"
'';

      };
      initExtra = ''
        # If not running interactively, don't do anything
        case $- in
            *i*) ;;
              *) return;;
        esac

        # Just in case add the PATH (it's extracted from the original backup .profile of the VM)
        # set PATH so it includes user's private bin if it exists
        if [ -d "$HOME/bin" ] ; then
            PATH="$HOME/bin:$PATH"
        fi

        # set PATH so it includes user's private bin if it exists
        if [ -d "$HOME/.local/bin" ] ; then
            PATH="$HOME/.local/bin:$PATH"
        fi

        # make less more friendly for non-text input files, see lesspipe(1)
        [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

        # set a fancy prompt (non-color, unless we know we "want" color)
        case "$TERM" in
            xterm-color|*-256color) color_prompt=yes;;
        esac

        # enable color support of ls and also add handy aliases
        if [ -x /usr/bin/dircolors ]; then
          test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
          alias ls='ls --color=auto'
          alias grep='grep --color=auto'
          alias fgrep='fgrep --color=auto'
          alias egrep='egrep --color=auto'
        fi

      '';
    };
    ssh = {
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    vscode = {
      enable = true;
      package = pkgs.vscode;
    };
  };
}
