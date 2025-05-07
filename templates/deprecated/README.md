
# Templates

You can discard this note. It is rather for my own learning puporses, and it is not necessarly useful for us since we are not on NixOS but on Linux.

You will find here deprecated project template to set up a running nix environment.

The current single template `nixos-pythonml/` is not to use for python machine learning project development on Linux as it will fail. It was originally meant for full NixOS environment.

## Layout

```text
.
├── nixos-pythonml
│   ├── .envrc
│   ├── .gitignore
│   ├── .python-version
│   ├── flake.nix
│   ├── pyproject.toml
│   ├── README.md
│   └── src
└── README.md
```

## Templates Description

### NixOS Python ML

#### Note on the Package managers

Packages are handled both through `nix`, and through `uv`. As a rule of thumb:

+ You may handle any of your python packages with `uv` and anything else through `nix`. For instance there might be external system packages that should be available on your system so that the python packages work correctly. `nix` would be used in those cases.
+ You will specify your python version with `nix` for perfect reproducibility. (We don't do it in the Linux Environment because nix python expect some libraries to be on the `/nix/store`. It won't look at your `/usr/lib` or other proprietary library placeholder on linux. Then it requires extension with `LD_LIBRARY_PATH` (see bellow discussion) but it particularly fail for CUDA drivers)
+ If you have packages that is not working when installing from `uv`, you may want to specify it with `nix`
  + e.g. `pytorch`, might not recognize your GPU, and specifying with `nix` might solve the issue. However its version will be immutable and won't be able to change unless you do it through `nix`. Additionally when built from the first time, it will build from the source which is prohibitively long.
  + Hence, the reason why `uv` is more preferred to handle python dependencies.

#### How to add new packages

