{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs_master.url = "github:NixOS/nixpkgs/master";
    systems.url = "github:nix-systems/default";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
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

        LD_pkgs = # PACKAGES FOR LD_LIBRARY_PATH
          (with pkgs; [
            # ADD NEEDED PACKAGES HERE
            stdenv.cc.cc     # useful for compiling C/C++ code
            glib             # core application building blocks for libraries written in C
            libGL            # useful for graphical rendering, (for e.g. is required for matplotlib)

          ]) ++ pkgs.lib.optionals pkgs.stdenv.isLinux 
          (with pkgs; [
            # ADD NEEDED PACKAGES HERE IF ONLY REQUIRED FOR LINUX
            cudatoolkit      # required for GPU libraries

            # This is required for most app that uses graphics api
            # linuxPackages.nvidia_x11
          ]);

        python_with_pkgs = pkgs.python311.withPackages (pp: with pp; [
          # ADD PYTHON PKGS HERE THAT YOU NEED FROM NIX REPOS

        ]);
        shell_pkgs = (with pkgs; [
          # ADD NIX PACKAGES NOT REQUIRED IN LD_LIBRARY_PATH
          python311Packages.venvShellHook
          mpkgs.uv # `uv` is recommended for package management inside nix env. Specify the master branch (latest `uv`).
          
          # Quatro is used for doc generation with nbdev
          # quatro 

          # Data sharing tools
          # syncthing
          # jq

          # Data inspections tools
          # duckdb
          # mongodb

          # video tools
          # ffmpeg
        
        ]);
      in
      with pkgs;
      {
        devShells = {
          default =
            let
              
            in
            mkShell {
              NIX_LD = runCommand "ld.so" { } ''
                ln -s "$(cat '${pkgs.stdenv.cc}/nix-support/dynamic-linker')" $out
              '';
              NIX_LD_LIBRARY_PATH = lib.makeLibraryPath LD_pkgs;
              packages = [python_with_pkgs] ++ shell_packages ++ LD_pkgs;
              venvDir = "./.venv";
              postVenvCreation = ''
                unset SOURCE_DATE_EPOCH
              '';
              postShellHook = ''
                # allow uv pip to install wheels
                unset SOURCE_DATE_EPOCH
              '';
              shellHook = ''
                # Forces uv to never download its own Python interpreter (only use the system one).
                # https://nixos.wiki/wiki/Python#:~:text=You%20won%27t%20be%20able%20to%20use%20Python%20binaries%20installed%20by%20uv.%20Make%20sure%20to%20set%20the%20UV_PYTHON_DOWNLOADS%3Dnever%20environment%20variable%20in%20your%20shell%20to%20stop%20uv%20from%20downloading%20Python%20binaries.
                export UV_PYTHON_DOWNLOADS=never

                # extend the LD_LIBRARY_PATH to include opengl-driver if there and NIX_LD_LIBRARY_PATH
                export LD_LIBRARY_PATH="/run/opengl-driver/lib":$LD_LIBRARY_PATH
                export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH

                # Avoid annoying prompts from keyring libraries asking for gnome-keyring, kwallet, etc. (especially useful on headless servers).
                export PYTHON_KEYRING_BACKEND=keyring.backends.fail.Keyring

                # Helps PyTorch find CUDA toolkit.
                export CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}

                # Triggers creation/activation of the .venv virtualenv.
                runHook venvShellHook

                # Add nix python packages to the PYTHONPATH
                export PYTHONPATH=${python_with_pkgs}/${python_with_pkgs.sitePackages}:$PYTHONPATH
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

# Data syncthing commands
# syncthing cli show system | jq .myID
# syncthing cli config devices add --device-id $DEVICE_ID_B
# syncthing cli config folders $FOLDER_ID devices add --device-id $DEVICE_ID_B
# syncthing cli config devices $DEVICE_ID_A auto-accept-folders set true
