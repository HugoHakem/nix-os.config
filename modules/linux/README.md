# Modules - Linux

This module is specific to Linux. It builds on top of the shared files, packages and programs that you can find in [`modules/shared/`](../shared/README.md).

## Layout

```text
.
├── files.nix          # Non-Nix, static configuration files (immutable by default, option for mutable)
├── home-manager.nix   # Defines user programs
├── packages.nix       # List of packages to install for MacOS
```

## Details

The core of your Linux config is actually defined here.

+ In `files.nix` you will specify files that should be pre-created or symlinked. By default the file is immutable to guarantee reproducibility but if you require some files to be mutable (such as vscode keybindings) it is possible thanks to [`modules/shared/mutable.nix`](../shared/mutable.nix).
+ In `packages.nix` you will define any packages that are specific to MacOS.
+ `home-manager.nix` is where the magic is happening. `files.nix`, `packages.nix` and `files.nix` get basically imported.
  + **Programs** get also defined. If you have any specific programs proper to Darwin whose settings need to be defined, you will do it [here](home-manager.nix#L34). An example is to enable `vscode`. We don't need to do so for Darwin because it is already readily available thanks to the `casks`, but we need to do so for Ubuntu.
  + Any specific options for `home-manager` can be found on the [Home Manager Option Search](https://home-manager-options.extranix.com/).
