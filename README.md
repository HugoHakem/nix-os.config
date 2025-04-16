# nix config

My nix config is adapted from [here](https://github.com/dustinlyons/nixos-config/tree/main)

## structure

```text
.
├── README.md
├── apps
│   ├── aarch64-darwin
│   ├── aarch64-linux -> x86_64-linux
│   ├── x86_64-darwin
│   └── x86_64-linux
├── flake.lock
├── flake.nix
├── hosts
│   ├── darwin
│   └── nixos
├── modules
│   ├── darwin
│   ├── nixos
│   └── shared
└── overlays
    ├── 10-feather-font.nix
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
