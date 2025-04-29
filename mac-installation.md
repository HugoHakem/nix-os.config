# Installation Tutorial for MacOS

To complete...
For now, use the [dustinlyons installation](https://github.com/dustinlyons/nixos-config)

## Contextualization

## Installation Guidelines

### Make App executable

To make the app from your system executable but disabling the app from the other system

```bash
ARCH=$(uname -m | sed 's/arm64/aarch64/'); [ "$ARCH" = "x86_64" ] && OTHER="aarch64" || OTHER="x86_64"; FILES="apply build build-switch create-keys copy-keys check-keys rollback"; NAMES=$(printf -- '-name %s -o ' $FILES | sed 's/ -o $//'); find apps/${ARCH}-darwin -type f \( $NAMES \) -exec chmod +x {} \; && find apps/${OTHER}-darwin -type f \( $NAMES \) -exec chmod -x {} \;
```

Make it a script ?

```bash
# Detect architecture
ARCH=$(uname -m | sed 's/arm64/aarch64/')
if [ "$ARCH" = "x86_64" ]; then
    OTHER="aarch64"
elif [ "$ARCH" = "aarch64" ]; then
    OTHER="x86_64"
else
    echo "Unsupported architecture: $(uname -m)"
    exit 1
fi

# List of executables
EXECUTABLES="apply build build-switch create-keys copy-keys check-keys rollback"

# Make executables for the current system
find apps/${ARCH}-darwin -type f \( $(printf -- '-name %s -o ' $EXECUTABLES | sed 's/ -o $//') \) -exec chmod +x {} \;

# Remove executables for the other system
find apps/${OTHER}-darwin -type f \( $(printf -- '-name %s -o ' $EXECUTABLES | sed 's/ -o $//') \) -exec chmod -x {} \;
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

There are some utilities to rollback to a previous version, please check the [`rollback`](apps/aarch64-darwin/rollback) implementation here that could be implemented run with:

```bash
nix run .#rollback
```

### For maintenance purposes

When doing multiple builds or heavily changing your configuration. It might happen that some packages are still present in your `/nix/store` or that previous version of your [`home-manager`](https://github.com/nix-community/home-manager) configuration are still saved in case you wanted to roll back to them. It is then wise, from time to time to trigger the following command.

```bash
nix-collect-garbage -d
```

Then in your `nixos-config/` folder you will run:

```bash
nix run .#build-switch
```

### Use template

The goal of setting up your environment is ultimately to do coding projects. In the [templates/](templates/README.md) folder, you will find a first template to play with for Machine Learning Project on Python.
