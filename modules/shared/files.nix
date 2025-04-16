{ pkgs, config, user, ... }:

let 
  userDir = if pkgs.stdenv.hostPlatform.isDarwin then
    "/Users/${user}/Library/Application Support/Code/User"
  else
    "${config.xdg.configHome}/Code/User";

  vscodeKeybindings = builtins.toPath ./config/vscode/keybindings.json;
  vscodeSettings = builtins.toPath ./config/vscode/settings.json;

  vscodeKeybindingsTarget = "${userDir}/keybindings.json";
  vscodeSettingsTarget = "${userDir}/settings.json";

in
{
  "/Users/${user}/Library/Application Support/Code/User/keybindings.json" = {
    source = vscodeKeybindings; 
    force = true;
    mutable = true;
  };
  "/Users/${user}/Library/Application Support/Code/User/settings.json" = {
    source = vscodeSettings; 
    force = true;
    mutable = true;
  };
}
