# Linux Modules

This directory contains configuration modules specific to Linux. It builds on top of the shared files, packages, and programs found in [`modules/shared/`](./../shared/README.md).

## Layout

```text
.
├── files.nix          # Non-Nix, static configuration files (immutable by default, option for mutable)
├── home-manager.nix   # Defines user programs
└── packages.nix       # List of packages to install for Linux
```

## Details

The core of your Linux configuration is defined here.

+ In [`files.nix`](./files.nix), you specify files that should be pre-created or symlinked. By default, files are immutable to guarantee reproducibility, but if you require some files to be mutable (such as VSCode keybindings), this is possible thanks to [`modules/shared/mutable.nix`](./../shared/mutable.nix).
+ In [`packages.nix`](./packages.nix), you define any packages that are specific to Linux.
+ [`home-manager.nix`](./home-manager.nix) is where the main configuration is assembled. `files.nix` and `packages.nix` are imported here.
  + **Programs** are also defined here. If you have any Linux-specific programs whose settings need to be configured, you should do so at this [line](./home-manager.nix#L34). For example, you may want to enable `vscode`. This is not necessary for Darwin, as it is already available via `casks`, but it is required for Ubuntu.
  + Any specific options for `home-manager` can be found on the [Home Manager Option Search](https://home-manager-options.extranix.com/).
