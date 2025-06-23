<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->
<!-- markdownlint-disable MD041 MD047 MD059 -->

# Templates (Deprecated)

> **Note:** This section is primarily for my own learning purposes and is not necessarily useful for most users, as it targets NixOS rather than Linux.

Here you will find deprecated project templates for setting up a Nix environment.

The current template, `nixos-pythonml/`, should **not** be used for Python machine learning project development on Linux, as it will fail. It was originally intended for a full NixOS environment.

## Layout

```text
.
└── nixos-pythonml
    ├── .envrc
    ├── .gitignore
    ├── .python-version
    ├── flake.nix
    ├── pyproject.toml
    ├── README.md
    └── src
```

## Template Description

### NixOS Python ML

#### Note on Package Managers

Packages are managed both through `nix` and `uv`. As a rule of thumb:

+ Handle your Python packages with `uv` and everything else through `nix`. For instance, there may be external system packages required for your Python packages to work correctly—use `nix` for those cases.
+ Specify your Python version with `nix` for perfect reproducibility. (This is not done in the Linux environment because Nix Python expects some libraries to be in `/nix/store`, not in `/usr/lib` or other proprietary library locations on Linux. This requires extending `LD_LIBRARY_PATH`—see below—but particularly fails for CUDA drivers.)
+ If a package does not work when installed from `uv`, you may want to specify it with `nix`.
  + For example, `pytorch` might not recognize your GPU, and specifying it with `nix` might solve the issue. However, its version will be immutable and can only be changed through `nix`. Additionally, building from source can be prohibitively slow.
  + This is why `uv` is generally preferred for handling Python dependencies.

#### How to Add New Packages

