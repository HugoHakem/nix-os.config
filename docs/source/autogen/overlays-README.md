<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->
<!-- markdownlint-disable MD041 MD047 MD059 -->

# Overlays

## Details

Files in this directory run automatically as part of each build. Overlays allow you to override the configuration of certain packages so that they behave in a specific way. Common use cases for overlays include:

* Applying patches
* Downloading different versions of files (locking to a version or trying a fork)
* Implementing temporary workarounds
* Renaming or defining new packages

Overlays are activated when defining your `pkgs` from `nixpkgs` in [`flake.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/flake.nix#L81-L121). This is the cleanest way to override anything, so if you need to do so, please add files to this folder.

For instance, you can override the version of a package (e.g., [`starship`](https://github.com/HugoHakem/nix-os.config/blob/main/overlays/master-pkgs.nix)) by using the `mpkgs` input, which follows the `nixpkgs` master branch. This is useful if you need the latest available package for some packages without having to update the entire `nixpkgs` channel, which could risk breaking your configuration.

The import logic is defined in [`overlays/default.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/overlays/overlays/default.nix).

* It enables passing arguments to overlays if required, such as [system or mpkgs](https://github.com/HugoHakem/nix-os.config/blob/main/flake.nix#L93). This can be extended by adding more inputs in the [`flake.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/flake.nix#L93), or by adding overlay-specific inputs in [`overlays/default.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/overlays/overlays/default.nix#L5).
* The default overlay logic should not be erased and generally does not need modification.

## Adding Custom Packages

If you need a package or tool (for example, from a GitHub repository) that cannot be found in the official Nixpkgs repository, or if you want to override the build process or patch a package in a way that is not possible through overlays or upstream Nixpkgs, you can define custom packages in this directory.

* Each `.nix` file (except `default.nix`) should define one or more packages as Nix attributes.
* The [`default.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/overlays/default.nix) file automatically imports all other `.nix` files in this directory and aggregates their outputs.
* The resulting set of packages is imported in the main [`flake.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/flake.nix) and can be added to your development shell or used elsewhere in your project.

### Example

To add a custom package, create a new file (e.g., `mytool.nix`) in this directory:

```nix

self: super:

{
  mytool = super.stdenv.mkDerivation {
    pname = "mytool";
    version = "1.0.0";
    src = super.fetchFromGitHub {
      owner = "username";
      repo = "mytool";
      rev = "commit-or-tag";
      sha256 = "sha256-...";
    };
    buildPhase = "true";
    installPhase = ''
      mkdir -p $out/bin
      cp $src/mytool $out/bin/
      chmod +x $out/bin/mytool
    '';
  };
}
```

This will make `mytool` available as a package `pkgs`. You must then register it under your packages wherever needed by calling `pkgs.mytool`.

See [`tmp.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/overlays/tmp.nix) for another commented template to help you get started.

---

**Tip:** Use this folder only for packages that cannot be obtained or easily overridden from upstream Nixpkgs.

## Resources

* [Nix Overlay Manual](https://nixos.wiki/wiki/Overlays)