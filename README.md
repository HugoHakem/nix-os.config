# nix config

My nix config is adapted from [here](https://github.com/dustinlyons/nixos-config/tree/main)

## structure

```text
.
├── apps                      # some nix script
│   └── ...
├── flake.lock
├── flake.nix                 # main config
├── hosts                     # where modules are applied on respectives machines
│   ├── darwin
│   │   └── default.nix
│   └── nixos
│       └── default.nix
├── modules                   # where packages are managed
│   ├── darwin                # specific to MacOS
│   │   ├── casks.nix         # to download from casks
│   │   ├── dock              # utilities to manage dock
│   │   ├── files.nix         # where files are created or linked
│   │   ├── home-manager.nix  # where packages, files are put together in nix home-manager
│   │   ├── packages.nix      # add packages
│   │   └── README.md
│   ├── nixos                 # specific to NixOS
│   │   ├── config            # Home graphical interface of the server (for physical machine)
│   │   ├── disk-config.nix   # Disk configuration
│   │   ├── files.nix
│   │   ├── home-manager.nix
│   │   ├── packages.nix
│   │   └── README.md
│   └── shared                # shared config between NixOS and MacOS
│       ├── cachix            # trusted caches, avoid rebuilding from source
│       ├── config            # config for specific apps
│       │   ├── emacs         # emacs config
│       │   ├── p10k.zsh      # zsh visual config
│       │   └── vscode        # vscode config
│       ├── default.nix
│       ├── files.nix
│       ├── home-manager.nix
│       ├── mutable.nix       # define home.file mutable options
│       ├── packages.nix
│       └── README.md
├── overlays                  # to overwrite packages or add fixes
│   ├── 10-feather-font.nix
│   └── README.md
└── README.md
```

## setting up

Change `user` in:

+ `flake.nix`

Change `name` and `email` in:

+ `modules/shared/home-manager.nix`

## To-Do

+ [ ] add guidelines to set-up nix
+ [ ] create template
+ [ ] add set-up gcloud vm
+ [ ] add vscode extensions

## Ressources to keep in mind

### Nix official ressources

#### Search

+ [Nix home-manager options](https://home-manager-options.extranix.com/)
+ [Nix packages](https://search.nixos.org/packages)

#### Manual

+ [Nix home-manager manual](https://nix-community.github.io/home-manager/index.xhtml#sec-3rd-party-module-collections)
+ [Nix Darwin Manual](https://nix-darwin.github.io/nix-darwin/manual/)
+ [Nix Darwin option for MacOS](https://mynixos.com/nix-darwin/options)
+ [Nix install on Google Cloud Engine](https://nixos.wiki/wiki/Install_NixOS_on_GCE)

### GitHub Repo

#### Tutorial

+ [home-manager tutorial](https://github.com/Evertras/simple-homemanager)

#### Repo to keep in mind

+ [Gcloud nix](https://github.com/nicknovitski/gcloud-nix)
+ [Broad Imaging Platform - Neusis Config](https://github.com/leoank/neusis)
+ [Broad Imaging Platform - Moby Config](https://github.com/afermg/nix-configs)
