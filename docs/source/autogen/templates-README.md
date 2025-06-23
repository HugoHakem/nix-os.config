<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->
<!-- markdownlint-disable MD041 MD047 MD059 -->

# Templates

This directory contains project templates to help you set up a working Nix environment.

## Table of Contents

- [Templates](#templates)
  - [Table of Contents](#table-of-contents)
  - [Layout](#layout)
  - [Details](#details)
  - [Template Descriptions](#template-descriptions)
    - [Python ML](#python-ml)
      - [Note on Package Managers](#note-on-package-managers)
      - [How to Add New Packages](#how-to-add-new-packages)
    - [Miscellaneous](#miscellaneous)
    - [Conda?](#conda)
    - [Working with a Persistent Jupyter Server](#working-with-a-persistent-jupyter-server)
      - [**Copy URL Kernel**](#copy-url-kernel)
  - [References](#references)

## Layout

```text
.
├── deprecated
│   └── ...
└── pythonml
    ├── .envrc
    ├── .gitignore
    ├── .nix
    │   ├── flake.nix
    │   └── packages
    │       ├── default.nix
    │       ├── README.md
    │       └── tmp.nix
    ├── .vscode
    │   └── settings.json
    ├── pyproject.toml
    ├── README.md
    └── src/

```

## Details

The philosophy here is to provide a `flake.nix` that sets up a Nix shell specific to your project.

Whenever you are in your project folder, the environment will activate automatically thanks to [`direnv`](https://direnv.net/), which uses `.envrc`. In `.envrc`, you typically set: `use flake .` or, if needed, `use flake . --impure`, and configure everything else in `flake.nix`.

When entering your project, direnv is not allowed by default. You need to run the following in your project folder:

```bash
direnv allow
```

If you prefer not to use direnv, you can load your Nix shell at any time with:

```bash
nix develop .
```

Python projects are managed using `uv` (see the [section below](#note-on-package-managers) for the rationale).

## Template Descriptions

### Python ML

This template provides an example of how to set up a **Machine Learning project**. Note that it has only been tested on Linux, but it should also work on macOS. For NixOS, you may need additional functionality; please refer to [deprecated](deprecated-README.md).

#### Note on Package Managers

Packages are managed both through `nix` and `uv`.

- As with your nixos-config, you can manage any package dependencies with Nix in the `flake.nix` file.
  - For example, there may be external system packages required for your Python packages to work correctly, or you may want to specify other project-specific packages such as `duckdb`.
- For standard Python project dependencies, you will use `uv`.

**Why `uv` and not another package manager?**

> [`uv`](https://docs.astral.sh/uv/) is an extremely fast Python package and project manager, written in Rust. It is intended to replace `poetry`, `pyenv`, `pip`, and `virtualenv`.

For pure Python development, `uv` is a lighter, faster alternative to `conda`. See the [Python Developer Tooling Handbook](https://pydevtools.com/handbook/explanation/why-should-i-choose-conda/#when-conda-may-not-be-ideal-1) for a discussion. `conda` is preferable for projects involving other languages, but then you likely won't use this template.

If you are wondering whether to use a `requirements.txt` file or a `pyproject.toml` file to manage your Python dependencies, please read this [Python Developer Tooling Handbook](https://pydevtools.com/handbook/explanation/pyproject-vs-requirements/).

In brief, `pyproject.toml` is a more powerful and modern alternative to `requirements.txt`. It is used for:

- Package dependencies
- Package version pinning
- Specifying the required Python version
- Adding project metadata (description, etc.)

A `requirements.txt` file is only for the first two points. Both are easy to handle using `uv`, but `pyproject.toml` is the newest and **officially recommended** approach (even though `requirements.txt` might feel easier at first).

#### How to Add New Packages

1. **Non-Python Packages** should be added in [flake.nix](https://github.com/HugoHakem/nix-os.config/blob/main/templates/pythonml/.nix/flake.nix#L34-39):

   ```nix
   # General packages for your dev shell
   packages = (with pkgs; [
     # e.g., duckdb 
   ]) ++ (with mpkgs; [
     uv  # pull latest uv from nixpkgs master
   ]);
   ```

   Note that you can only do so if the package is listed under [NixOS Search - Packages](https://search.nixos.org/packages)

2. **Non-Python Packages not available in NixOS search**
   If desired package is not natively available with nix, then you must register it as a CustomPackages. Please follow the associated [.nix/packages/add-custom-packages.md](add-custom-packages.md).

3. **Python Packages** using `uv`:

   ```bash
   uv add [name-of-the-package]
   ```
  
   For more details on using `uv`, see the [uv cookbook](https://docs.astral.sh/uv/getting-started/features/#python-versions).

### Miscellaneous

When loading the environment, `uv sync` is run automatically thanks to [this line](https://github.com/HugoHakem/nix-os.config/blob/main/templates/pythonml/.nix/flake.nix#L66) in `flake.nix` within the `ShellHook`. Note:

- You can customize the `ShellHook` to your needs.
- For development purposes, you may want to update `uv sync` with extra dependencies specified in `pyproject.toml`, such as `uv sync --extra cu128`. You can keep the base `uv sync` and run your own `sync` as needed.

The provided `pyproject.toml` is only an example. Feel free to replace it with your own. Refer to the guide on [`pyproject.toml`](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/).

### Conda?

If you would like to use conda as your package manager, please open an issue and I will consider providing a `flake.nix` for that purpose.

Otherwise, it is generally best not to mix package managers. Conda is a generic package manager, as is Nix, so there is little benefit in using both. Instead, install Conda with your preferred method by following their installation guide:

- [Conda documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html)
- [Miniconda installer](https://www.anaconda.com/docs/getting-started/miniconda/install#linux)

### Working with a Persistent Jupyter Server

There are two ways to do this (whether you use the template or Conda):

**Template method:**

If you use the template, you can create a `.ipynb` file and your environment will be detected seamlessly. However, you may want to make your Jupyter notebook persistent.

You can do so by running the following in your project directory:

```bash
nohup .venv/bin/jupyter lab --allow-root --no-browser > error.log & echo $! > pid.txt
```

`nohup` will create a background process with a Jupyter server. Additionally, errors are redirected to `error.log` and the process ID is saved to `pid.txt`, so you can kill the process if needed:

```bash
kill $(cat pid.txt)
```

You can check running Jupyter servers with:

```bash
jupyter server list
```

This will display the running server with a URL like:

```bash
http://localhost:8888/?token=f1d62a4e83c474ae1e6bf4c6e2ffc130f5d43ce37ce81ac9
```

Simply copy and paste the URL into your notebook kernel by clicking on the kernel in the upper right corner and choosing "Select Another Kernel".

#### **Copy URL Kernel**

> You can also kill the process by running:
>
> ```bash
> jupyter notebook stop 8888
> ```
>
> If you do not want `pid.txt` or `error.log` in your directory, you can remove them from the command.

**Conda method:**

You can run the Jupyter notebook process in the background using `tmux` (or `screen`). For example:

```bash
tmux new -s jupyter

conda activate <your_conda_env>

jupyter notebook
```

Then exit the `tmux` session and copy the URL as described [above](#copy-url-kernel).

## References

You may find the following references helpful:

- [`NixOS Wiki Python`](https://nixos.wiki/wiki/Python): Explains the standard approach for using NixOS and Python. Note that not everything applies to our use case since we are on Linux and not NixOS.