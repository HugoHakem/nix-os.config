{ pkgs }:

let
  # List all .nix files in the directory (excluding this one)
  dir = ./.;

  packageFiles = builtins.filter
    (file:
      let
        path = dir + "/${file}";
        fileType = (builtins.readDir dir)."${file}";
      in
        file != "default.nix" &&
        (
          # Keep regular .nix files
          (fileType == "regular" && builtins.match ".*\\.nix$" file != null)
          ||
          # Also allow directories that contain a default.nix
          (fileType == "directory" && builtins.pathExists (path + "/default.nix"))
        )
    )
    (builtins.attrNames (builtins.readDir dir));

  packageAttrs = builtins.foldl'
    (acc: file:
      acc // import (dir + "/${file}") { inherit pkgs; })
    {}
    packageFiles;
in
  packageAttrs
