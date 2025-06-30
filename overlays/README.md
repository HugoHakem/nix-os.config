# Overlays

## Details

Files in this directory run automatically as part of each build. Overlays allow you to override the configuration of certain packages so that they behave in a specific way. Common use cases for overlays include:

* Applying patches
* Downloading different versions of files (locking to a version or trying a fork)
* Implementing temporary workarounds
* Renaming or defining new packages

Overlays are activated when defining your `pkgs` from `nixpkgs` in [`flake.nix`](./../flake.nix#L81-L121). This is the cleanest way to override anything, so if you need to do so, please add files to this folder.

For instance I override the version of [`starship`](./master-pkgs.nix) by using the `mpkgs` which is the `nixpkgs` following the `master branch`. This is useful if you need the latest available package for some packages without having to update the `nixpkgs`channel risking to breaks the whole configuration.

The import logic is defined in [`overlays/default.nix`](./overlays/default.nix).

* It enable to pass on arguments to overlays if required required by the overlay provide as of now any of [system or mpkgs](./../flake.nix#L93). This can be extended by adding more inputs in the [`flake.nix`](./../flake.nix#L93), or by adding `overlays` specific inputs in [`overlays/default.nix`](./overlays/default.nix#L5).
* It should not be erased and you won't generally have to modify it.

## Ressources

* [Nix Overlay Manual](https://nixos.wiki/wiki/Overlays).