If you want to skip the contextualisation, jump directly at the [Summary Section](#to-summarise)

There are **4 ways to add new packages**. Even though you should be aware of the different options (for debugging time), your day to day workflow will only use last way (`uv`).

This pythonML template is meant to work on the following systems (MacOS, Linux, NixOS (supposedly Windows as well)). Let's try to understand the distinction between `nix` installed programs and the others.

+ In NixOS, and (also in our case with Nix Package Manager), packages installed will be stored in path like `/nix/store/[hash]-[package-name]` and dependecy will be listed internally such that packages installed through `nix` only look at for their dependencies in that store. This provide a complete isolation between packages and enable to add multiple version of a same packages. It contributes to the reliability and reproducibility of `nix` system.
+ The problem is that most of the programs will expect to have access to certain *runtime libraries*, such as C compiler or GPU toolkit etc. For programs installed from `nix` dependencies are handled, as mentionned, through the `nix/store`. But for foreign programs, they don't know that the `/nix/store/` exists. In Linux system the *runtime libraries* are instead expected to be listed under the `LD_LIBRARY_PATH` with the `.so` file extension. On MacOS, the equivalent would be the `DYLD_LIBRARY_PATH` and `.dyld` file extension (not that the `DYLD_LIBRARY_PATH` is not defined by default, but you can specify your runtime packages path under that variablen name).
  + **What problem this causes?**  On pure NixOS system, the `LD_LIBRARY_PATH` variable is not defined by default. Hence when installing packages from other source (like python packages from `uv`), they will still expect their *runtime dependencies* to be present in the `LD_LIBRARY_PATH`. So even though you may have the right packages installed in your `/nix/store/` you have to add those in the `LD_LIBRARY_PATH`.
    + This is what [`nix-ld`](https://github.com/nix-community/nix-ld/tree/main) is for (but it is only available fo `NixOS`).
    + Or alternatively, we can manually extend the `LD_LIBRARY_PATH`, which is the way chosen in the `flake.nix` for compatibility purposes between system.

      ```nix
      let
        ...
        # The custom list of nix packages that should be available at runtime
        LD_pkgs = 
            (with pkgs; [
                # ADD NEEDED PACKAGES HERE
                stdenv.cc.cc     # useful for compiling C/C++ code
                glib             # core application building blocks for libraries written in C
                libGL            # useful for graphical rendering, (for e.g. is required for matplotlib)
                ...
            ]) ++ pkgs.lib.optionals pkgs.stdenv.isLinux 
            (with pkgs; [ # ADD NEEDED PACKAGES HERE IF ONLY REQUIRED BY LINUX 
                # Add packages that should only be present for Linux
                cudatoolkit      # required for GPU libraries
                ...
            ])
        ;
        ...
      in
        # CUSTOM SHELL FOR OUR PROJECT
        devShells = {
            default = mkShell {
                # DEFINE THE CUSTOM LD_LIBRARY_PATH
                NIX_LD_LIBRARY_PATH = lib.makeLibraryPath LD_pkgs;
                # we add the LD_pkgs in the shell as a rule of thumb
                # what actually matter the most is that they are present in the custom LD_LIBRARY_PATH
                packages = ... ++ LD_pkgs; 
                shellHook = ''
                # Extend the original LD_LIBRARY_PATH with the `NIX_LD_LIBRARY_PATH` (but only for that shell)
                export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
                ...
                '';
            };
        };
        ...
      ```

  + **Does it apply to us with our Ubuntu machine + Nix as a package manager ?**
    + **No** because on `linux` machine or `MacOS` machine, those runtime packages will most of the time be already present. The `LD_LIBRARY_PATH` for `linux` is already set and there should be all the utilities you will ever need and same for `MacOS` (again `DYLD_LIBRARY_PATH` is not set by default but the *runtime dependencies* are already in things like `/usr/bin/`).
    + **Maybe**, because bug happens... Packages may still not work properly (and it's not because you are using nix as a package manager)
      + If it requires an external *runtime package*, (the error being something like `cannot found [name of the packages]`), extending the `LD_LIBRARY_PATH` should make the trick! And the code snippet above guarantee that you do it in an isolated fashion, and it won't corrupt your whole system. **Note:** this flake takes the assumption that you won't have any problem with your MacOS set up. Indeed, it only modify the `LD_LIBRARY_PATH` which is completly ignored on MacOS. So if you are running into errors, you may want to modify the `LD_LIBRARY_PATH` into `DYLD_LIBRARY_PATH`.

In the code snippet above, you already been introduced with **1 way to add packages**. It is related to `LD_LIBRARY_PATH`, and you may be specific to Linux or any system. Those packages will be stored in the `LD_pkgs` variable.

The next **3 ways to add new packages** are detailed in the [Summary Section](#to-summarise), but in short, they are meant for:

+ Adding `nix` packages that are not *runtime dependencies* (hence that should not be present in the `LD_LIBRARY_PATH`). This concern `uv`, or your Python version or the Python ShellHook (tool that create `.venv`)). But it could also be some specific packages your project may requires. Like `duckdb` for fast database query.
+ Adding python packages but with `nix`. Again, this shouldn't be the default and to use only if you cannot make it work through `uv`.
+ Adding python packages with `uv`. This will be your standard workflow.

#### To summarise

1. Packages that will be present in the `LD_LIBRARY_PATH`, that should be on every OS, and that you can find listed on [Nix Packages Search](https://search.nixos.org/packages). Those are stored in `LD_pkgs`.

   ```nix
    LD_pkgs = 
        (with pkgs; [
            # ADD NEEDED PACKAGES HERE
            ...
        ]) ++ pkgs.lib.optionals pkgs.stdenv.isLinux 
        (with pkgs; [
            # ADD PACKAGES THAT SHOULD ONLY BE PRESENT FOR LINUX
            ...
        ]);
   ```

2. Packages installed for python, through `nix`, because you cannot make them work with `uv`.

    ```nix
    python_with_pkgs = pkgs.python311.withPackages (pp: with pp [
        # ADD PYTHON PKGS HERE THAT YOU NEED FROM NIX REPOS
        ...
    ]);
    ```

3. Packages that should be installed through `nix` that are not python packages, and should not be available in the `LD_LIBRARY_PATH` (which are not runtime *dependencies*)

   ```nix
    shell_packages = 
        # ADD NIX PACKAGES NOT REQUIRED IN LD_LIBRARY_PATH
        (with pkgs; [
            python311Packages.venvShellHook
            mpkgs.uv
            ...
            ])
   ```

4. **The standard way** to install packages with the `uv` (this should be the default, and is actually the most important one, the others option are here for debugging purposes):

  ```bash
  uv pip install [name-of-the-package]
  ```

#### How to change Python version

Change the python distribution in `nix` [here](nixos-config/templates/pythonml/flake.nix#L48-L54)
You can then use the following command to update the `.python-version` file.

```bash
uv python pin
```

### Another Template that would have been FHS compliant

**FHS** stands for Filesystem Hierarchy Standard. It is nothing else than a map that tells where to find the tools that you need. Something along the lines of `/usr/bin/`. On NixOs, the `/usr/bin` folder doesn't exist and every tools are located in `/nix/store/` as mentionned above.
Again, it enables to have different versions of programs and any programs has view on what it needs and nothing else.
The problem is that some programs or languages do expect and **FHS** system, (like `R`) it does expect to have a `/usr/bin` folder. Then you need to add the tool of the `/nix/store` into a project specific `/usr/bin`. This is what the `pkgs.BuildFHSEnv` is for.

You may want to read the [`NixOS Wiki`](https://nixos.wiki/wiki/Python#:~:text=Installing%20packages%20with,you%20could%20use%3A) on the subject.

You could therefore have a `flake.nix` that looks like this which is from the [Ank's Neosis Set-Up](https://github.com/leoank/neusis/blob/main/templates/fhspythonml/flake.nix):

```nix
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

        ### FHS ENVIRONMENT DEFINITION
        fhsenv = pkgs.buildFHSEnv {
          name = "fhs-shell";
          targetPkgs =
            pkgs: with pkgs; [
              gcc
              cudatoolkit
              libGL
              libz
              mpkgs.uv
              python311
            ];
          profile = ''
            export VENVDIR=.venv
            if [[ -d "$VENVDIR" ]]; then
              printf "%s\n" "Skipping venv creation, '$VENVDIR' already exists"
              source "$VENVDIR/bin/activate"
            else
              printf "%s\n" "Creating new venv environment in path: '$VENVDIR'"
              python -m venv "$VENVDIR"
              source "$VENVDIR/bin/activate"
            fi
          '';
          runScript = "zsh";
        };
      in
      {
        devShells = {
          default = fhsenv.env;
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

# FHS related help
# https://discourse.nixos.org/t/best-way-to-define-common-fhs-environment/25930
# https://ryantm.github.io/nixpkgs/builders/special/fhs-environments/
```

This is a slightly more complicated environment that the one proposed in the previous template. It is not necessarly recommended as it brings its lot of confusion. It is somewhat equivalent to override the `LD_LIBRARY_PATH` for your project but it is actually even stronger. You don't want to go for this option as it conflicts with `nix` spirit to build isolated environment thanks to the `/nix/store/`. Instead here it symlink packages from the `/nix/store/` and add it in the `/usr/bin` and if I am not mistaken also in other directories ? See the documentation of [`BuildFHSEnv`](https://ryantm.github.io/nixpkgs/builders/special/fhs-environments/).

# References

+ [`NixOS Wiki Python`](https://nixos.wiki/wiki/Python)
+ **You want to read more on `LD_LIBRARY_PATH` ?** You may want to refer to this [`LD_LIBARY_PATH`](https://www.hpc.dtu.dk/?page_id=1180) or this for [`DYLD_LIBRARY_PATH`](https://medium.com/macos-is-not-linux-and-other-nix-reflections/d-o-y-ou-ld-library-path-you-6ab0a6135a33)
