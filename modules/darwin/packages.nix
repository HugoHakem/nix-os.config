{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  dockutil
  emacsPackages.pdf-tools
  (emacs.override { withNativeCompilation = false; })
]
