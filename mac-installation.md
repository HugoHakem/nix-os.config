# Installation Tutorial for macOS

To be completed...
For now, please refer to the [dustinlyons installation guide](https://github.com/dustinlyons/nixos-config).

## Context

## Installation Guidelines

### Make App Executable

You may encounter issues running the apps because they are not executable by default. To resolve this, run:

```bash
find apps/$(uname -m | sed 's/arm64/aarch64/')-darwin -type f \( -name apply -o -name build -o -name build-switch -o -name create-keys -o -name copy-keys -o -name check-keys -o -name rollback \) -exec chmod +x {} \;
```

## Workflow

### Adding New System Packages

+ The standard way to add new packages is by updating [`modules/shared/packages.nix`](./modules/shared/packages.nix). Please visit [modules/shared/README.md](./modules/shared/README.md) for more details. You will find explanations and examples on how to add new **packages**, create **files** directly (which is less common), or configure **programs**.

+ If you believe the package you want to install is Linux-specific, note that this configuration is intended to be compatible with both macOS and Linux. In such cases, you should modify the [modules/darwin/](./modules/darwin/README.md) configuration.

+ If a Nix package does not work for some reason, patches should be applied in the [overlays directory](./overlays/README.md). Another use case for `overlays` is to override certain package attributes. For example, after updating your macOS version, some packages might break and require patches.

Additionally, note that [hosts/darwin.nix](./hosts/README.md) exists, but you typically won't need to modify this file on a day-to-day basis.

After making changes to your configuration, run the following commands to apply those changes to your system:

To safely build your configuration and check for errors:

```bash
nix run .#build
```

To actually apply your configuration:

```bash
nix run .#build-switch
```

To roll back to a previous version, use:

```bash
nix run .#rollback
```

You will be prompted to select which generation to roll back to. This can be useful for restoring a working system, but it will not restore your `nixos-config` files. Therefore, it is recommended to initialize a GitHub repository with your `nixos-config/` folder.

### Maintenance

When performing multiple builds or making significant changes to your configuration, some packages may remain in your `/nix/store`, or previous versions of your [`home-manager`](https://github.com/nix-community/home-manager) configuration may still be saved for rollback purposes. It is advisable to periodically run:

```bash
nix-collect-garbage -d
```

Then, in your `nixos-config/` folder, run:

```bash
nix run .#build-switch
```

If you want to try installing a package with a specific version, you can test it first with:

```bash
nix shell nixpkgs#[name-of-the-package]
```

If you are able to get a certain version of a package using `nix shell` but not through this configuration, it may be because your `flake.lock` refers to previous versions of your `flake.nix` inputs. In that case, try:

```bash
nix flake update 
# Optionally, specify the input you want to update
```

Please refer to the documentation on [`nix flake update`](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-update). Be aware that updating your inputs may cause breaking changes due to unsupported options or syntax changes. Only update if necessary. It is recommended to initialize a Git repository for your `nixos-config/` so you can revert lock changes if needed.

### Using Templates

The goal of setting up your environment is ultimately to work on coding projects. In the [templates](./templates/README.md) folder, you will find a template for a Python Machine Learning project to get started.
