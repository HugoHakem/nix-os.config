# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import os
from pathlib import Path
from collections import Counter

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

# === SECTION: Dynamic TOC ===

def generate_include_wrappers(base_dir, autogen_dir):
    base_dir = Path(base_dir)
    autogen_dir = Path(autogen_dir)
    autogen_dir.mkdir(parents=True, exist_ok=True)

    md_files = [
        path for path in sorted(base_dir.rglob("*.md"))
        if not path.is_relative_to(base_dir / ".github")
        and not path.is_relative_to(base_dir / "docs")
        and (not path.is_relative_to(base_dir / "templates") or path.is_relative_to(base_dir / "templates/README.md"))
    ]

    included_files = []
    occurance_filename = Counter([md_path.stem for md_path in md_files])

    for md_path in md_files:
        rel_path = Path(os.path.relpath(md_path, autogen_dir))
        if occurance_filename[md_path.stem] > 1:
            rst_name = "-".join(
                part for part in list(md_path.parts[-2:]) if part not in ["..", "."]
            )#.replace(".md",".rst")
        else:
            rst_name = md_path.stem + ".md"
        rst_path = autogen_dir / rst_name
        included_files.append(rst_name)

        with open(rst_path, "w") as f:
            f.write("<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->\n")
            f.write("<!-- markdownlint-disable MD041 -->\n\n")
            f.write(f"```{{include}} {rel_path}\n:relative-docs: .\n```\n")

confpy_path = Path(__file__).resolve() # is the path to conf.py
generate_include_wrappers(
    base_dir=confpy_path.parent.parent.parent, # get source then docs then root
    autogen_dir=confpy_path.parent / "autogen"
)

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'furo'
html_static_path = ['_static']
