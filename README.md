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

+ [Nix home-manager options](https://home-manager-options.extranix.com/)
+ [Nix packages](https://search.nixos.org/packages)
+ [Nix install on Google Cloud Engine](https://nixos.wiki/wiki/Install_NixOS_on_GCE)
+ [Nix home-manager manual](https://nix-community.github.io/home-manager/index.xhtml#sec-3rd-party-module-collections)

### Learning Ressources & GitHub

+ [home-manager tutorial](https://github.com/Evertras/simple-homemanager)
+ [Neusis Config - Broad Imaging Platform](https://github.com/leoank/neusis)
+ [Gcloud nix](https://github.com/nicknovitski/gcloud-nix)
+ [Moby Config - Broad Imaging Platform](https://github.com/afermg/nix-configs)
