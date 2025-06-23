# Hosts

## Layout

```text
.
├── darwin
│   └── default.nix
└── linux
    └── default.nix
```

## Details

This is where [`modules/darwin/home-manager.nix`](./../modules/darwin/home-manager.nix) and [`modules/linux/home-manager.nix`](./../modules/linux/home-manager.nix) are imported. Additionally:

+ Some settings for the user-specific `nix.conf`, which is stored in `.config/nix/nix.conf`.
+ Some system-wide settings or packages are defined here, as shown [`default.nix`](./darwin/default.nix#L30).
+ Some services are enabled and initialized with specific settings, as shown [`default.nix`](./linux/default.nix#L28).
  + A list of available services can be found at [search.nixos.org](https://search.nixos.org/options?channel=24.11&from=0&size=50&sort=relevance&type=packages&query=services).

Unless you need to define such things (Nix settings, system-wide options, or services), you typically do not
need to modify those files.
