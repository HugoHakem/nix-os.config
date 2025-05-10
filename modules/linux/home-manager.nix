{ config, pkgs, lib, user, git_name, git_email, ... }:

let
  sharedPrograms = import ../shared/programs.nix { inherit config pkgs lib user git_name git_email; };
  sharedFiles = import ../shared/files.nix { inherit config pkgs user; };
  additionalFiles = import ./files.nix { inherit pkgs; };

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

  # enable usage of fonts installed packages
  fonts.fontconfig.enable = true;

  programs = sharedPrograms // {
    bash = {
      enable = true;
      enableCompletion = true;
      historyControl = ["ignoreboth"];
      historyFileSize = 2000;
      initExtra = 
        let 
          oshPath = "${pkgs.oh-my-bash}";
          bashrcTemplate = builtins.readFile "${oshPath}/templates/bashrc.osh-template";
          patchedBashrc = builtins.replaceStrings 
            [ 
              "OSH_THEME=\"font\""
              "export OSH=~/.oh-my-bash" 
              "completions=(\n"
            ] 
            [ 
              "OSH_THEME=\"powerline-icon\""
              "export OSH=${oshPath}" 
              "completions=(\n\tuv\n"
            ] 
            bashrcTemplate;
        in 
          ''export HISTIGNORE="pwd:ls:cd"'' + patchedBashrc + 
          ''
            # BAR STYLE
            ## Date Format 
            OMB_THEME_POWERLINE_ICON_CLOCK="%H:%M"

            ## Icons
            USER_INFO_SSH_CHAR=$'\uef09  '
            
            OMB_THEME_POWERLINE_ICON_USER=$'\uf007 '
            OMB_THEME_POWERLINE_ICON_HOME=$'\uf015 '
            OMB_THEME_POWERLINE_ICON_EXIT_FAILURE=$'\uf00d '
            OMB_THEME_POWERLINE_ICON_EXIT_SUCCESS=$'\uf00c'

            PYTHON_VENV_CHAR=$'\ue606 '
            

            ## color mapping see ANSI table https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124
            

            USER_INFO_THEME_PROMPT_COLOR=16 # Black Blue
            USER_INFO_THEME_PROMPT_SECONDARY_COLOR="-"  # Slightly lighter navy
            USER_INFO_THEME_PROMPT_COLOR_SUDO=202

            # Clock Segment
            CLOCK_THEME_PROMPT_COLOR=16         # Muted indigo/blue-gray
            
            # Current Working Directory
            CWD_THEME_PROMPT_COLOR=27           # Standard blue

            # Python venv
            PYTHON_VENV_THEME_PROMPT_COLOR=21   # Dark Blue with hint of purple

            # Git Segment
            SCM_THEME_PROMPT_DIRTY_COLOR=124    # Red (uncommitted changes)
            SCM_THEME_PROMPT_UNSTAGED_COLOR=99  # Soft violet (unstaged changes)
            SCM_THEME_PROMPT_STAGED_COLOR=32    # Aquamarine / teal (staged)
            SCM_THEME_PROMPT_CLEAN_COLOR=39     # Clean sky blue

            # DO NOT TOUCH
            LAST_STATUS_THEME_PROMPT_COLOR=52 # darkestred
            LAST_STATUS_THEME_PROMPT_COLOR_SUCCESS=42 # green
          '';
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
