# Hosts

## Layout

```text
.
├── darwin
│   └── default.nix
├── linux
│   └── default.nix
└── README.md
```

## Details

This is where respectively [`modules/darwin/home-manager.nix`](../modules/darwin/home-manager.nix) and [`modules/linux/home-manager.nix`](../modules/linux/home-manager.nix) get imported. Additionnally:

+ Some settings for the user specific nix.conf which is stored in `.config/nix/nix.conf`.
+ Some system wide setting / package get defined here like [here](darwin/default.nix#L30).
+ Some services get enabled and initialized with specific settings like [here](linux/default.nix#L28).
  + A list of services can be found in [search.nixos.org](https://search.nixos.org/options?channel=24.11&from=0&size=50&sort=relevance&type=packages&query=services).

Unless you have to define such things (nix, system or services), you don't have to modify those files.
