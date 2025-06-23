<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->
<!-- markdownlint-disable MD041 MD047 MD059 -->

# macOS/Linux - Nix Config

For full documentation, visit [hugohakem.github.io/nix-os.config](https://hugohakem.github.io/nix-os.config/).

---

My Nix config is heavily inspired by:

+ [dustinlyons](https://github.com/dustinlyons/nixos-config/tree/main) for base NixOS + macOS configuration
+ [afermg: Moby Config](https://github.com/afermg/nix-configs) for home-manager (and my introduction to the Nix ecosystem)
+ [leoank: Neusis Config](https://github.com/leoank/neusis/tree/main) for templates

## Motivation

I chose Nix as my package manager because it enables:

+ **Declarative Configuration:** You can specify your configuration like a recipe, and Nix will seamlessly recreate it on any intended system. Sharing configs and environments becomes effortless!
+ **Reproducibility:** If it works on my machines, it will work on yours! With its inherent `.lock` file, package versioning is guaranteed to be consistent.
+ **Reliability:** Even if your build fails, previously installed packages remain intact, and you can easily roll back to previous build versions.

Note that [NixOS](https://nixos.org/) is an operating system built on these concepts. It's even more configurable, with hardware specifications, etc. I haven't chosen this option yet as it is more advanced and less beginner-friendly. However, it's possible to install NixOS on GCP (see [Resources](#resources-to-keep-in-mind)), and I may explore that in the future if a use case arises.

This Nix config relies on **Nix Home Manager**. I highly recommend checking the [home-manager tutorial](#github-repos) below in the resources section if you want to get familiar with the Nix syntax and how to obtain a minimal configuration.

## Project Layout

```text
.
├── apps                    # Custom nix commands written in shell script
│   ├── ...
│   └── README.md
├── flake.lock              
├── flake.nix               # Core config
├── gcp-installation.md
├── hosts                   # Where `modules` are imported
│   ├── darwin
│   │   └── ...
│   ├── linux
│   │   └── ...
│   └── README.md
├── modules                 # Where files, packages, and programs are defined
│   ├── darwin
│   │   ├── ...
│   │   └── README.md
│   ├── linux
│   │   ├── ...
│   │   └── README.md
│   └── shared
│       ├── config          # Program configs like vscode, zsh, emacs
│       │   └── ...
│       ├── ...
│       └── README.md
├── overlays                # Package fixes
│   ├── ...
│   └── README.md
└── templates               # Project templates
    ├── deprecated          # Archived / for learning purposes
    │   └── ...
    ├── pythonml
    │   └── ...
    └── README.md
```

## Getting Started

To set up a new machine, please follow the corresponding guide:

+ For Linux: [`gcp-installation.md`](gcp-installation.md)
  + **Note:** Originally intended for setting up a Google Cloud Virtual Machine.
  + **Note:** Supports installation of CUDA drivers. See [nvidia-drivers-installation.md](nvidia-drivers-installation.md) for details.

+ For macOS: [`mac-installation.md`](mac-installation.md)

These guides will refer you to the various `README.md` files outlined in the [Project Layout](#project-layout). You will find useful explanations to help you understand the code and get familiar with Nix as a package manager. Useful commands and typical workflows are also documented there.

To set up a new project with `templates/pythonml`, add it to your project directory by running the following commands in your `$HOME` directory:

```bash
mkdir projects
cp -r nixos-config/templates/pythonml projects/[name-of-the-project]
```

For further details, refer to [`templates/`](templates-README.md).

### Note on My Editor

As of today, my editor of choice is [Visual Studio Code](https://code.visualstudio.com/). However, you may find some `Emacs`-related code in [modules/shared/config/emacs/](https://github.com/HugoHakem/nix-os.config/blob/main/modules/shared/config/emacs). As I have paused my Emacs journey for now, any Emacs code has been commented out. See the note on my editor in [modules/shared/config/README.md](config-README.md) to learn how to change the Visual Studio Code configuration to suit your [needs](https://github.com/HugoHakem/nix-os.config/blob/main/modules/shared/config/README.md#vscode-config).

## To-Do

+ [ ] Test config on a blank GCP virtual machine
  + [ ] Eventually add guidelines on how to minimally set up a virtual machine
+ [ ] Test config on a new Mac and add installation guide
  + [ ] Complete [mac-installation.md]
+ [ ] Learn Emacs or Vim and provide my custom config as a safeguard for systems where VSCode remote-ssh is not possible
+ [ ] Provide custom configs for WezTerm and Zsh

## Resources to Keep in Mind

### Nix Official Resources

#### Search

+ [Nix home-manager options](https://home-manager-options.extranix.com/)
+ [Nix packages](https://search.nixos.org/packages)
+ [Nix options](https://search.nixos.org/options) — useful for searching `services`
+ [Noogle: search functions and their documentation](https://noogle.dev/)

#### Manuals

+ [Nix home-manager manual](https://nix-community.github.io/home-manager/index.xhtml)
+ [Nix Darwin Manual](https://nix-darwin.github.io/nix-darwin/manual/)
+ [Nix Darwin options for macOS](https://mynixos.com/nix-darwin/options)
+ [NixOS installation guide for Google Cloud Engine](https://nixos.wiki/wiki/Install_NixOS_on_GCE) — moves completely away from Linux and installs NixOS. Less beginner-friendly but worth exploring for full reproducibility and control.
+ [Non-official but curated development handbook](https://dev.jmgilman.com/environment/tools/nix/)

### GitHub Repos

#### Tutorials

+ [home-manager tutorial](https://github.com/Evertras/simple-homemanager)

## Acknowledgements

As mentioned above, this configuration relies heavily on the NixOS/macOS backbone provided by [dustinlyons](https://github.com/dustinlyons/nixos-config/tree/main), as well as [afermg: Moby Config](https://github.com/afermg/nix-configs) and [leoank: Neusis Config](https://github.com/leoank/neusis/tree/main).

I am particularly grateful to [Alán](https://github.com/afermg) for introducing me to Nix and for his mentorship throughout my learning. I also thank [Ank](https://github.com/leoank) for the insightful discussions that helped refine my understanding of Nix.

As I am still learning about Nix, if you notice anything missing, bugs, or features that should be added, feel free to open an issue.