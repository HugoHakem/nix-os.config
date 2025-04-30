# Installation Tutorial for MacOS

To complete...
For now, use the [dustinlyons installation](https://github.com/dustinlyons/nixos-config)

## Contextualization

## Installation Guidelines

### Make App executable

Maybe you won't be able to run the apps because they are not executable. To work around that:

```bash
find apps/$(uname -m | sed 's/arm64/aarch64/')-darwin -type f \( -name apply -o -name build -o -name build-switch -o -name create-keys -o -name copy-keys -o -name check-keys -o -name rollback \) -exec chmod +x {} \;
```

## Workflow

### Add new system packages

+ The standard way to add new packages will be by updating the `modules/shared/packages.nix`(modules/shared/packages.nix). Please visit [modules/shared/README.md](modules/shared/README.md) for more details. You will find explanations and example on how to add new **packages**, how to create **files** directly (case that won't happen so often), or how to configure **programs**.

+ Additonally you may think the package you want to install is linux specific. This config is indeed intended to be both MacOS and Linux compatible. In that case, you will rather modify the [modules/darwin/](nixos-config/modules/darwin/README.md) config

+ If a nix packages, for some reason doesn't work. Patches will be applied in the [overlay directory](nixos-config/overlays/README.md). Other use case for `overlays` could be to override certain attributes of packages. An example of such needs can be when on MacOS, you update your MacOS version. Packages might break as of the update and require patches.

Additionnally, know that this the [hosts/darwin.nix](hosts/README.md) exists but on a day to day basis, you won't modify this file.

Finally every time you have done changes to your config, run the following command to actually apply those changes to your system:

To safely build your configuration and checkinf there are no errors.

```bash
nix run .#build
```

To actually apply your config:

```bash
nix run .#build-switch
```

There are some utilities to rollback to a previous version, that can be runed with:

```bash
nix run .#rollback
```

You will be prompt which generation to rollback to. It might be useful to retrieve a working system. But it wont give you back your `nixos-config` files. This is why it is advice to init a github repository with your `nixos-config/` folder.

### For maintenance purposes

When doing multiple builds or heavily changing your configuration. It might happen that some packages are still present in your `/nix/store` or that previous version of your [`home-manager`](https://github.com/nix-community/home-manager) configuration are still saved in case you wanted to roll back to them. It is then wise, from time to time to trigger the following command.

```bash
nix-collect-garbage -d
```

Then in your `nixos-config/` folder you will run:

```bash
nix run .#build-switch
```

Sometimes, whenever you want to install a package with a certain version, you may want to try it first this way:

```bash
nix shell nixpkgs#[name-of-the-package]
```

If you want a certain version of that package and you can make it happen through the `nix shell` command but not by using this config, it might be because the `flake.lock` refer to previous versions of your `flake.nix` `inputs`. In that case you may want to try:

```bash
nix flake update 
# optionally you can specify the input you want to update
```

Please refer to the documentation on [`nix flake update`](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-update). Be aware that by updating your input, things might break because options are no longer supported, or syntax has changed etc. Do not use if you don't need it. I advice you init a git repo of your `nixos-config/` so you can revert the lock changes anytime.

### Use template

The goal of setting up your environment is ultimately to do coding projects. In the [templates/](templates/README.md) folder, you will find a first template to play with for Machine Learning Project on Python.
