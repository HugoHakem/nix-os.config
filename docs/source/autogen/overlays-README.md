<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->
<!-- markdownlint-disable MD041 MD047 MD059 -->

# Overlays

## Details

Files in this directory run automatically as part of each build. Overlays allow you to override the configuration of certain packages so that they behave in a specific way. Common use cases for overlays include:

* Applying patches
* Downloading different versions of files (locking to a version or trying a fork)
* Implementing temporary workarounds
* Renaming or defining new packages

Overlays are activated when defining your `pkgs` from `nixpkgs` in [`flake.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/flake.nix#L70-L88). This is the cleanest way to override anything, so if you need to do so, please add files to this folder.

For example, I define [oh-my-bash](https://github.com/HugoHakem/nix-os.config/blob/main/overlays/oh-my-bash.nix) from the [ohmybash repository](https://github.com/ohmybash/oh-my-bash). Be aware that you may need to override its default usage or behavior. For instance, I had to add a patch to the default template in my [home-manager config](https://github.com/HugoHakem/nix-os.config/blob/main/modules/linux/home-manager.nix#L38-41).

## Ressources

* [Nix Overlay Manual](https://nixos.wiki/wiki/Overlays).