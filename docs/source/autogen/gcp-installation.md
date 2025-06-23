<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->
<!-- markdownlint-disable MD041 MD047 MD059 -->

# Installation Tutorial for Google Cloud Platform Virtual Machine

## Table of Contents

- [Installation Tutorial for Google Cloud Platform Virtual Machine](#installation-tutorial-for-google-cloud-platform-virtual-machine)
  - [Table of Contents](#table-of-contents)
  - [Context](#context)
  - [Installation Guidelines](#installation-guidelines)
    - [0. Prerequisites](#0-prerequisites)
    - [1. Connect to the Virtual Machine](#1-connect-to-the-virtual-machine)
    - [2. Install Nix Package Manager](#2-install-nix-package-manager)
    - [3. Pull the Configuration File](#3-pull-the-configuration-file)
    - [4. Apply Your Credentials](#4-apply-your-credentials)
    - [5. Apply Your Environment](#5-apply-your-environment)
  - [Workflow](#workflow)
    - [Adding New System Packages](#adding-new-system-packages)
    - [Maintenance](#maintenance)
    - [Using Templates](#using-templates)
    - [Connecting to the VM with VSCode](#connecting-to-the-vm-with-vscode)
      - [Code Tunnel](#code-tunnel)
      - [Remote SSH](#remote-ssh)
        - [**SSH Connect**](#ssh-connect)
        - [**My Preferred Way**](#my-preferred-way)

## Context

When setting up a virtual machine, building an adequate developer environment can be challenging or fail for obscure reasons. This repository uses the **Nix Package Manager** as a solution.

This guide assumes the following [Prerequisites](#0-prerequisites): simply having a virtual machine running. While this tutorial uses a Google Cloud Virtual Machine as an example, it should (please open an issue if you encounter any problems) work on any Linux machine.

The steps are as follows:

1. [Connect to the virtual machine.](#1-connect-to-the-virtual-machine)
2. [Install Nix Package Manager.](#2-install-nix-package-manager)
3. [Pull the configuration file.](#3-pull-the-configuration-file)
4. [Apply your credentials.](#4-apply-your-credentials)
5. [Apply your environment.](#5-apply-your-environment)

Once finished, you should have a working environment with all the basic utilities you need.

To learn how to use this configuration and add project templates, see the [Workflow](#workflow) section.

## Installation Guidelines

### 0. Prerequisites

This tutorial assumes:

- A GCP virtual machine has already been set up.
- A GPU is available, but the drivers may not be pre-installed from GCP.
- The disk is already configured.
- The server is running Ubuntu 22.04 with x86_64 architecture.

### 1. Connect to the Virtual Machine

```bash
gcloud compute ssh ["name of the machine"] --zone ["name of the Zone"] --project ["name of the project"] --tunnel-through-iap
```

You can configure your `gcloud` settings so you don't have to enter the `project` and `zone` every time. See the [`gcloud config set` documentation](https://cloud.google.com/sdk/gcloud/reference/config/set).

### 2. Install Nix Package Manager

Here, we do not seek to switch completely from Linux to NixOS. We simply install Nix as a package manager, particularly to specify our user configuration with home-manager. A good tutorial about home-manager and the installation steps can be found [evertras/simple-homemanager](https://github.com/Evertras/simple-homemanager/blob/main/01-install.md). If you are only interested in getting your server running, continue with this guide.

Run the following command to install Nix as a package manager in multi-user mode (see [NixOS documentation](https://nixos.org/download/#nix-install-linux)):

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Next, you must manually add some extra functionality to your Nix config at `/etc/nix/nix.conf`. In particular, you should:

- Enable the **experimental-features** `nix-command` and `flakes`:
  - `nix-command` provides a more convenient CLI for Nix.
  - `flakes` allows you to work with a `flake.nix` file, where the core of your environment is specified.

- Add `root` and your username (the result of the `whoami` command) as **trusted users**.
  - This allows the user to have their own `~/.config/nix/nix.conf`. Hence, this Nix configuration will prevail, and you won't have to manually modify the Nix config anymore as long as it is declared in your `flake.nix`.

To do so, run:

```bash
sudo nano /etc/nix/nix.conf
```

And add:

```bash
experimental-features = nix-command flakes
trusted-users = root hhakem
```

Save your changes and close the file. Note that `sudo` is required because, by default, on your GCP machine you can only install things at the user level, not as root. You need superuser access to modify things at the root level.

### 3. Pull the Configuration File

Now that the Nix package manager is available, pull the configuration file from this repo. Nix makes this convenient and allows you to run flakes hosted on git repositories. Here, you will run the `#install` command specified in [`apps/x86_64-linux/install`](https://github.com/HugoHakem/nix-os.config/blob/main/apps/x86_64-linux/install) as a shell script. It is made available as a Nix app with the `mkApp` function in [`flake.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/flake.nix).

Run the following:

```bash
nix --extra-experimental-features 'nix-command flakes' run github:HugoHakem/nix-os.config?ref=main#install
```

A few things will happen here:

```sh
cleanup             # Remove any folder named: "nix-os.config-main.zip" or "nix-os.config-main"
check_installer     # Verify `nix` is available
download_config     # Download the repo as a zip file and unzip it using both `curl` and `unzip`. 
                    # No need to install beforehand! If you don't have it, I did it for you with `nix shell`
                
cleanup             # Again remove the installation folder that we don't need anymore.
                    # The main config has been renamed under `nixos-config/`
check_nvidia        # Check if NVIDIA drivers are installed
prompt_reboot       # Ask whether you want to reboot your machine (recommended if NVIDIA drivers are installed)
```

When checking for NVIDIA drivers, the installer will check if `nvidia-smi` is running as it should. If not, you will be prompted to install them through the installer. Please see the note on [NVIDIA drivers installation](nvidia-drivers-installation.md) for a detailed explanation. If your machine does not have a GPU, or you prefer to handle this yourself, simply answer `no`.

### 4. Apply Your Credentials

**Before actually applying your environment configuration**, you need to define your credentials. In particular, you will define:

- `GIT_NAME`
  - This does not have to be the same as your GitHub username. It will be the name used to sign your commits.
- `GIT_EMAIL`
  - This should be the email associated with your GitHub account.

Also, `user` will be pulled from `whoami`.

Run the following commands:

1. Go into the nixos-config directory:

    ```bash
    cd nixos-config/
    ```

2. Run the apply function (which, if you are curious, is a bash script detailed in [`apps/x86_64-linux/apply`](https://github.com/HugoHakem/nix-os.config/blob/main/apps/x86_64-linux/apply)):

    ```bash
    nix run .#apply
    ```

This will override the following lines in [flake.nix](https://github.com/HugoHakem/nix-os.config/blob/main/flake.nix):

```nix
user = "hhakem";
git_name = "Hugo";
git_email = "hhakem@broadinstitute.org";
```

If your `git` is already configured, it will pull that information. If you are not satisfied with this behavior, you must change those lines manually. You will not be able to change it from the git CLI (because this is how Nix works: immutable, except when you specify otherwise, for perfect reproducibility).

### 5. Apply Your Environment

You are now ready to apply your environment configuration. Run this command (while still in the `nixos-config/` folder):

```bash
nix run .#build-switch
```

Again, if you are curious, the `build-switch` app is defined in [apps/x86_64-linux/build-switch](https://github.com/HugoHakem/nix-os.config/blob/main/apps/x86_64-linux/build-switch).

## Workflow

### Adding New System Packages

- The standard way to add new packages is by updating [`modules/shared/packages.nix`](https://github.com/HugoHakem/nix-os.config/blob/main/modules/shared/packages.nix). Please visit [modules/shared/README.md](shared-README.md) for more details. You will find explanations and examples on how to add new **packages**, create **files** directly (which is less common), or configure **programs**.

- If you believe the package you want to install is Linux-specific, note that this configuration is intended to be compatible with both macOS and Linux. In such cases, you should modify the [modules/linux/](linux-README.md) configuration.

- If a Nix package does not work for some reason, patches should be applied in the [overlays directory](overlays-README.md). Another use case for `overlays` is to override certain package attributes. For example, after updating your macOS version, some packages might break and require patches.

Additionally, note that [hosts/linux.nix](hosts-README.md) exists, but you typically won't need to modify this file on a day-to-day basis.

After making changes to your configuration, run the following command to apply those changes to your system:

```bash
nix run .#build-switch
```

There are utilities to roll back to a previous version, which can be run with:

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

The goal of setting up your environment is ultimately to work on coding projects. In the [templates/](templates-README.md) folder, you will find a template for a Python Machine Learning project to get started.

### Connecting to the VM with VSCode

Connecting to the Virtual Machine through VSCode can be done in two ways:

- **Code Tunnel** is great and requires minimal setup, but every time you turn off the VM, you'll have to repeat the connection steps.
- **Remote SSH** is best if you want a one-time setup and is actually not difficult to put in place.

#### Code Tunnel

This requires a GitHub or Microsoft account.

- Connect to the Virtual Machine:
  
  ```bash
  gcloud compute ssh ["name of the machine"] --zone ["name of the Zone"] --project ["name of the project"] --tunnel-through-iap
  ```

- Create a background process with your preferred method (`tmux` or `screen`). For example, with tmux:
  - See [tmux cheat sheet](https://tmuxcheatsheet.com/)

    ```bash
    tmux new -s vscode
    ```

  - Or with screen (see [screen cheat sheet](https://gist.github.com/jctosta/af918e1618682638aa82)):

    ```bash
    screen -S vscode
    ```

- Launch the code tunnel:

  ```bash
  code tunnel
  ```

  Follow the instructions from there; you may have to visit a web link, connect to your GitHub or Microsoft account, and enter an authentication code.

- Exit the process (*without killing it*):
  - tmux: `<Ctrl + b>` `d`
  - screen: `<Ctrl + a>` `d`

- You are now ready to connect with VSCode:
  - Open the command panel with `<Cmd + Shift + P>`
  - Enter: `Remote-Tunnels: Connect to Tunnel...`
  - You can now use your GitHub or Microsoft account to connect.

#### Remote SSH

This tutorial is inspired by this [blog post](https://medium.com/@albert.brand/remote-to-a-vm-over-an-iap-tunnel-with-vscode-f9fb54676153).

I will present both the *standard way* to add a new Host in your SSH config and *my preferred way*. I recommend following the *standard way* first, and *my preferred way* if you are doing this for the first time. Otherwise, jump to [My Preferred Way](#my-preferred-way).

**Standard way**:

When connecting to the VM, you usually run:

```bash
gcloud compute ssh ["name of the machine"] --zone ["name of the Zone"] --project ["name of the project"] --tunnel-through-iap
```

If you add the `--dry-run` flag, this will return the actual `ssh` command, which will look like this (simplified with variables in angle brackets `<...>`):

```bash
/usr/bin/ssh -t -i ~/.ssh/google_compute_engine -o CheckHostIP=no -o HashKnownHosts=no -o HostKeyAlias=compute.<VM_ID> -o IdentitiesOnly=yes -o StrictHostKeyChecking=yes -o UserKnownHostsFile=~/.ssh/google_compute_known_hosts -o "ProxyCommand <PYTHON-BIN> -S -W ignore <GCLOUD.py> compute start-iap-tunnel '<VM_NAME>' '%p' --listen-on-stdin --project=<PROJECT_NAME> --zone=<ZONE> --verbosity=warning" -o ProxyUseFdpass=no <USER>@compute.<VM_ID>
```

This SSH command can be added in VSCode so that it recognizes your machine via SSH. However, the command is not formatted properly for VSCode:

- `/usr/bin/ssh` should be `ssh`
- `"ProxyCommand ..."` should be `ProxyCommand="..."`

This command does the following:

```bash
gcloud compute ssh ["name of the machine"] --zone ["name of the Zone"] --project ["name of the project"] --tunnel-through-iap --dry-run | \
sed 's/-o "ProxyCommand \([^"]*\)"/-o ProxyCommand="\1"/' | \
sed 's/\/usr\/bin\/ssh/ssh/'
```

You can now copy the output and do the following in VSCode:

- Open the command panel with `<Cmd + Shift + P>`
- Enter: `Remote-SSH: Add New SSH Host...`
- Paste the output you copied.

This will generate an entry in your `~/.ssh/config` file like:

```text
Host compute.<VM_ID>
  HostName compute.<VM_ID>
  IdentityFile ~/.ssh/google_compute_engine
  CheckHostIP no
  HashKnownHosts no
  HostKeyAlias compute.<VM_ID>
  IdentitiesOnly yes
  StrictHostKeyChecking yes
  UserKnownHostsFile ~/.ssh/google_compute_known_hosts
  ProxyCommand <PYTHON-BIN> -S -W ignore <GCLOUD.py> compute start-iap-tunnel '<VM_NAME>' '%p' --listen-on-stdin --project=<PROJECT_NAME> --zone=<ZONE> --verbosity=warning
  ProxyUseFdpass no
  User <USER>
```

You are now ready to connect to your machine with SSH in VSCode:

##### **SSH Connect**

- Open the command panel with `<Cmd + Shift + P>`
- Enter: `Remote-SSH: Connect to Host...`
- Select the Host variable of your VM, e.g., `compute.<VM_ID>`

Additionally, you no longer have to run the traditional `gcloud compute ssh ...` command. You can simply do:

```bash
ssh <USER>@compute.<VM_ID>
```

##### **My Preferred Way**

The previous method works, but there is one underlying problem when using the `google-cloud-sdk` provided by Nix: the `<PYTHON-BIN>` and `<GCLOUD.py>` paths will look like this:

```text
<PYTHON-BIN> : /nix/store/90myxg4ckim260mw8mv741b4knykzx50-python3-3.12.9-env/bin/python
<GCLOUD.py> : /nix/store/h618r2jp07djzgsh7ymbpgy6vy1yvwcl-google-cloud-sdk-515.0.0/google-cloud-sdk/lib/gcloud.py
```

If you hardcode these paths in your SSH config, there is a high chance that, if you update your `nixos-config`, those paths will change (due to hash or version changes). You don't want to always update your `~/.ssh/config` whenever you update your `nixos-config`. Ideally, based on the `gcloud` you have, you should be able to retrieve where the `<PYTHON-BIN>` and `<GCLOUD.py>` are located.

Fortunately, this is specified under:

```bash
gcloud info
```

This displays a long config for gcloud, and in particular, you can read:

```text
Python Location: [<PYTHON-BIN>]
...
Installation Root: [<GCLOUD_PATH>] # Note: <GCLOUD.py> = <GCLOUD_PATH>/lib/gcloud.py
```

Hence, the idea of creating a custom **SSH Host config**, where the `ProxyCommand` points to a script that fetches `<PYTHON-BIN>` and `<GCLOUD_PATH>` from `gcloud info` and then composes the actual `ProxyCommand`.

This is what [modules/shared/config/gcp-ssh-script.sh](https://github.com/HugoHakem/nix-os.config/blob/main/modules/shared/config/gcp-ssh-script.sh) does. It is supposedly the default, but you may have to make it executable. Run in your home directory:

```bash
chmod +x nixos-config/modules/shared/config/gcp-ssh-script.sh
```

Here is the suggested **SSH Host config**:

```text
Host <HOST_NAME> 
  HostName compute.<VM_ID>
  IdentityFile ~/.ssh/google_compute_engine
  HostKeyAlias compute.<VM_ID>
  IdentitiesOnly yes
  StrictHostKeyChecking yes
  CheckHostIP no
  UserKnownHostsFile ~/.ssh/google_compute_known_hosts
  ProxyCommand ~/nixos-config/modules/shared/config/gcp-ssh-script.sh <VM_NAME> <PROJECT> <ZONE> %p
  User <USER>
```

> **Note:** The "%p" in the ProxyCommand is very important and specifies the port of your local machine (usually port 22, [see documentation](https://www.ssh.com/academy/ssh/port#:~:text=The%20default%20SSH%20port%20is%2022.)).
> Some variables are omitted compared to the SSH Host config above, as they are defaults (see [documentation](https://man.openbsd.org/ssh_config)).

You only need to specify the following:

- `<HOST_NAME>`: any name you want to use to refer to your VM.

The rest of the info can be found in the details of the VM instance on the Google Cloud Console.

- `<VM_ID>`
  - You can also run:
  
    ```bash
    gcloud compute instances describe ["name of the machine"] --zone ["name of the Zone"] --project ["name of the project"] --format="value(id)"
    ```

- `<VM_NAME>`
- `<PROJECT>`
- `<ZONE>`

You are now ready to connect to your VM from VSCode or using a simple SSH command as