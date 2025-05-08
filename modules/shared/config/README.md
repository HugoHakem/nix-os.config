# Custom Config

## Layout

```text
.
├── emacs
│   └── ...
├── p10k.zsh
├── README.md
├── vscode
    └── ...
└── wezterm.lua
```

## Vscode config

### Vscode - Layout

```text
.
├── extensions.txt
├── install-extensions.sh
├── keybindings.json
├── README.md
└── settings.json
```

#### Vscode - Details

The core of your pre-defined vscode config is defined here.

+ In `extension.txt` you can define any extension you may need. It will be download from source with the `code`, the **vscode CLI**.
  + It is called in [modules/darwin/home-manager](../../darwin/home-manager.nix#L47-L50) and in [modules/linux/home-manager](../../linux/home-manager.nix#L27-L30).
+ In `keybindings.json` you will define any keybindings for your vscode config. Those are only applied in your Darwin config (This make sense because you will usually simply ssh to your server, you won't run vscode from here).
  + It is called in [modules/darwin/files](../../darwin/files.nix#L19-L23).
+ `settings.json` you will define any setting for your vscode config.
  + It is called in [modules/darwin/files](../../darwin/files.nix#L24-L28).

**CAREFUL**:

Since the keybindings and settings are made mutable for seamless definition through vscode directly, they won't be updated here in that folder. That means that perfect reproducibility is lost. Hence if you happen to define new extensions, keybindings or settings you may want to copy past it once in a while.

Once in a while, you may want to:

+ Copy your running extensions into the `extensions.txt`. An example of command from your home directory:

    ```bash
    code --list-extensions > nixos-config/modules/shared/config/vscode/extensions.txt
    ```

+ copy past the file that you will find here `/Users/${user}/Library/Application Support/Code/User/` to [`nixos-config/modules/shared/config/vscode/`](config/vscode/keybindings.json). An example of bash command could be:

    ```bash
    cp Library/Application\ Support/Code/User/keybindings.json nixos-config/modules/shared/config/vscode/keybindings.json
    cp Library/Application\ Support/Code/User/settings.json nixos-config/modules/shared/config/vscode/settings.json
    ```

## Zsh config

My zsh shell config is extracted from [dustinlyons](https://github.com/dustinlyons/nixos-config/tree/main/modules/shared/config). It is enabled in the [modules/shared/programs.nix](../programs.nix#L15-L17).

## Wezterm config

A very basic wezterm config (almost the default one). This is provided as an example of what can be done to set-up your wezterm config. For more details, please visit the [official documentation](https://wezterm.org/config/files.html).

Some blog or github repo you might find useful to work on your Wezterm config:

+ [Josean how to zet up wezterm terminal](https://www.josean.com/posts/how-to-setup-wezterm-terminal)
+ [Sravioli config](https://github.com/sravioli/wezterm)

## Emacs config

### Emacs - Layout

```text
.
├── config.org
├── init.el
└── README.md
```

### Emacs - Details

This is where the core of the Emacs configuration get defined.

**DISCLAIMER**:

+ Right now, I gave up on Emacs as I rather prefer working with vscode for now. In addition it builds quite slowly on the GCP and I rather prefer this config to be a general purpose one (and you will concede that there is not so many Emacs users...).
  + I made easy the process of enabling Emacs though, it suffice to uncomment any code under `# EMACS UTILITIES`.
+ Right now the config is extracted from [Dustinlyons](https://github.com/dustinlyons/nixos-config/tree/main/modules/shared/config/emacs). I might prefer using a different config such as the one from [here](https://github.com/HugoHakem/nix-configs) or better from [Alán's](https://github.com/afermg/nix-configs).
+ Also I might want to enable my [simple doom config](https://github.com/HugoHakem/doom) or even more complex the original [doom](https://github.com/doomemacs/doomemacs)
+ I don't exclude the fact that I will move completely away from Emacs to try out Vim. A simple Vim config is already present in [programs](../../programs.nix#L59) and is coming from [Dustinlyons](https://github.com/dustinlyons/nixos-config/blob/main/modules/shared/home-manager.nix#L100C3-L208). I will eventually get inspiration from [neovim](https://github.com/neovim/neovim), or even better [AstroNvim](https://github.com/AstroNvim/AstroNvim) or [NixVim](https://github.com/leoank/neusis/tree/67fb98c19cffa1e21af03e042b20a2d611ce4c72/homes/common/dev/nixvim) config from Ank.

## Gcp ssh script

Script to automatize the `ProxyCommand` in a **SSH Host Config**. Please refer to the **Remote SSH section** in [gcp-installation.md](../../../gcp-installation.md#remote-ssh).
