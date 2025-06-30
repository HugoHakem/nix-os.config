{ system, mpkgs }:

let
  overlayDir = ./.;
  overlayContext = { inherit system mpkgs; };

  entries = builtins.attrNames (builtins.readDir overlayDir);
  valid = builtins.filter
    (file:
      let
        path = "${overlayDir}/${file}";
        fileType = (builtins.readDir overlayDir)."${file}";
      in
        file != "default.nix" &&
        (
          # Keep regular .nix files
          (fileType == "regular" && builtins.match ".*\\.nix$" file != null)
          ||
          # Also allow directories that contain a default.nix
          (fileType == "directory" && builtins.pathExists "${path}/default.nix")
        )
    ) entries;

  loadOverlay = name:
    let
      overlayPath = overlayDir + "/${name}";
      overlayModule = import overlayPath;
      args = builtins.functionArgs overlayModule;
    in
      if args != {} then
        let
          inputKeys = builtins.attrNames args;
          missing = builtins.filter (key: !(builtins.hasAttr key overlayContext)) inputKeys;
        in
          if missing != [] then
            builtins.throw "Overlay ${name} is missing required keys: ${builtins.toString missing}"
          else
            overlayModule (builtins.intersectAttrs args overlayContext)
      else
        overlayModule;

in
  builtins.map loadOverlay valid
