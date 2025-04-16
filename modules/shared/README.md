# Shared

Much of the code running on MacOS or NixOS is actually found here.

This configuration gets imported by both modules. Some configuration examples include `git`, `zsh`, `vim`, and `tmux`.

## Layout

```text
.
├── config             # Config files not written in Nix
│   ├── emacs          # to update emacs config
│   ├── p10k.zsh       # to update zsh visual config
│   └── vscode         # to update vscode config
├── cachix             # Defines cachix, a global cache for builds
├── default.nix        # Defines how we import overlays 
├── files.nix          # Non-Nix, static configuration files (now immutable!)
├── home-manager.nix   # The goods; most all shared config lives here
├── mutable.nix        # add options to home.file to make file mutable
├── packages.nix       # List of packages to share
└── README.md

```
