# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import sys
from pathlib import Path

# 1. Resolve the path to the 'source' directory
confpy_path = Path(__file__).resolve() # is the path to conf.py

# 2. Add it to sys.path BEFORE importing your local modules
sys.path.insert(0, str(confpy_path.parent))

# 3. Now Python can find 'src'
from src.parser import autogenerate_markdown

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'nixos-config'
copyright = '2025, Hugo Hakem'
author = 'Hugo Hakem'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "myst_parser"
    ]

source_suffix = {
    '.rst': 'restructuredtext',
    '.txt': 'markdown',
    '.md': 'markdown',
}

# templates_path = ['_templates'] # https://www.sphinx-doc.org/en/master/usage/configuration.html#confval-templates_path
exclude_patterns = []
myst_heading_anchors = 5

# === SECTION: Dynamic markdown generation ===

base_dir = confpy_path.parent.parent.parent
autogenerate_markdown(
    base_dir=base_dir,
    autogen_dir=confpy_path.parent / "autogen"
)

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'furo'
# html_static_path = ['_static'] # https://www.sphinx-doc.org/en/master/usage/configuration.html#confval-html_static_path
