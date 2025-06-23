# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

from pathlib import Path
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

templates_path = ['_templates']
exclude_patterns = []
myst_heading_anchors = 5

# === SECTION: Dynamic markdown generation ===

confpy_path = Path(__file__).resolve() # is the path to conf.py
base_dir = confpy_path.parent.parent.parent
autogenerate_markdown(
    base_dir=base_dir,
    autogen_dir=confpy_path.parent / "autogen"
)

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'furo'
html_static_path = ['_static']
