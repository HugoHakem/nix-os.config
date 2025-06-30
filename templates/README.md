# Templates

This directory provides project templates for setting up robust, reproducible Python environments—whether or not you use Nix. The goal is to offer **maximum flexibility** and **reproducibility** for both Nix and non-Nix users, leveraging [Pixi](https://pixi.sh/), [uv](https://docs.astral.sh/uv/), and Nix.

---

## Table of Contents

- [Templates](#templates)
  - [Table of Contents](#table-of-contents)
  - [Layout](#layout)
  - [Why Pixi, uv, and Nix?](#why-pixi-uv-and-nix)
    - [Motivation](#motivation)
    - [How to choose a template](#how-to-choose-a-template)
    - [Note on direnv](#note-on-direnv)
  - [Template Descriptions](#template-descriptions)
    - [Pixi Templates](#pixi-templates)
    - [uv Templates](#uv-templates)
    - [Package Management](#package-management)
      - [Further reading](#further-reading)
    - [Adding New Packages](#adding-new-packages)
  - [Know How](#know-how)
    - [Persistent Jupyter Server](#persistent-jupyter-server)
  - [GPU Acceleration](#gpu-acceleration)
  - [Documentation \& Debugging](#documentation--debugging)
  - [References](#references)

---

## Layout

```text
.
├── deprecated
│   └── ...
├── pixi-templates
│   ├── flake-python-ml
│   └── global-python-ml
└── uv-templates
    └── pythonml
```

---

## Why Pixi, uv, and Nix?

### Motivation

Traditional Python project setups in the Nix ecosystem use:

- [`uv`](https://docs.astral.sh/uv/) for Python dependencies via `pyproject.toml`
- [`nix`](https://search.nixos.org/packages) for system dependencies

While this works well for Nix users, it is not always accessible for those unfamiliar with Nix:

- Refer to the following issues: [HugoHakem/nix-os.config#14](https://github.com/HugoHakem/nix-os.config/issues/14)
  
Instead, when external (non-Python) packages are needed, users often turn to [`conda`](https://docs.conda.io/en/latest/), [`mamba`](https://mamba.readthedocs.io/en/latest/), or [`micromamba`](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html).

Recently, [**Pixi**](https://pixi.sh/latest/) from [prefix.dev](https://prefix.dev/docs/prefix/overview) (the same team that developed `micromamba`) has emerged as a modern, fast, and user-friendly all-in-one alternative. Pixi natively collaborates with `uv` for Python dependencies and offers a reproducible, cross-platform workflow.

**The Key idea with `pixi` become:**  

- Use `pixi` to manage system and Python dependencies.
  - [PyPI](https://pypi.org/) dependencies are managed with `uv` under the hood.
  - [conda channel](https://prefix.dev/channels) to provide anything that you would provide through `conda` traditionally. Please refer to [`pixi` docs on the subject](https://pixi.sh/latest/concepts/conda_pypi/).
  - [Privately hosted channel](https://prefix.dev/docs/prefix/channels) for packages that you cannot find otherwise.
- Use `nix` only to provide `pixi` or alternatively have system wide `pixi` to never have to rely on `nix` for your project that you wanna share simply to other non-nix users. In very rare scenario, one can imagine still using `nix` to provide some specific package that cannot seems to integrate in the `pixi` experience.

### How to choose a template

| Template                          | Best For                            | Nix Usage                               | Pixi Usage     | Shareability | Notes                                                      |
|-----------------------------------|-------------------------------------|-----------------------------------------|----------------|--------------|------------------------------------------------------------|
| `pixi-templates/flake-python-ml`  | Python + Conda + optional Nix       | ✅ Optional, fallback or for flexibility | ✅ Primary tool | High         | Flake provides `pixi`, no global install needed            |
| `pixi-templates/global-python-ml` | Pure Pixi workflows                 | ❌ None                                  | ✅ Primary tool | ✅ Best       | Fully Conda-based, no Nix assumptions                      |
| `uv-templates/pythonml`           | Python-only with optional dev tools | ✅ Dev tools only (e.g., `pandoc`)       | ❌ Not used     | Moderate     | Python-only; dev setup may not be reproducible without Nix |

### Note on direnv

These templates support [`direnv`](https://direnv.net/) for automatic environment loading:

- **Nix projects:** `.envrc` contains `use flake [dir]` or `use flake --impure [dir]`.
- **Pixi projects:** `.envrc` contains `eval "$(pixi shell-hook --environment dev)"`.

You can remove or customize `.envrc` as needed. For manual activation, use `nix develop` or `pixi shell --environment dev`.

---

## Template Descriptions

### Pixi Templates

See [`pixi-templates/README.md`](./pixi-templates/README.md) for details.

- **`flake-python-ml`:** Combines Pixi with Nix flakes for advanced, reproducible environments. Most dependencies are managed via Pixi (`pyproject.toml`). For rare cases, custom Nix packages can be defined in `.nix/overlays`. The `flake.nix` provides a Nix-based dev shell that loads the Pixi environment automatically.
- **`global-python-ml`:** Pure Pixi template for Python ML projects. All dependencies are managed through Pixi and specified in `pyproject.toml`. No Nix overlays or custom Nix packaging.

### uv Templates

See [`uv-templates/README.md`](./uv-templates/README.md) for details.

- **`uv-templates`:** Minimal starting point for Python projects using a simple `pyproject.toml` and the [`uv`](https://docs.astral.sh/uv/) package manager. Designed for fast, reproducible Python environments.

### Package Management

- **Pixi:** Manages system and Python dependencies, supports Conda and PyPI, and integrates with `uv`.
- **uv:** Extremely fast Python package/project manager, ideal for pure Python workflows.
- **nix:** Used only to provide Pixi/uv for Nix users or as a fallback for rare, unsupported packages.

**Summary:**  
For most users, just use Pixi and/or uv. Nix is only needed for advanced use cases or for providing Pixi/uv in a reproducible way.

#### Further reading

- Discussion on `uv` vs `conda` in the [Python Developer Tooling Handbook](https://pydevtools.com/handbook/explanation/why-should-i-choose-conda/#when-conda-may-not-be-ideal-1).
- Discussion on `uv` vs `conda` in the prefix.dev blog [7 Reasons to Switch from Conda to Pixi](https://prefix.dev/blog/pixi_a_fast_conda_alternative)
- Discussion on `pyproject.toml` vs `requirement.txt` in the [Python Developer Tooling Handbook](https://pydevtools.com/handbook/explanation/pyproject-vs-requirements/)
- Guide on writing a [`pyproject.toml`](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/).

---

### Adding New Packages

- **Python packages:**
  - Use `pixi add` or `uv add` as appropriate.
    - For more details on using `uv`, see the [`uv` cookbook](https://docs.astral.sh/uv/getting-started/features/#python-versions).
    - For more details on using `pixi`, see the [`pixi` cookbook](https://pixi.sh/latest/reference/cli/pixi/)
  - Alternatively you can add them directly in the `pyproject.toml`.
- **System/non-Python packages:**
  - `nix` setup:
    - Add via Nix in `flake.nix` if available in [NixOS Search - Packages](https://search.nixos.org/packages).
    - If not available, see [overlays docs](./../overlays/README.md) to define a custom packages.
  - `pixi` setup:
    - [`private channel`](https://prefix.dev/docs/prefix/channels).

## Know How

### Persistent Jupyter Server

To run a persistent Jupyter server in the background:

```bash
nohup .venv/bin/jupyter lab --allow-root --no-browser > error.log & echo $! > pid.txt
```

`nohup` will create a background process with a Jupyter server (you may want to modify where the `jupyter` bin is located). Additionally, errors are redirected to `error.log` and the process ID is saved to `pid.txt`, so you can kill the process if needed:

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

You can also kill the process by running:

```bash
jupyter notebook stop 8888
```

If you do not want `pid.txt` or `error.log` in your directory, you can remove them from the command.

**Alternatively:**
> With Pixi, consider defining a [Pixi task](https://pixi.sh/dev/workspace/advanced_tasks/) for Jupyter.

---

## GPU Acceleration

- **Tested:**  
  All templates have been tested for GPU-accelerated workflows (e.g., PyTorch with CUDA) **on Linux only**.
- **To-Do:**  
  - Test for compatibility and GPU support on:
    - [ ] macOS
    - [ ] NixOS

---

## Documentation & Debugging

- [Pixi Python tutorial](https://pixi.sh/dev/python/tutorial/)
- [uv documentation](https://docs.astral.sh/uv/)
- [PyTorch integration guide for uv](https://docs.astral.sh/uv/guides/integration/pytorch)

---

## References

You may find the following references helpful:

- [`NixOS Wiki Python`](https://nixos.wiki/wiki/Python): Explains the standard approach for using NixOS and Python. Note that not everything applies to our use case since we are on Linux and not NixOS.
- [`uv` docs](https://docs.astral.sh/uv/)
- [`pixi` docs](https://pixi.sh/dev/)
- [7 Reasons to Switch from Conda to Pixi](https://prefix.dev/blog/pixi_a_fast_conda_alternative)

---

*For suggestions or issues, please open an issue or pull request.*
