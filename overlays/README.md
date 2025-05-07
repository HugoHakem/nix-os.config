# Overlays

## Details

Files in this directory run automatically as part of each build. It allows to override the configuration of certain packages so that they behave in a specific way. Some common ways overlays can be used:

* Applying patches
* Downloading different versions of files (locking to a version or trying a fork)
* Workarounds and stuff I need to run temporarily
* Renaming or defining new packages

Overlays get activated when defining your `pkgs` from `nixpkgs` in the [`flake.nix`](../flake.nix#L70-L88)
This is the cleanest way of of overriding anything so please, if you want to do so, add files in this folder.

## Ressources

* [Nix Overlay Manual](https://nixos.wiki/wiki/Overlays).
