<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->
<!-- markdownlint-disable MD041 MD047 MD059 -->

# MacOS/Linux - Nix config

My Nix config is heavily inspired from:

+ [dustinlyons](https://github.com/dustinlyons/nixos-config/tree/main) for base NixOS + MacOS configuration
+ [afermg: Moby Config](https://github.com/afermg/nix-configs) for home-manager (and initiation to the nix world)
+ [leoank: Neusis Config](https://github.com/leoank/neusis/tree/main) for templates

## Motivation

I made Nix my Package Manager because it enables:

+ **A Declarative Configuration:** you can specify your configuration like a recipe, and Nix will be able to recreate it seamlessly for any system it was intended for. It is now easy to share config / environment!
+ **It is Reproducible:** If it work on my machines, it will work on yours! With its inhere `.lock` file, package versioning is additionally guaranteed to be the same.
+ **It is Reliable:** even if your build fail, you won't break the previously installed packages and you will even be able to rollback to previous build versions.

Note that [NixOS](https://nixos.org/) is an OS in its own right and is built on this whole concept. It's even more configurable, with hardware specification etc. I haven't chosen this option as it is more advanced and is less beginner friendly. It's possible though to install NixOS on GCP (see [Resources](#resources-to-keep-in-mind)) and I will eventually explore that aspect if I find the use case for it.

This Nix config relies on **Nix Home Manager** and I highly advice to check the [home-manager tutorial](#github-repo) down bellow in resources, if you want to get familiar with the Nix syntax and how a minimal configuration can be obtained.

## Project Layout

```text
.
├── apps                    # some custom nix command written in shell script
│   ├── ...
│   └── README.md
├── flake.lock              
├── flake.nix               # core config
├── gcp-installation.md
├── hosts                   # where `modules` gets imported altogether
│   ├── darwin
│   |   └── ...
│   ├── linux
│   |   └── ...
│   └── README.md
├── modules                 # where files, packages, programs get defined
│   ├── darwin
│   │   ├── ...
│   │   └── README.md
│   ├── linux
│   │   ├── ...
│   │   └── README.md
│   └── shared
│       ├── config          # programs config like vscode, zsh, emacs
│       │   └── ...
│       ├── ...
│       └── README.md
├── overlays                # packages fixes
│   ├── ...
│   └── README.md
├── README.md
└── templates               # project templates
    ├── deprecated          # here for archived / learning purposes
    │   └── ...
    ├── pythonml
    │   └── ...
    └── README.md
```

## Getting Started

To set-up a new machine, please follow the corresponding guide:

+ For Linux: [`gcp-installation.md`](gcp-installation.md)
  + **Note:** it is originally intended for setting up a Google Cloud Virtual Machine.
  + **Note:** it internally support installation of the CUDA drivers. Please the corresponding note at [nvidia-drivers-installation.md](nvidia-drivers-installation.md).

+ For MacOS: [`mac-installation.md`](mac-installation.md)

Note that those guides will refer you to the different `README.md` outlined in the [Project Layout](#project-layout). You will find useful explanation to help you dissect the code and getting familiar with Nix as a Package Manager. Useful command and traditional workflow can be found there.

To set-up a new project with `templates/pythonml`, add it to your project directory by running this command in your `$HOME` directory.

```bash
mkdir projects
cp -r nixos-config/templates/pythonml projects/[name-of-the-project]
```

For further detail, refer to the [`templates/`](templates-README.md)

### Note on my editor

As of today, my editor is [Visual Studio Code](https://code.visualstudio.com/). In this configuration, you may however find some `Emacs` related code like in [modules/shared/config/emacs/](https://github.com/HugoHakem/nix-os.config/blob/main/modules/shared/config/emacs). As I pause my Emacs journey for now any `Emacs` code has been commented out. See a note on my editor in [modules/shared/config/README.md](config-README.md) to see how to change the configuration of Visual Studio Code for your [need](https://github.com/HugoHakem/nix-os.config/blob/main/modules/shared/config/README.md#vscode-config).

## To-Do

+ [ ] Try config on a blank gcp virtual machine
  + [ ] Eventually add guidelines on how to minimally set-up a Virtual Machine
+ [ ] Try config on a new Mac and add installation guide
  + [ ] Complete [mac-installation.md]
+ [ ] Learn Emacs or Vim and provide my custom config as a safeguard for system where VSCode remote-ssh won't be possible.
+ [ ] Provide custom config for wezterm and zsh

## Resources to keep in mind

### Nix official resources

#### Search

+ [Nix home-manager options](https://home-manager-options.extranix.com/)
+ [Nix packages](https://search.nixos.org/packages)
+ [Nix options](https://search.nixos.org/options), useful to search for `services`
+ [Noogle to search functions and their documentation](https://noogle.dev/)

#### Manual

+ [Nix home-manager manual](https://nix-community.github.io/home-manager/index.xhtml)
+ [Nix Darwin Manual](https://nix-darwin.github.io/nix-darwin/manual/)
+ [Nix Darwin option for MacOS](https://mynixos.com/nix-darwin/options)
+ [NixOS installation guide for Google Cloud Engine](https://nixos.wiki/wiki/Install_NixOS_on_GCE). Here it move completely away from linux and really install NixOS. Maybe less beginner friendly but might be worth exploring for full reproducibility / control over the system.
+ [Non official but curated development handbook](https://dev.jmgilman.com/environment/tools/nix/)

### GitHub Repo

#### Tutorial

+ [home-manager tutorial](https://github.com/Evertras/simple-homemanager)

## Acknowledgement

As mentioned above this configuration relies heavily on the NixOS/MacOS backbone provided by [dustinlyons](https://github.com/dustinlyons/nixos-config/tree/main), as well as on the [afermg: Moby Config](https://github.com/afermg/nix-configs) [leoank: Neusis Config](https://github.com/leoank/neusis/tree/main).

I am particularly thankful to [Alán](https://github.com/afermg) for getting me introduced to Nix and for his mentoring throughout my learning. I am also thankful to [Ank](https://github.com/leoank) for the fruitful discussion that helped me refining my understanding about Nix.

To whom it may concern, I am still learning about Nix, so if there is anything I missed, bugs, or functionality that should be made available, feel free to open an issue.