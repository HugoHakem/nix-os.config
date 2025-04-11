## nix config
My nix config is adapted from 

## structure 
```
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
- [ ] add guidelines to set-up nix 
- [ ] create template
- [ ] add set-up gcloud vm
- [ ] add vscode extensions