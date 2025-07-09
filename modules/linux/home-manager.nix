{ config, pkgs, lib, user, git_name, git_email, ... }:

let
  sharedPrograms = import ../shared/programs.nix { inherit config pkgs lib user git_name git_email; };
  sharedFiles = import ../shared/files.nix { inherit config pkgs user; };
  additionalFiles = import ./files.nix { inherit pkgs; };

  ## They are not necessarily useful on a gcp server. May be discarded.
  # vscode install extensions
  # vscodeExtensionsScript = builtins.toPath ./../shared/config/vscode/install-extensions.sh;
  # vscodeCodeBin = "${pkgs.vscode}/bin/code";
  # vscodeExtensionsFile = builtins.toPath ./../shared/config/vscode/extensions.txt;

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
    #   install-vscode-extensions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #     echo "Installing VS Code extensions..."
    #     ${pkgs.zsh}/bin/zsh ${vscodeExtensionsScript} "${vscodeCodeBin}" ${vscodeExtensionsFile}
    #   '';
    };
  };

  # enable usage of fonts installed packages
  fonts.fontconfig.enable = true;

  programs = sharedPrograms // {

    starship = sharedPrograms.starship // {
      enableBashIntegration = true;
    };

    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = { 
        ls="ls --color=auto"; # Always color ls and group directories
      };
      historyIgnore = [ 
          "pwd"
          "ls"
          "cd" 
        ]; 
      historyControl = [
        "ignoredups"
      ];
      bashrcExtra = ''
        # color help using bat
        function bathelp() {
          if [[ $# -eq 0 ]]; then
            echo "Usage: help <command> [subcommands...]"
            return 1
          fi
          "$@" --help 2>&1 | bat --language=help
        }
        export -f bathelp
      '';
      initExtra = lib.mkOrder 2000 ''
        # This is a workaround to make direnv work with VS Code's integrated terminal
        # when using the direnv extension, by making sure to reload
        # the environment the first time terminal is opened.
        #
        # See: 
        # - author problem statement: https://github.com/direnv/direnv-vscode/issues/561#issuecomment-1837462994
        # - zsh work around: https://github.com/direnv/direnv-vscode/issues/561#issuecomment-1991534148
        # - fish work around: https://github.com/direnv/direnv-vscode/issues/561#issuecomment-2310756248
        # - bash work around (requiring .envrc tinkering): https://github.com/direnv/direnv-vscode/issues/561#issuecomment-2694803523
        # 
        # Solution inspired by `fish`: 
        #
        # The variable VSCODE_INJECTION is apparently set by VS Code itself, and this is how
        # we can detect if we're running inside the VS Code terminal or not.
        # In bash, eval "$PROMPT_COMMAND" helps direnv to notice directory change and trigger envrc loading.

        if [[ -n "$VSCODE_INJECTION" && -z "$VSCODE_TERMINAL_DIRENV_LOADED" && -f .envrc ]]; then
          cd .. && eval "$PROMPT_COMMAND" && cd ~- && eval "$PROMPT_COMMAND"
          export VSCODE_TERMINAL_DIRENV_LOADED=1
        fi
      '';
    };
    
    vscode = {
      enable = true;
      package = pkgs.vscode;
    };
  };
}
