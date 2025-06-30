# uv-templates

This template provides a minimal starting point for Python projects using a simple `pyproject.toml` and the [`uv`](https://docs.astral.sh/uv/) package manager. It is designed to help you quickly set up a reproducible Python environment with modern dependency management.

## Purpose

- **Minimal Example:** Offers a straightforward `pyproject.toml` for Python projects.
- **uv Integration:** Uses `uv` for fast dependency resolution and environment management.
- **GPU Acceleration:** The template has been tested for GPU-accelerated workflows (e.g., PyTorch with CUDA) **on Linux only**.

## Status

- **Tested:** Linux (with GPU acceleration)
- **To-Do**
  - Test for compatibility and GPU support on:
    - [ ] macOS
    - [ ] NixOS

## Usage

1. Copy this template into your project directory.
2. Edit the `pyproject.toml` to specify your dependencies.
3. Use `uv` to manage your environment and install packages.

## Debugging

If you encounter issues, especially with GPU libraries like PyTorch, please refer to the official [PyTorch integration guide for uv](https://docs.astral.sh/uv/guides/integration/pytorch).

---

*For improvements or issues, please open an issue or pull request.*
