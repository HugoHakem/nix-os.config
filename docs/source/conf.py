# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import os
from pathlib import Path
from collections import Counter
import re

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

GITHUB_BASE = "https://github.com/HugoHakem/nix-os.config/blob/hh-docs/"

def rewrite_and_clean_markdown(content, md_path, md_to_rst_map, base_dir):
    """
    - Rewrites markdown links based on location
    - Converts <a id="..."></a> to {#...} at the end of the current line
    """
    lines = content.splitlines()
    new_lines = []

    # Regex to match [label](url)
    link_pattern = re.compile(r'\[([^\]]+)\]\(([^)]+)\)')

    # Regex to match <a id="some-id"></a>
    anchor_inline_pattern = re.compile(r'<a\s+id="([^"]+)"\s*>\s*</a>')

    def rewrite_link(label, url):
        if url.startswith(("http://", "https://", "mailto:", "#", "/")) or url.endswith(".html"):
            return f"[{label}]({url})"

        target_path = (md_path.parent / url).resolve()

        # Internal markdown file
        if target_path in md_to_rst_map:
            return f"[{label}]({md_to_rst_map[target_path]})"

        # External (non-md) file → GitHub
        try:
            rel_path = target_path.relative_to(base_dir)
        except ValueError:
            rel_path = url  # fallback
        github_url = GITHUB_BASE + str(rel_path).replace(os.sep, "/")
        return f"[{label}]({github_url})"

    for line in lines:
        # Inline anchor: append to end of line
        if '<a id="' in line:
            line = anchor_inline_pattern.sub(lambda m: f"{{#{m.group(1)}}}", line)

        # Rewrite links
        line = link_pattern.sub(lambda m: rewrite_link(m.group(1), m.group(2)), line)
        new_lines.append(line)

    return "\n".join(new_lines)



def generate_include_wrappers(base_dir, autogen_dir):
    base_dir = Path(base_dir).resolve()
    autogen_dir = Path(autogen_dir).resolve()
    autogen_dir.mkdir(parents=True, exist_ok=True)

    md_files = [
        path for path in sorted(base_dir.rglob("*.md"))
        if not path.is_relative_to(base_dir / ".github")
        and not path.is_relative_to(base_dir / "docs")
        and (not path.is_relative_to(base_dir / "templates") or path.is_relative_to(base_dir / "templates/README.md"))
    ]

    occurance_filename = Counter([md_path.stem for md_path in md_files])
    md_to_rst_map = {}

    # First pass: compute mapping
    for md_path in md_files:
        if occurance_filename[md_path.stem] > 1:
            rst_name = "-".join(
                part for part in list(md_path.parts[-2:]) if part not in ["..", "."]
            )
        else:
            rst_name = md_path.stem + ".md"

        md_to_rst_map[md_path.resolve()] = rst_name

    # Second pass: rewrite and write content
    for md_path in md_files:
        rst_name = md_to_rst_map[md_path.resolve()]
        rst_path = autogen_dir / rst_name

        with open(md_path, "r") as f:
            content = f.read()

        rewritten = rewrite_and_clean_markdown(content, md_path, md_to_rst_map, base_dir=base_dir)

        with open(rst_path, "w") as f:
            f.write("<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->\n")
            f.write("<!-- markdownlint-disable MD041 MD047 MD059 -->\n\n")
            f.write(rewritten)


confpy_path = Path(__file__).resolve() # is the path to conf.py
base_dir = confpy_path.parent.parent.parent
generate_include_wrappers(
    base_dir=base_dir,
    autogen_dir=confpy_path.parent / "autogen"
)


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'furo'
html_static_path = ['_static']
