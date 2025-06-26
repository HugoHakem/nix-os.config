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
    };
    
    vscode = {
      enable = true;
      package = pkgs.vscode;
    };
  };
}
