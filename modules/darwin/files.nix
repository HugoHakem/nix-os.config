{ config, pkgs, user, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome   = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome  = "${config.users.users.${user}.home}/.local/state"; 
  
  # Install vscode keybindings and settings
  userDir = "/Users/${user}/Library/Application Support/Code/User";
    
  vscodeKeybindings = builtins.toPath ./../shared/config/vscode/keybindings.json;
  vscodeSettings = builtins.toPath ./../shared/config/vscode/settings.json;

  vscodeKeybindingsTarget = "${userDir}/keybindings.json";
  vscodeSettingsTarget = "${userDir}/settings.json";
in
{
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
