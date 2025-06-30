# Pixi Python ML Templates

This directory provides two templates for setting up Python machine learning projects using [Pixi](https://pixi.sh/) for environment and dependency management:

## Layout

```text
.
├── flake-python-ml
│   └── ...
└── global-python-ml
    └── ...
```

## Template Overview

### `flake-python-ml`

- **Purpose:**  
  Combines Pixi with Nix flakes for advanced and reproducible development environments.
- **Workflow:**  
  - Most Python dependencies are managed via Pixi [`pyproject.toml`](./flake-python-ml/pyproject.toml).
    - It can even handle the adding of packages that are neither on [PyPI](https://pypi.org/) nor [Official Conda channels](https://prefix.dev/channels) using [private channels](https://prefix.dev/docs/prefix/channels#public-vs-private-channels).
  - For rare cases where a package is unavailable or needs customization, you may still want to define custom Nix packages in the `.nix/overlays` dir, please refer to [overlays docs](./../../overlays/README.md). Remember however that the goal of using `pixi` is to provide a pure `nix` agnostic solution.
  - The `flake.nix` file provides a Nix-based development shell that integrates with Pixi. It load automatically the `dev` pixi shell. You may want to override this behavior in the [shellhook](./flake-python-ml/.nix/flake.nix#L53).
- **Use Case:**  
  Ideal for users who want the flexibility of Nix for custom or system-level dependencies, while still leveraging Pixi for Python package management. Additionally thanks to nix you can specify which `pixi` version you want without overriding your system wide `pixi`.

### `global-python-ml`

- **Purpose:**  
  A pure Pixi template for Python ML projects integrating in the conda environment.
- **Workflow:**  
  - All dependencies are managed through Pixi and specified in `pyproject.toml`.
  - No Nix overlays or custom Nix packaging.
  - As earlier, it can even handle the adding of packages that are neither on [PyPI](https://pypi.org/) nor [Official Conda channels](https://prefix.dev/channels) using [private channels](https://prefix.dev/docs/prefix/channels#public-vs-private-channels).
- **Use Case:**  
  Best for projects where all requirements can be satisfied by PyPI or Conda packages, and no custom Nix packaging is needed.

## GPU Acceleration

- **Tested:**  
  Both templates have been tested for GPU-accelerated workflows (e.g., PyTorch with CUDA) **on Linux only**.
- **To-Do:**  
  - Test for compatibility and GPU support on:
    - [ ] macOS
    - [ ] NixOS

## Documentation & Related Issues

### Docs

- For troubleshooting Pixi environments or advanced usage, refer to the official [Pixi Python tutorial](https://pixi.sh/dev/python/tutorial/).

### Issues & Solutions

- For pure NixOS, you may want to refer to: [NixOS/nixpkgs#316443](https://github.com/NixOS/nixpkgs/issues/316443).
- Discussion with [@gnodar01 in HugoHakem/nix-os.config#14](https://github.com/HugoHakem/nix-os.config/issues/14).
- Feature request: Byte-compile python at install time [prefix-dev/pixi#1981](https://github.com/prefix-dev/pixi/issues/1981)
  - Work around for byte-compilation using pixi by [@gnodar01 in bilayer-containers/bilayers Dockerfile (L25-L26)](https://github.com/bilayer-containers/bilayers/blob/2a0fcddd6967a9408a08b41ee907340b339849dc/src/algorithms/instanseg_inference/Dockerfile#L25-L26)
- `pixi shell` breaking the custom Bash prompt (PS1) and disables arrow key navigation [HugoHakem/nix-os.config#16](https://github.com/HugoHakem/nix-os.config/issues/16)

---

*For suggestions or issues, please open an issue or pull request.*
