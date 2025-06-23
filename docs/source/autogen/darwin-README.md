<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->
<!-- markdownlint-disable MD041 MD047 MD059 -->

# Darwin Modules

This directory contains configuration modules specific to Darwin (macOS). It builds on top of the shared files, packages, and programs found in [`modules/shared/`](shared-README.md).

## Layout

```text
.
├── dock               # macOS Dock configuration
├── casks.nix          # List of Homebrew casks
├── files.nix          # Non-Nix, static configuration files (immutable by default, option for mutable)
├── home-manager.nix   # Defines user programs
└── packages.nix       # List of packages to install for macOS
```

## Details

The core of your Darwin configuration is defined here and managed by `home-manager`.

+ In [`casks.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/modules/darwin/casks.nix), you can define any GUI application you want to install using Homebrew casks. This is the recommended installation method for any macOS app. Applications will be automatically installed in the `/Applications/` folder. A list of available applications can be found on the [Homebrew formulae](https://formulae.brew.sh/cask/).
+ In [`files.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/modules/darwin/files.nix), you specify files that should be pre-created or symlinked. By default, files are immutable to guarantee reproducibility, but if you require some files to be mutable (such as VSCode keybindings), this is possible thanks to [`modules/shared/mutable.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/modules/shared/mutable.nix).
  + For example, VSCode keybindings and settings are pre-defined here and built from [`modules/shared/config/vscode/`](https://github.com/HugoHakem/nix-os.config/blob/main/modules/shared/config/vscode).
+ In [`packages.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/modules/darwin/packages.nix), you define any packages that are specific to macOS.
+ [`home-manager.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/modules/darwin/home-manager.nix) is where the main configuration is assembled. `casks.nix`, `packages.nix`, and `files.nix` are imported here.
  + **Notably:** This is also where the [Dock](https://github.com/HugoHakem/nix-os.config/blob/main/modules/darwin/home-manager.nix#L80) is defined. You may want to modify it by specifying the path of your desired app or file.
  + **Programs** are also defined here. If you have any Darwin-specific programs whose settings need to be configured, you should do so at this [line](https://github.com/HugoHakem/nix-os.config/blob/main/modules/darwin/home-manager.nix#L53). For example, you can add the *VSCode CLI* to the `$PATH`.
  + Any specific options for `home-manager` can be found on the [Home Manager Option Search](https://home-manager-options.extranix.com/).