<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->
<!-- markdownlint-disable MD041 MD047 MD059 -->

# Modules - Shared

Much of the code running on both MacOS or NixOS is found here.

## Layout

```text
.
├── config             # Config files not written in Nix
│   ├── emacs          # to update emacs config
│   ├── p10k.zsh       # to update zsh visual config
│   ├── vscode         # to update vscode config
│   └── wezterm.lua    # to update wezterm config
├── cachix             # Defines cachix, a global cache for builds
├── files.nix          # Non-Nix, static configuration files (immutable by default, option for mutable)
├── mutable.nix        # add options to home.file to make file mutable
├── packages.nix       # List of packages to share
├── programs.nix       # The goods; most all shared config lives here
└── README.md

```

## Details

### Some Utilities

+ [`cachix`](https://github.com/HugoHakem/nix-os.config/blob/main/modules/shared/cachix/default.nix) define substituter which are some additional store from which Nix will obtain some objects rather than building them from source. It enables faster build and you typically won't have to modify that file. For more documentation read through [Nix Reference Manual](https://nix.dev/manual/nix/2.17/command-ref/conf-file#conf-substituters).
+ `mutable.nix` is issued from [here](https://gist.github.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa). It adds two flags to `home.file = { }`:
  + `mutable = true;` whether the file created or symlinked can be modified.
  + `force = true;` which is required if `mutable = true;`.

    An example of its usage can be found in [`modules/darwin/files.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/modules/darwin/files.nix#L18-L28) to define **vscode keybindings and settings** which by essence must be mutable as vscode will override this when defining new keybindings. See [config/vscode](config-README.md) for more details.

### The Core of what you will modify

This is a very similar structure as the [`modules/darwin` config](darwin-README.md) and the [`modules/linux` config](linux-README.md). Here you will define any files, packages and programs settings that should be shared between your linux and darwin config. Actually this is most of your config that can be shared.

+ In `files.nix` you will specify files that should be pre-created or symlinked. By default the file is immutable to guarantee reproducibility but if you require some files to be mutable (such as vscode keybindings) it is possible thanks to `mutable.nix`.
+ In `packages.nix` you will define any packages you may need.
+ `programs.nix` you will define some settings specific to the programs you want to be using. You will find examples of  `git`, `zsh` or `vim`.
  + Any specific options for `programs` are handled through `home-manager`. As a result you can find any options you want to pre-define in the [Home Manager Option Search](https://home-manager-options.extranix.com/).