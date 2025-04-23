{ config, pkgs, lib, user, git_name, git_email, ... }:

let
  xdg_configHome  = "/home/${user}/.config";
  shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib user git_name git_email; };
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

  programs = shared-programs // {
      ssh = {
        enable = true;
      };
      direnv = {
        enable =true;
        nix-direnv.enable = true;
      };
  };
}
