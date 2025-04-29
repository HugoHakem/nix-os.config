# Installation Tutorial for Google Cloud Platform Virtual Machine

## Contextualization

When setting up a virtual machine building an adequate developer environment might be difficult or fail for obscure reasons. This repo make use of **Nix Package Manager** as a work around.

This guide assumes the following [Pre-Requisites](#0-pre-requisite) which is simpply having a virtual machine running. This tutorial will take the example of the Google Cloud Virtual Machine, but it *supposedly* (please open an issue if you encounter any problems) works on any Linux machine.

Afterward, here is what you will do:

1. [Connect to the virtual machine.](#1-connect-to-the-virtual-machine)
2. [Install Nix Package Manager](#2-install-nix-package-manager)
3. [Pull the configuration file](#3-pull-the-configuration-file)
4. [Apply your credentials](#4-apply-your-credentials)
5. [Apply your environment](#5-apply-your-environment)

Once it is finished, you should have a working environment with any basic utilities you may need.

To jump to how to use this config and add project templates, go to [workflow](#workflow).

## Installation Guidelines

### 0 Pre-Requisite

This tutorial assume:

+ A gcp virtual machine has already been set up.
+ A GPU is available, but the drivers are not necessarily pre-installed from GCP.
+ The disk is already configured.
+ The server is running on Ubuntu 22.04 with architecture x86/64.

### 1 Connect to the virtual machine

```bash
gcloud compute ssh ["name of the machine"] --zone ["name of the Zone"] 
```

### 2 Install Nix Package Manager

Here we do not seek to switch completely from Linux to NixOS. So we solely install Nix as a package manager, particularly to specify our user configuration with home-manager. A good tutorial about home-manager and the installation step can be found [here](https://github.com/Evertras/simple-homemanager/blob/main/01-install.md). But if are interesting in just making your server running, please keep going.

Run this following command to install nix as a package manager in a multi-user settings (ref to [NixOS documentation](https://nixos.org/download/#nix-install-linux)):

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Then you must add some extra functionality manually in you nix config at `/etc/nix/nix.conf`. In particular, you should:

+ enable the **experimental-features** `nix-command` and `flakes`:
  + `nix-command` provides some convenient CLI for nix.
  + `flakes` specify that we can work with `flake.nix` file where the core of your environment is specified.

+ provide `root` and your username (that is the result of the `whoami` bash command) as **trusted users**.
  + This allow the user to have their own `~/.config/nix/nix.conf`. Hence this nix configuration will prevail and you won't have to manually modify nix config anymore as long as it is declared in your `flake.nix`.

To do so, please do:

```bash
sudo nano /etc/nix/nix.conf
```

And add:

```bash
experimental-features = nix-command flakes
trusted-users = root hhakem
```

Save your modification and close the file. Note that `sudo` was required because by default, on your GCP machine you can only install things at the user level, hence not as root. You then need super user access to modify things at the root level.

### 3 Pull the configuration file

Now that nix package manager is available, you will pull the configuration file from this repo. Nix is also convenient for that and allows to run flake that are hosted on git repos. Here you will run the `#installation` command that I have specified in [`apps/x86_64-linux/install`](apps/x86_64-linux/install) as a shell script. It is made available as a nix app with the `mkApp` function in the [`flake.nix`](flake.nix).

Run the following:

```bash
nix --extra-experimental-features 'nix-command flakes' run github:HugoHakem/nix-os.config?ref=hh-virtual-machine#install
```

Few things will occur here:

```sh
cleanup             # remove any folder named: "nix-os.config-main.zip" or "nix-os.config-main"
check_installer     # verify `nix` is available
download_config     # download the repo as a zip file and unzip it using both `curl` and `unzip`. 
                    # no need to install it before hand! If you don't have it, I did it for you with `nix shell`
                
cleanup             # again remove the installation folder that we don't need anymore.
                    # the main config has been renamed under `nixos-config/`
check_nvidia        # check if NVIDIA drivers are installed
prompt_reboot       # ask you whether you want to reboot your machine (recommended if NVIDIA drivers are installed)
```

When checking for the NVIDIA drivers, the installer will check if `nvidia-smi` is running as it should. If it doesn't you will be prompt whether you want to install them through the installater. Please see this note on [nvidia drivers installation](apps/x86_64-linux/nvidia-drivers-installation.md) to have a detailed explanation of what is happening here. If you rather prefer not doing it, because your machine just doesn't have any GPU, or because you rather prefer ddoing it yourself just answer `no`.

### 4 Apply your credentials

Then **before actually applying your environment configuration**, you need to define your credentials. In particular, you will be defining:

+ `GIT_NAME`
  + This doesn't have to be the same as your github repo. It will be the name used to sign your commits.
+ `GIT_EMAIL`
  + This is the one associated to your github account.

Also, `user` will be pulled from `whoami`.

Run the following command:

1. Go into the nixos-config directory:

    ```bash
    cd nixos-config/
    ```

2. Run the apply function (which, if you are curious is a bash script detailed [`apps/x86_64-linux/apply`](apps/x86_64-linux/apply)):

    ```bash
    nix run .#apply
    ```

This will override the following lines in the [flake.nix](flake.nix):

```nix
user = "hhakem";
git_name = "Hugo";
git_email = "hhakem@broadinstitute.org";
```

If your `git` is already configured, it will pull those informations. If your not satisfied with this behavior, then you must changes those lines manually. You won't be able to change it from git CLI (because this is how nix is, immutable (*except when you specify not to*) for perfect reproducibility).

### 5 Apply your environment

You are now readdy to apply your environment configuration. Run this command (while still being in the `nixos-config/` folder):

```bash
nix run .#build-switch
```

Again if you are curious, the `build-switch` app is defined [apps/x86_64-linux/build-switch](apps/x86_64-linux/build-switch).

## Workflow

### Add new system packages

+ The standard way to add new packages will be by updating the `modules/shared/packages.nix`(modules/shared/packages.nix). Please visit [modules/shared/README.md](modules/shared/README.md) for more details. You will find explanations and example on how to add new **packages**, how to create **files** directly (case that won't happen so often), or how to configure **programs**.

+ Additonally you may think the package you want to install is linux specific. This config is indeed intended to be both MacOS and Linux compatible. In that case, you will rather modify the [modules/linux/](nixos-config/modules/linux/README.md) config

+ If a nix packages, for some reason doesn't work. Patches will be applied in the [overlay directory](nixos-config/overlays/README.md). Other use case for `overlays` could be to override certain attributes of packages. An example of such needs can be when on MacOS, you update your MacOS version. Packages might break as of the update and require patches.

Additionnally, know that this the [hosts/linux.nix](hosts/README.md) exists but on a day to day basis, you won't modify this file.

Finally every time you have done changes to your config, run the following command to actually apply those changes to your system:

```bash
nix run .#build-switch
```

Additionally there are some utilities to rollback to a previous version, please check the [manual](https://nix-community.github.io/home-manager/index.xhtml#sec-usage-rollbacks)

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

The goal of setting up your environment is ultimately to do coding projects. In the [templates/](templates/README.md) folder, you will find a first template for Machine Learning Project on Python.
