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
├── README.md
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

The apps in this directory are Nix installables. Those are bash script and are made available to nix through the [`mkApp`](./../flake.nix#L47) function declared within the [`flake.nix`](./../flake.nix) file.

These Nix commands are tailored for different systems, including Linux (x86_64-linux, aarch64-linux) and Darwin (aarch64-darwin, x86_64-darwin).

They execute with `nix run` and are referenced as part of the step-by-step instructions found in the README.

In `x86_64-linux/` you will find `nvidia-drivers-installation.md` which provide a guideline for the installation of NVIDIA drivers. It is handled automatically by the installer in [`x86_64-linux/install`](./x86_64-linux/install#L55-L137) for Ubuntu system. The installation has been made optional and you may prefer to do it yourself following the guide in [`nvidia-drivers-installation.md`](./x86_64-linux/nvidia-drivers-installation.md).
