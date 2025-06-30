# Custom Packages Directory

This folder is intended for defining custom Nix packages that are not available in the [Nix Packages collection](https://search.nixos.org/packages).

## When to Use

- **Unavailable Packages:** If you need a package or tool (for example, from a GitHub repository) that cannot be found in the official Nixpkgs repository, you can add it here.
- **Custom Builds:** If you want to override the build process or patch a package in a way that is not possible through overlays or upstream Nixpkgs.

## How It Works

- Each `.nix` file in this directory (except `default.nix`) should define one or more packages as Nix attributes.
- The [`default.nix`](default.nix) file automatically imports all other `.nix` files in this directory and aggregates their outputs.
- The resulting set of packages is imported in the main [`flake.nix`](./../flake.nix) and can be added to your development shell or used elsewhere in your project.

## Example

To add a custom package, create a new file (e.g., `mytool.nix`) in this directory:

```nix
{ pkgs }:

{
  mytool = pkgs.stdenv.mkDerivation {
    pname = "mytool";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
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

## Template

See [`tmp.nix`](tmp.nix) for another commented template to help you get started.

---

**Tip:** Use this folder only for packages that cannot be obtained or easily overridden from upstream Nixpkgs.
