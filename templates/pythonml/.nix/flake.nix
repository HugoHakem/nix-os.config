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
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.cudaSupport = true;
        };

        mpkgs = import inputs.nixpkgs_master {
          inherit system;
          config.allowUnfree = true;
          config.cudaSupport = true;
        };
        customPackages = import ./packages { inherit pkgs; };

        # General packages for your dev shell
        packages = (with pkgs; [
          # e.g., pandoc, duckdb 
        ]) ++ (with mpkgs; [# latest nixpkgs master
          uv
        ]) ++ (with customPackages; [
          # e.g, package-name
        ]);

        venvDir = "./.venv";
        venvBinLinks = [ ]; # e.g, pkgs.pandoc may be required for some python lib and this make sure they are available
        
      in
      with pkgs;
      {
        devShells = {
          default =
            mkShell {
              packages = packages;
              shellHook = ''
                # Forces uv to never download its own Python interpreter (only use the system one).
                # https://nixos.wiki/wiki/Python#:~:text=You%20won%27t%20be%20able%20to%20use%20Python%20binaries%20installed%20by%20uv.%20Make%20sure%20to%20set%20the%20UV_PYTHON_DOWNLOADS%3Dnever%20environment%20variable%20in%20your%20shell%20to%20stop%20uv%20from%20downloading%20Python%20binaries.
                # export UV_PYTHON_DOWNLOADS=never

                # Avoid annoying prompts from keyring libraries asking for gnome-keyring, kwallet, etc. (especially useful on headless servers).
                export PYTHON_KEYRING_BACKEND=keyring.backends.fail.Keyring

                # allow uv pip to install wheels
                unset SOURCE_DATE_EPOCH

                # Triggers creation/activation of the .venv virtualenv.
                if [ -d "${venvDir}" ]; then
                  echo "Skipping venv creation, '${venvDir}' already exists"
                else
                  echo "Creating new venv environment in path: '${venvDir}'"
                  uv venv "${venvDir}"

                  # Symlink selected binaries into .venv/bin if any are specified
                  if [ ${toString (builtins.length venvBinLinks)} -gt 0 ]; then
                    echo "Linking requested CLI tools into ${venvDir}/bin..."
                  ${lib.concatStringsSep "\n" (map (pkg: ''
                    for bin in ${pkg}/bin/*; do
                      ln -sf "$bin" "${venvDir}/bin/$(basename "$bin")"
                      echo " → Linked $(basename "$bin")"
                    done
                  '') venvBinLinks)}
                  fi

                fi

                # FEEL FREE TO UPDATE WITH --extra name-of-extra-dependencies-in-pyproject.toml
                uv sync
                source "${venvDir}/bin/activate"
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