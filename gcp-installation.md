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
