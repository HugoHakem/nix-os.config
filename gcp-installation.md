# Installation Tutorial for GCP

## Pre-Requisite

This tutorial assume:

+ A gcp virtual machine has already been set up.
+ A GPU is available, but the drivers are not necessarily pre-installed from GCP.
+ The disk is already configured.
+ The server is running on Ubuntu 22.04 with architecture x86/64.

## Connecting to the virtual machine

```bash
gcloud compute ssh ["name of the machine"] --zone ["name of the Zone"] 
```

## Installing NixOS package manager

Here we do not seek to switch completely from Linux to NixOS.

To install nix-os I will follow this [guide](https://github.com/Evertras/simple-homemanager/blob/main/01-install.md)
In particular, from the [NixOS documentation](https://nixos.org/download/#nix-install-linux), for multi-user installation:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

## Installing the configuration

```bash
nix run --extra-experimental-features 'nix-command flakes' github:HugoHakem/nix-os.config?ref=hh-virtual-machine#install
```

It will eventually fail and prompt:

```bash
:~$ nix run --extra-experimental-features 'nix-command flakes' github:HugoHakem/nix-os.config?ref=hh-virtual-machine#install
>>> Running install for x86_64-linux
>>> /nix/store/b10kvfv4gniyc0gdcf0g5r92ynmicxh7-install/bin/install: line 4: /nix/store/b9aka34salpd5ixic90sdl1av5pps1km-source/apps/x86_64-linux/install: Permission denied
>>> /nix/store/b10kvfv4gniyc0gdcf0g5r92ynmicxh7-install/bin/install: line 4: exec: /nix/store/b9aka34salpd5ixic90sdl1av5pps1km-source/apps/x86_64-linux/install: cannot execute: Permission denied
```

That means you don't have the authorization to run the script. You must make the file executable:

```bash
# CAREFUL: the [hash] after store/[hash]/apps/ might be different. Replace it by whatever fil you see. 
sudo chmod +x /nix/store/b9aka34salpd5ixic90sdl1av5pps1km-source/apps/x86_64-linux/install
```

### CUDA drivers

When setting up the VM, you may not have the CUDA drivers already installed. In the installation set up, CUDA drivers and toolkit are taking care of in the script. The installer will check if cuda drivers are working fine with:

```bash
nvidia-smi
```

If the command is not present or just fail, you will be prompt whether you want to install it through the script.

+ If you answer any of `(y|Y|yes|YES)` this will do the following:

    ```bash
    # Retrieve your OS name, and version
    . /etc/os-release
    OS_ID=$ID
    OS_VERSION_ID=$VERSION_ID
    ARCH=$(uname -m)
    # Retrieve your architecture
    case "$ARCH" in
    x86_64)
        ARCH_PATH="x86_64"
        ;;
    aarch64)
        ARCH_PATH="arm64"

    # Build a URL from those information from where to retrieve the installation kit in the NVIDIA archive
    URL="https://developer.download.nvidia.com/compute/cuda/repos/${OS_ID}${OS_VERSION_ID}/${ARCH_PATH}/cuda-keyring_1.1-1_all.deb"
    # Add the NVIDIA CUDA keyring and repo
    wget $URL
    sudo dpkg -i cuda-keyring_1.1-1_all.deb
    sudo apt-get update
    sudo apt-get -y install cuda
    ```

+ **If you have any doubt**, please skip the installation of CUDA by saying **no** to the prompt.
    Then follow the tutorial provided by [cloud.google.com](https://cloud.google.com/compute/docs/gpus/install-drivers-gpu) itself.  
    You will find 3 different guide.

  + **Install GPU drivers on VMs by using NVIDIA guides [here](https://cloud.google.com/compute/docs/gpus/install-drivers-gpu#no-secure-boot).**
    + In particular, when clicking on [NVIDIA CUDA Toolkit](https://developer.nvidia.com/cuda-toolkit-archive), you will end up on that [page](https://developer.nvidia.com/cuda-toolkit-archive). Then when wanting to [download the latest CUDA toolkit](https://developer.nvidia.com/cuda-downloads) they will suggest a script that is very similar to our installation mode:

    ```bash
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
    sudo dpkg -i cuda-keyring_1.1-1_all.deb
    sudo apt-get update
    sudo apt-get -y install cuda-toolkit-12-8 # here, by choosing `cuda` instead of `cuda-toolkit-12-8` it install both toolit and drivers
    ```

  + **Install GPU drivers on VMs by using installation script [here](https://cloud.google.com/compute/docs/gpus/install-drivers-gpu#install-script).**
    + Surprisingly, it didn't necessarily worked so well when trying to use their script. Following NVIDIA recipe is probably better but require to know more what you're doing.

  + **Install GPU drivers (Secure Boot VMs) [here](https://cloud.google.com/compute/docs/gpus/install-drivers-gpu#secure-boot)**
    + It wasn't not my use case. I don't know how secure boot VMs work with Nix...

## Questions for Alán

I don't understand the `modules/nixos/default.nix`.

+ boot
+ networking
+ services.xserver
+ hardware
+ virtualisation
+ openssh.authorizedKeys
+ security.sudo
+ system.stateVersion

In `apps/`:

+ Why is there not any `build` in `apps/x86_64-linux`
+ Why is there `SYSTEM=$(uname -m)` (I imagine to identify the system and build properly.) But then why is there not that in `apps/x86_64-darwin`.
+ Why is there a `rollback` option in `apps/aarch64-darwin` but not in `apps/x86_64-darwin`.
+ In `x86_64-linux/install` are my modification suggestion ok ?
