
# Templates

You will find here project template to set up a running nix environment.

## Table of Contents

- [Templates](#templates)
  - [Table of Contents](#table-of-contents)
  - [Layout](#layout)
  - [Details](#details)
  - [Templates Description](#templates-description)
    - [Python ML](#python-ml)
      - [Note on the Package managers](#note-on-the-package-managers)
      - [How to add new packages](#how-to-add-new-packages)
    - [Miscellaneous](#miscellaneous)
    - [Conda ?](#conda-)
    - [Working on a persistent Jupyter](#working-on-a-persistent-jupyter)
- [References](#references)

## Layout

```text
.
├── deprecated
│   └── ...
├── pythonml
│   ├── .envrc
│   ├── .gitignore
│   ├── flake.nix
│   ├── pyproject.toml
│   ├── README.md
│   └── src
└── README.md
```

## Details

The philosophy here is to provide a `flake.nix` that will set up a running nix shell that is specific to your project.

Whenever you are in the folder of your project, it will activate automatically thanks to [`direnv`](https://direnv.net/) that makes use of `.envrc`. In the `.envrc`, you will often only set: `use flake .` or eventually `use flake . --impure`, and set up everything else in the `flake.nix`.

When entering your project, direnv is not allowed by default. You need to run in the project folder:

```bash
direnv allow
```

If you rather prefer not making use of direnv, you may use everytime you want to load your nix shell:

```bash
nix develop . 
```

Python Project are managed thanks to `uv` (see the [subsequent reason](#note-on-the-package-managers)  for this choice).

## Templates Description

### Python ML

This templates provide an example of how to set up a **Machine Learning project**. Note that it has only been tested on Linux, but it should also work on MacOS. For NixOS, you will need additional functionality, please refer to [deprecated](deprecated/README.md).

#### Note on the Package managers

Packages are handled both through `nix`, and through `uv`.

- As for your nixos-config, you may handle any of your package dependencies with the `nix` in the `flake.nix` file.
  - For instance there might be external system packages that should be available on your system so that the python packages work correctly. Or you may just want to specify other packages specific to your project such as `duckdb`
- As for a standard python project, you will handle all the python packages with `uv`.

**Why `uv` and not another package manager ?**

> [`uv`](https://docs.astral.sh/uv/) is an extremely fast Python package and project manager, written in Rust. It is meant to replace `poetry`, `pyenv`, `pip`, `virtualenv`.

For pure Python development, `uv` is a lighter, faster alternative to `conda`. See the [Python Developper Tooling Handbook](https://pydevtools.com/handbook/explanation/why-should-i-choose-conda/#when-conda-may-not-be-ideal-1) for a discussion about it. `conda` can be preferred for project involving other languages (but then you won't be using that template).

If you are wondering whether you should be using `requirement.txt` file or `pyproject.toml` file to manage your python dependencies, please read through this [Python Developper Tooling Handbook](https://pydevtools.com/handbook/explanation/pyproject-vs-requirements/).

In brief, `pyproject.toml` is a `requirement.txt` file on steroid, it it used for:

- packages dependencies
- packages version pinning
- python version required
- add project metadata (description etc.)

`requirement.txt` file is solely for the two first points.
In any case, both are easy to handle using `uv`, but `pyproject.toml` is the newest and **official recommended** way to proceed (even though `requirement.txt` might feel easier to play with at the begining).

#### How to add new packages

1. **Non Python Packages** should be added in the [flake.nix](pythonml/flake.nix#L34-39)

   ```nix
   # General packages for your dev shell
   packages = (with pkgs; [
    # e.g., duckdb 
   ]) ++ (with mpkgs; [
    uv  # pull latest uv from nixpkgs master
   ]);
   ```

2. **Python Packages** using `uv`

   ```bash
   uv add [name-of-the-package]
   ```
  
  For more details on using `uv` see the [uv cookbook](https://docs.astral.sh/uv/getting-started/features/#python-versions).

### Miscellaneous

When loading the environment, `uv sync` is run automatically thanks to [this line](pythonml/flake.nix#L66) in `flake.nix` within the `ShellHook`. Note that:

- You can customize the `ShellHook` to your needs.
- In particular, for development purposes, you may want to update `uv sync` with some extra dependencies specified in the `pyproject.toml` such as `uv sync --extra cu128`. Also you may keep the base `uv sync` and just not to run your own `sync` whenever you need it.

The `pyproject.toml` is only here as an example. Feel free to discard it and replace it by your own. You may refer to the guide on [`pyproject.toml`](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/)

### Conda ?

If you really want to use conda as your package manager, please open an issue and I will eventually provide a flake.nix to do so.

Otherwise, the simplest is probably not to mix package manager. Conda is supposed to be a generic package manager as Nix is, so there is not much point of using both. Instead please install Conda with whatever flavor you like by following their installation guide:

- [Conda documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html)
- [Miniconda installer](https://www.anaconda.com/docs/getting-started/miniconda/install#linux).

### Working on a persistent Jupyter

There is two ways of doing this (whether you use the template or Conda):

**Template way**:

If you work with the template, you can create a `.ipynb` file and this will detect seamlessly your environment. However, you may want to make your jupyter notebook persistent.

You can do so by simply doing in your project directory:

```bash
nohup .venv/bin/jupyter lab --allow-root --no-browser > error.log & echo $! > pid.txt
```

`nohup` will create a background process with a jupyter server. Additionally you redirect every error into `error.log` and you move the `PID` into a `pid.txt` so you can kill the process if you need to by simply doing:

```bash
kill $(cat pid.txt)
```

You can connect to the jupyter server such that:

```bash
jupyter server list
```

Which will display the running server with a URL looking like this:

```bash
http://localhost:8888/?token=f1d62a4e83c474ae1e6bf4c6e2ffc130f5d43ce37ce81ac9
```

You can simply copy past it the `URL` <a id=copy-url-kernel></a> into your notebook kernel by clicking on the kernel in the upper right corner and choosing `Select Another Kernel`.

> Note that you can also kill the process by doing:
>
> ```bash
> jupyter notebook stop 8888
> ```
>
> Then if you don't like having pid.txt or error.log in your file directory you can remove them from the command.

**Conda Way**:

You can run the jupyter notebook process in the background thanks to `tmux` (or `screen`). Then you can do:

```bash
tmux new jupyter

conda activate <your_conda_env>

jupyter notebook
```

Then you exit the `tmux` session and you can copy past the URL as done [before](#copy-url-kernel).

# References

You may want to read through the following references:

- [`NixOS Wiki Python`](https://nixos.wiki/wiki/Python)
  Explains the standard in terms of using NixOS and Python. Careful, not everything applies to our use case since we are on Linux and not on the NixOS
