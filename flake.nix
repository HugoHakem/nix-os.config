{
  description = "Starter Configuration for MacOS and NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_master.url = "github:NixOS/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs_master, home-manager, darwin, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, } @inputs:
    let
      user = "hhakem";
      git_name = "Hugo";
      git_email = "hhakem@broadinstitute.org";

      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];

      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
      devShell = system: let pkgs = nixpkgs.legacyPackages.${system}; in {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git ];
          shellHook = with pkgs; ''
            export EDITOR=vim
          '';
        };
      };

      mkApp = scriptName: system: {
        type = "app";
        program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptName} for ${system}"
          exec ${self}/apps/${system}/${scriptName}
        '')}/bin/${scriptName}";
      };
      mkLinuxApps = system: {
        "apply" = mkApp "apply" system;
        "build-switch" = mkApp "build-switch" system;
        "install" = mkApp "install" system;
        "rollback" = mkApp "rollback" system;
      };
      mkDarwinApps = system: {
        "apply" = mkApp "apply" system;
        "build" = mkApp "build" system;
        "build-switch" = mkApp "build-switch" system;
        "rollback" = mkApp "rollback" system;
      };

      # Def nixpkgs in function of system
      pkgsSystem = system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowBroken = true;
            allowInsecure = false;
            allowUnsupportedSystem = true;
          };

          overlays = # load overlay in overlayDir and provide required argument from overlayContext 
            let
              mpkgs = import nixpkgs_master {
                inherit system;
                config = {
                  allowUnfree = true;
                  allowBroken = true;
                  allowInsecure = false;
                  allowUnsupportedSystem = true;
                };
              };

              overlayDir = ./overlays;
              overlayContext = {inherit system mpkgs user git_name git_email; };

              entries = builtins.attrNames (builtins.readDir overlayDir);
              valid = builtins.filter (name:
                builtins.match ".*\\.nix" name != null ||
                builtins.pathExists (overlayDir + "/${name}/default.nix")
              ) entries;

              loadOverlay = name:
                let
                  overlayPath = overlayDir + "/${name}";
                  overlayModule = import overlayPath;
                  args = builtins.functionArgs overlayModule;
                in # If it's a function that expects named args, check if it asks for any from `overlayContext`
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
              builtins.map loadOverlay valid;
        };

    in
    {
      devShells = forAllSystems devShell;
      apps = nixpkgs.lib.genAttrs linuxSystems mkLinuxApps // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system: darwin.lib.darwinSystem {
          inherit system;
          pkgs = pkgsSystem system;
          specialArgs = let
          in
            {inherit user git_name git_email ; } // inputs;
          modules = [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                inherit user;
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./hosts/darwin
          ];
        }
      );

      homeConfigurations = nixpkgs.lib.genAttrs linuxSystems (system: 
        home-manager.lib.homeManagerConfiguration {
            pkgs = pkgsSystem system;
            extraSpecialArgs = let
            in
              {inherit user git_name git_email ; } // inputs;
            modules = [
              ./hosts/linux
            ];
          }
        );
    };
}

