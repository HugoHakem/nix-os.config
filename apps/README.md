# Apps

## Layout

```text
.
├── aarch64-darwin
│   ├── apply
│   ├── build
│   ├── build-switch
│   └── rollback
├── aarch64-linux -> x86_64-linux
├── x86_64-darwin
│   ├── apply
│   ├── build
│   └── build-switch
└── x86_64-linux
    ├── apply
    ├── build-switch
    ├── install
    └── nvidia-drivers-installation.md
```

## Details

The apps in this directory are Nix installables. These are Bash scripts made available to Nix through the [`mkApp`](./../flake.nix#L47) function declared within the [`flake.nix`](./../flake.nix) file.

These Nix commands are tailored for different systems, including Linux (`x86_64-linux`, `aarch64-linux`) and Darwin (`aarch64-darwin`, `x86_64-darwin`).

They are executed with `nix run` and are referenced as part of the step-by-step instructions found in the main README.

In `x86_64-linux/`, you will find `nvidia-drivers-installation.md`, which provides guidelines for installing NVIDIA drivers. This process is handled automatically by the installer in [`x86_64-linux/install`](./x86_64-linux/install#L55-L137) for Ubuntu systems. The installation is optional, and you may prefer to perform it manually by following the guide in [`nvidia-drivers-installation.md`](./x86_64-linux/nvidia-drivers-installation.md).
