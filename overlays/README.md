# Overlays

## Details

Files in this directory run automatically as part of each build. Overlays allow you to override the configuration of certain packages so that they behave in a specific way. Common use cases for overlays include:

* Applying patches
* Downloading different versions of files (locking to a version or trying a fork)
* Implementing temporary workarounds
* Renaming or defining new packages

Overlays are activated when defining your `pkgs` from `nixpkgs` in [`flake.nix`](./../flake.nix#L81-L121). This is the cleanest way to override anything, so if you need to do so, please add files to this folder.

For instance I override the version of [`starship`](./master-pkgs.nix) by using the `mpkgs` which is the `nixpkgs` following the `master branch`. This is useful if you need the latest available package for some packages without having to update the `nixpkgs`channel risking to breaks the whole configuration.

## Ressources

* [Nix Overlay Manual](https://nixos.wiki/wiki/Overlays).
