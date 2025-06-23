<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->
<!-- markdownlint-disable MD041 MD047 MD059 -->

# Modules - Shared

Much of the code running on both macOS and Linux (NixOS) is found here.

## Layout

```text
.
├── config             # Config files not written in Nix
│   ├── emacs          # Emacs configuration
│   ├── p10k.zsh       # Zsh visual configuration
│   ├── vscode         # VSCode configuration
│   └── wezterm.lua    # WezTerm configuration
├── cachix             # Defines Cachix, a global cache for builds
├── files.nix          # Non-Nix, static configuration files (immutable by default, option for mutable)
├── mutable.nix        # Adds options to home.file to make files mutable
├── packages.nix       # List of shared packages
└── programs.nix       # Main shared configuration for most programs
```

## Details

### Utilities

+ [`cachix`](https://github.com/HugoHakem/nix-os.config/blob/main/modules/shared/cachix/default.nix) defines substituters, which are additional stores from which Nix can obtain objects rather than building them from source. This enables faster builds, and you typically won't need to modify this file. For more documentation, refer to the [Nix Reference Manual](https://nix.dev/manual/nix/2.17/command-ref/conf-file#conf-substituters).
+ `mutable.nix` is adapted from [this gist](https://gist.github.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa). It adds two flags to `home.file = { }`:
  + `mutable = true;` — allows the created or symlinked file to be modified.
  + `force = true;` — required if `mutable = true;`.

    An example of its usage can be found in [`modules/darwin/files.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/modules/darwin/files.nix#L18-L28) to define **VSCode keybindings and settings**, which must be mutable since VSCode will override them when new keybindings are defined. See [config/vscode](config-README.md) for more details.

### Core Configuration

This structure is very similar to the [`modules/darwin` config](darwin-README.md) and the [`modules/linux` config](linux-README.md). Here, you define any files, packages, and program settings that should be shared between your Linux and Darwin configurations. In fact, most of your shared configuration will reside here.

+ In `files.nix`, specify files that should be pre-created or symlinked. By default, files are immutable to guarantee reproducibility, but if you require some files to be mutable (such as VSCode keybindings), this is possible thanks to `mutable.nix`.
+ In `packages.nix`, define any packages you may need across systems.
+ In `programs.nix`, define settings specific to the programs you use. Examples include configuration for `git`, `zsh`, or `vim`.
  + Any specific options for `programs` are handled through `home-manager`. You can find available options in the [Home Manager Option Search](https://home-manager-options.extranix.com/)