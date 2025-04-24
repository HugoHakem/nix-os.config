# Installation Tutorial for Google Cloud Platform Virtual Machine

## Contextualization

### Introduction

When setting up a virtual machine building an adequate developer environment might be difficult or fail for obscure reasons. This repo make use of **Nix Package Manager** as a work around. Why this choice ? Because nix is fully:

+ **Reproducible**: works on any hardware.
+ **Declarative**: easy to share environments.
+ **Reliable**: an installation cannot break other packages and roll back to previous versions is possible.

This guide assumes the following [Pre-Requisites](#0-pre-requisite) which is simpply having a virtual machine running. This tutorial will take the example of the Google Cloud Virtual Machine, but it *supposedly* (please open an issue if you encounter any problems) works on any Linux machine.

Afterward, here is what you will do:

1. [Connect to the virtual machine.](#1-connect-to-the-virtual-machine)
2. [Install Nix Package Manager](#2-install-nix-package-manager)
3. [Pull the configuration file](#3-pull-the-configuration-file)
4. [Apply your credentials](#4-apply-your-credentials)
5. [Apply your environment](#5-apply-your-environment)

Once it is finished, you should have a working environment with any basic utilities you may need.

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

## Workflow when updating your `nixos-config/`

## For maintenance purposes

```bash
nix-collect-garbage -d
```
