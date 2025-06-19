{ config, pkgs, user, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome   = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome  = "${config.users.users.${user}.home}/.local/state"; 
  
  # Install vscode keybindings and settings and snippet
  userDir = "/Users/${user}/Library/Application Support/Code/User";
    
  vscodeKeybindings = builtins.toPath ./../shared/config/vscode/keybindings.json;
  vscodeSettings = builtins.toPath ./../shared/config/vscode/settings.json;
  vscodeSnippetSource = builtins.toPath ./../shared/config/vscode/snippets;

  # Match only .json files
  vscodeSnippetsFiles = builtins.filter
    (file: builtins.match ".*\\.json" file != null)
    (builtins.attrNames (builtins.readDir vscodeSnippetSource));

  vscodeKeybindingsTarget = "${userDir}/keybindings.json";
  vscodeSettingsTarget = "${userDir}/settings.json";
  vscodeSnippetsTarget = "${userDir}/snippets";
in

# Combine the settings with the snippet file targets
{
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
} // 
builtins.foldl'
  (acc: file:
    acc // {
      "${vscodeSnippetsTarget}/${file}" = {
        source = "${vscodeSnippetSource}/${file}";
        force = true;
        mutable = true;
      };
    }
  )
  {}
  vscodeSnippetsFiles