If you want to skip the context, jump directly to the [Summary Section](#to-summarise).

There are **four ways to add new packages**. While you should be aware of the different options (for debugging), your day-to-day workflow will primarily use the last method (`uv`).

This Python ML template is intended to work on the following systems: macOS, Linux, NixOS (and supposedly Windows). Let's clarify the distinction between `nix`-installed programs and others.

+ In NixOS (and also when using the Nix Package Manager), packages are installed in paths like `/nix/store/[hash]-[package-name]`, and dependencies are managed internally so that packages installed through `nix` only look for their dependencies in that store. This provides complete isolation between packages and enables multiple versions of the same package, contributing to the reliability and reproducibility of the Nix system.
+ The problem is that most programs expect access to certain *runtime libraries*, such as a C compiler or GPU toolkit. For programs installed from `nix`, dependencies are handled through the `/nix/store`. But for foreign programs, they are unaware of `/nix/store/`. On Linux, runtime libraries are expected to be listed under the `LD_LIBRARY_PATH` with `.so` file extensions. On macOS, the equivalent is `DYLD_LIBRARY_PATH` and `.dylib` file extensions (note that `DYLD_LIBRARY_PATH` is not defined by default, but you can specify your runtime package paths under that variable).
  + **What problem does this cause?** On pure NixOS systems, the `LD_LIBRARY_PATH` variable is not defined by default. When installing packages from other sources (like Python packages from `uv`), they will still expect their *runtime dependencies* to be present in `LD_LIBRARY_PATH`. So even if you have the right packages installed in `/nix/store/`, you have to add them to `LD_LIBRARY_PATH`.
    + This is what [`nix-ld`](https://github.com/nix-community/nix-ld/tree/main) is for (but it is only available for NixOS).
    + Alternatively, you can manually extend `LD_LIBRARY_PATH`, which is the approach chosen in `flake.nix` for compatibility between systems.

      ```nix
      let
        ...
        # The custom list of nix packages that should be available at runtime
        LD_pkgs = 
            (with pkgs; [
                # ADD NEEDED PACKAGES HERE
                stdenv.cc.cc     # useful for compiling C/C++ code
                glib             # core application building blocks for libraries written in C
                libGL            # useful for graphical rendering, e.g., required for matplotlib
                ...
            ]) ++ pkgs.lib.optionals pkgs.stdenv.isLinux 
            (with pkgs; [ # ADD PACKAGES HERE IF ONLY REQUIRED BY LINUX 
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
                # Add LD_pkgs to the shell as a rule of thumb
                packages = ... ++ LD_pkgs; 
                shellHook = ''
                # Extend the original LD_LIBRARY_PATH with the `NIX_LD_LIBRARY_PATH` (only for this shell)
                export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
                ...
                '';
            };
        };
        ...
      ```

  + **Does this apply to us with our Ubuntu machine + Nix as a package manager?**
    + **No**, because on Linux or macOS, those runtime packages are usually already present. The `LD_LIBRARY_PATH` for Linux is already set and should include all the utilities you need; the same applies for macOS (though `DYLD_LIBRARY_PATH` is not set by default, runtime dependencies are already in locations like `/usr/bin/`).
    + **Maybe**, because bugs can still occur. Packages may not work properly (and it's not necessarily because you are using Nix as a package manager).
      + If an external *runtime package* is required (the error might be something like `cannot find [name of the package]`), extending `LD_LIBRARY_PATH` should resolve the issue. The code snippet above ensures this is done in an isolated fashion and won't corrupt your system. **Note:** This flake assumes you won't have issues with your macOS setup. It only modifies `LD_LIBRARY_PATH`, which is ignored on macOS. If you encounter errors, you may want to modify `DYLD_LIBRARY_PATH` instead.

In the code snippet above, you have already seen **one way to add packages**—those related to `LD_LIBRARY_PATH`, which may be specific to Linux or any system. These packages are stored in the `LD_pkgs` variable.

The next **three ways to add new packages** are detailed in the [Summary Section](#to-summarise), but in short, they are for:

+ Adding `nix` packages that are not *runtime dependencies* (i.e., should not be present in `LD_LIBRARY_PATH`). This includes `uv`, your Python version, or the Python ShellHook (the tool that creates `.venv`). It could also be specific packages your project requires, like `duckdb` for fast database queries.
+ Adding Python packages with `nix`. This should not be the default and should only be used if you cannot make it work through `uv`.
+ Adding Python packages with `uv`. This will be your standard workflow.

#### To Summarise

1. Packages that will be present in `LD_LIBRARY_PATH`, should be on every OS, and can be found on [Nix Packages Search](https://search.nixos.org/packages). These are stored in `LD_pkgs`.

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

2. Packages installed for Python through `nix`, because you cannot make them work with `uv`.

    ```nix
    python_with_pkgs = pkgs.python311.withPackages (pp: with pp [
        # ADD PYTHON PKGS HERE THAT YOU NEED FROM NIX REPOS
        ...
    ]);
    ```

3. Packages that should be installed through `nix` that are not Python packages and should not be available in `LD_LIBRARY_PATH` (i.e., not runtime dependencies):

   ```nix
    shell_packages = 
        # ADD NIX PACKAGES NOT REQUIRED IN LD_LIBRARY_PATH
        (with pkgs; [
            python311Packages.venvShellHook
            mpkgs.uv
            ...
            ])
   ```

4. **The standard way** to install packages with `uv` (this should be the default and is the most important; the other options are mainly for debugging):

  ```bash
  uv pip install [name-of-the-package]
  ```

#### How to Change Python Version

Change the Python distribution in `nix` the [flake.nix](https://github.com/HugoHakem/nix-os.config/blob/main/templates/deprecated/nixos-pythonml/flake.nix#L48-L54).
You can then update the `.python-version` file with:

```bash
uv python pin
```

### Another Template: FHS-Compliant

**FHS** stands for Filesystem Hierarchy Standard. It is essentially a map that tells you where to find the tools you need, such as `/usr/bin/`. On NixOS, the `/usr/bin` folder doesn't exist and all tools are located in `/nix/store/`, as mentioned above.
This enables multiple versions of programs and ensures each program only sees what it needs.
However, some programs or languages (like `R`) expect an **FHS** system, i.e., a `/usr/bin` folder. In such cases, you need to add tools from `/nix/store/` into a project-specific `/usr/bin`. This is what `pkgs.BuildFHSEnv` is for.

You may want to read the [`NixOS Wiki`](https://nixos.wiki/wiki/Python#:~:text=Installing%20packages%20with,you%20could%20use%3A) on the subject.

You could therefore have a `flake.nix` like the one from [Ank's Neusis Setup](https://github.com/leoank/neusis/blob/main/templates/fhspythonml/flake.nix):

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

This is a slightly more complex environment than the one proposed in the previous template. It is not necessarily recommended, as it can be confusing. It is somewhat equivalent to overriding `LD_LIBRARY_PATH` for your project, but even stronger. You generally do not want to use this option, as it conflicts with the Nix philosophy of building isolated environments using `/nix/store/`. Instead, it symlinks packages from `/nix/store/` and adds them to `/usr/bin` (and possibly other directories). See the documentation for [`BuildFHSEnv`](https://ryantm.github.io/nixpkgs/builders/special/fhs-environments/).

## References

+ [`NixOS Wiki Python`](https://nixos.wiki/wiki/Python)
+ **Want to read more on `LD_LIBRARY_PATH`?** See this [LD_LIBRARY_PATH resource](https://www.hpc.dtu.dk/?page_id=1180) or this article on [`DYLD_LIBRARY_PATH`](https://medium.com/macos-is-not-linux-and-other-nix-reflections/d-o-y-ou-ld-library-path-you-6ab0a6135a33)