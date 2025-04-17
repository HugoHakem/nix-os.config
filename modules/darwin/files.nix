{ config, pkgs, user, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome   = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome  = "${config.users.users.${user}.home}/.local/state"; 

  # Define the content of your file as a derivation
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/sh
    emacsclient -c -n &
  '';
  
  # Install vscode keybindings and settings
  userDir = "/Users/${user}/Library/Application Support/Code/User";
    
  vscodeKeybindings = builtins.toPath ./../shared/config/vscode/keybindings.json;
  vscodeSettings = builtins.toPath ./../shared/config/vscode/settings.json;

  vscodeKeybindingsTarget = "${userDir}/keybindings.json";
  vscodeSettingsTarget = "${userDir}/settings.json";
in
{
  # Raycast script so that "Run Emacs" is available and uses Emacs daemon
  "${xdg_dataHome}/bin/emacsclient" = {
    executable = true;
    text = ''
      #!/bin/zsh
      #
      # Required parameters:
      # @raycast.schemaVersion 1
      # @raycast.title Run Emacs
      # @raycast.mode silent
      #
      # Optional parameters:
      # @raycast.packageName Emacs
      # @raycast.icon ${xdg_dataHome}/img/icons/Emacs.icns
      # @raycast.iconDark ${xdg_dataHome}/img/icons/Emacs.icns

      if [[ $1 = "-t" ]]; then
        # Terminal mode
        ${pkgs.emacs}/bin/emacsclient -t $@
      else
        # GUI mode
        ${pkgs.emacs}/bin/emacsclient -c -n $@
      fi
    '';
  };
  # Emacs launcher
  "emacs-launcher.command".source = myEmacsLauncher; 

  # VSCode keybindings and settings
  "${vscodeKeybindingsTarget}" = {
    source = vscodeKeybindings; 
    force = true;
    mutable = true;
  };
  "${vscodeSettingsTarget}" = {
    source = vscodeSettings; 
    force = true;
    mutable = true;
  };
}
