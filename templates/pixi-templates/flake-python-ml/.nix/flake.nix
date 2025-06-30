{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs_master.url = "github:NixOS/nixpkgs/master";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        mpkgs = import inputs.nixpkgs_master {
          inherit system;
          config.allowUnfree = true;
          config.cudaSupport = true;
        };

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.cudaSupport = true;
          overlays = import ./overlays { inherit system mpkgs; };
        };

        # General packages for your dev shell
        packages = (with pkgs; [
          pixi
          # e.g, package-name
        ]);
        
      in
      with pkgs;
      {
        devShells = {
          default =
            mkShell {
              packages = packages;
              shellHook = ''
                # Avoid annoying prompts from keyring libraries asking for gnome-keyring, kwallet, etc. (especially useful on headless servers).
                export PYTHON_KEYRING_BACKEND=keyring.backends.fail.Keyring

                # FEEL FREE TO UPDATE WITH --extra name-of-extra-dependencies-in-pyproject.toml
                eval "$(pixi shell-hook --environment dev)"
              '';
            };
        };
      }
    );
}
# Things one might need for debugging or adding compatibility
# export CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}
# export LD_LIBRARY_PATH=${pkgs.cudaPackages.cuda_nvrtc}/lib
# export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
# export EXTRA_CCFLAGS="-I/usr/include"