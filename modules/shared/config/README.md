# Custom Config

## Layout

```text
.
├── emacs
│   └── ...
├── gcp-ssh-script.sh
├── starship.toml
├── vscode
│   └── ...
└── wezterm.lua
```

## VSCode Config

### VSCode - Layout

```text
.
├── extensions.txt
├── install-extensions.sh
├── keybindings.json
├── settings.json
└── snippets
    └── python.json
```

#### VSCode - Details

The core of your pre-defined VSCode configuration is defined here.

+ In `extensions.txt`, you can define any extension you may need. Extensions will be downloaded from source using the `code` CLI (VSCode CLI).
  + This is referenced in [modules/darwin/home-manager](./../../darwin/home-manager.nix#L47-L50) and [modules/linux/home-manager](./../../linux/home-manager.nix#L27-L30).
+ In `keybindings.json`, you define any keybindings for your VSCode configuration. These are only applied in your Darwin config (this makes sense because you will usually SSH to your server, not run VSCode directly there).
  + Referenced in [modules/darwin/files](./../../darwin/files.nix#L27-L31).
+ In `settings.json`, you define any settings for your VSCode configuration.
  + Referenced in [modules/darwin/files](./../../darwin/files.nix#L32-L36).
+ In `snippets`, you define any settings for your VSCode snippet configuration.
  + Referenced in [modules/darwin/files](./../../darwin/files.nix#L38-L49).

**Note:**

Since keybindings and settings are made mutable for seamless editing directly through VSCode, they will not be automatically updated in this folder. This means perfect reproducibility is lost. If you define new extensions, keybindings, or settings, you should periodically copy them back here.

To keep your configuration up to date:

+ Copy your current extensions into `extensions.txt`. For example, from your home directory:

    ```bash
    code --list-extensions > nixos-config/modules/shared/config/vscode/extensions.txt
    ```

+ Copy the files from `/Users/${user}/Library/Application Support/Code/User/` to [`nixos-config/modules/shared/config/vscode/`](./vscode/keybindings.json). For example:

    ```bash
    cp "Library/Application Support/Code/User/keybindings.json" nixos-config/modules/shared/config/vscode/keybindings.json
    cp "Library/Application Support/Code/User/settings.json" nixos-config/modules/shared/config/vscode/settings.json
    ```

## Starship Config

I use Starship as a cross shell customizable prompt. It allows the same design wether you are on `zsh`, `bash` or others.

+ This implementation follow the issue [HugoHakem/nix-os.config#17](https://github.com/HugoHakem/nix-os.config/issues/17)
+ I like it because it can detect `nix-shell`, `pixi-shell` or `direnv` and [many more](https://starship.rs/config/).
+ It is enabled in [modules/shared/programs.nix](./../programs.nix#L28-L31) and in [modules/darwin/home-manager.nix](./../../darwin/home-manager.nix#L57-59), [modules/linux/home-manager.nix](./../../linux/home-manager.nix#L40-42).

## WezTerm Config

A very basic WezTerm configuration (almost the default). This is provided as an example of how to set up your WezTerm config. For more details, please visit the [official documentation](https://wezterm.org/config/files.html).

Some blogs or GitHub repositories you might find useful for customizing your WezTerm config:

+ [Josean: How to set up WezTerm terminal](https://www.josean.com/posts/how-to-setup-wezterm-terminal)
+ [Sravioli config](https://github.com/sravioli/wezterm)

## GCP SSH Script

Script to automate the `ProxyCommand` in an **SSH Host Config**. Please refer to the **Remote SSH section** in [gcp-installation.md](./../../../gcp-installation.md#remote-ssh).

## Emacs Config

### Emacs - Layout

```text
.
├── config.org
├── init.el
└── README.md
```

### Emacs - Details

This is where the core of the Emacs configuration is defined.

**Disclaimer:**

+ Currently, I have paused using Emacs in favor of VSCode. Additionally, Emacs builds slowly on GCP, and I prefer this configuration to be general-purpose (and, admittedly, Emacs has a smaller user base).
  + However, enabling Emacs is straightforward: simply uncomment any code under `# EMACS UTILITIES`.
+ The current configuration is adapted from [dustinlyons](https://github.com/dustinlyons/nixos-config/tree/main/modules/shared/config/emacs). I may switch to a different configuration, such as [the moby server](https://github.com/HugoHakem/nix-configs) or [Alán's](https://github.com/afermg/nix-configs).
+ I may also enable my [simple Doom config](https://github.com/HugoHakem/doom) or even the original [doom](https://github.com/doomemacs/doomemacs).
+ I may eventually move away from Emacs to try Vim. A simple Vim config is already present in [programs](./../programs.nix#L33-140), adapted from [dustinlyons](https://github.com/dustinlyons/nixos-config/blob/main/modules/shared/home-manager.nix#L100C3-L208). I may also take inspiration from [neovim](https://github.com/neovim/neovim), [AstroNvim](https://github.com/AstroNvim/AstroNvim), or [NixVim](https://github.com/leoank/neusis/tree/67fb98c19cffa1e21af03e042b20a2d611ce4c72/homes/common/dev/nixvim) from Ank.
