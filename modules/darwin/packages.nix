{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  dockutil
  nodejs_24 # to install latest version of codex

  # EMACS UTILITIES
  # emacsPackages.pdf-tools
]
