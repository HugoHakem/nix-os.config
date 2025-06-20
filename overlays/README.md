# Overlays

## Details

Files in this directory run automatically as part of each build. It allows to override the configuration of certain packages so that they behave in a specific way. Some common ways overlays can be used:

* Applying patches
* Downloading different versions of files (locking to a version or trying a fork)
* Workarounds and stuff I need to run temporarily
* Renaming or defining new packages

Overlays get activated when defining your `pkgs` from `nixpkgs` in the [`flake.nix`](./../flake.nix#L70-L88)
This is the cleanest way of of overriding anything so please, if you want to do so, add files in this folder.

For instance, I am defining [oh-my-bash](./oh-my-bash.nix) from the [ohmybash repo](https://github.com/ohmybash/oh-my-bash). Be careful however, you need to override its default usage etc... For instance I had to add the following patch to the default template in my [home-manager config](./../modules/linux/home-manager.nix#L38-41)

## Ressources

* [Nix Overlay Manual](https://nixos.wiki/wiki/Overlays).
