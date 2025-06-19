{ pkgs }:

let
  # def variable
in {
#   package-name = pkgs.stdenv.mkDerivation { # the variable name is how you refer to the package in flake.nix
#     pname = "package-name"; # name of the package in the nix-profile dir
#     version = "1.0.0"; # version of the package (mandatory)
#     src = pkgs.fetchurl {
#       url = "url";
#       sha256 = lib.fakeSha256;
#     };
#     phases = [ "installPhase" ];
#     installPhase = ''
#       mkdir -p $out/bin
#       cp $src $out/bin/cli-name
#       chmod +x $out/bin/cli-name
#     '';
#   };
}