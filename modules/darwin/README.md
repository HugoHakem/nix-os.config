# Modules - Darwin

This module is specific to Darwin. It builds on top of the shared files, packages and programs that you can find in [`modules/shared/`](../shared/README.md).

## Layout

```text
.
├── dock               # MacOS dock configuration
├── casks.nix          # List of homebrew casks
├── files.nix          # Non-Nix, static configuration files (immutable by default, option for mutable)
├── home-manager.nix   # Defines user programs
├── packages.nix       # List of packages to install for MacOS
```

## Details

The core of your Darwin config is actually defined here. It is handled by `home-manager`.

+ In `casks.nix`(casks.nix) you can define any application with a GUI that you want to download from source using homebrew casks. This is the recommended installation mode for any MacOS app. The application will be automatically installe in the `/Application/` folder. A list of the available applications can be found on the [Homebrew formulae](https://formulae.brew.sh/cask/).
+ In `files.nix` you will specify files that should be pre-created or symlinked. By default the file is immutable to guarantee reproducibility but if you require some files to be mutable (such as vscode keybindings) it is possible thanks to [`modules/shared/mutable.nix`](../shared/mutable.nix).
  + For instance, vscode keybindings and settings are pre-defined here and built from [`modules/shared/config/vscode/`](../shared/config/vscode/README.md).
+ In `packages.nix` you will define any packages that are specific to MacOS.
+ `home-manager.nix` is where the magic is happening. `casks.nix`, `packages.nix` and `files.nix` get basically imported.
  + **Notably**: This is also where the [`Dock`](nixos-config/modules/darwin/home-manager.nix#L73) gets defined. You may want to modify it by specifying the path of your desired app or file.
  + **Programs** get also defined. If you have any specific programs proper to Darwin whose settings need to be defined, you will do it [here](home-manager.nix#L53). An example is to add *Vscode CLI* to the `$PATH`.
  + Any specific options for `home-manager` can be found on the [Home Manager Option Search](https://home-manager-options.extranix.com/).
