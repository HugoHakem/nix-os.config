from pathlib import Path
import re
import os
from collections import Counter


GITHUB_BASE = "https://github.com/HugoHakem/nix-os.config/blob/main/"


def rewrite_and_clean_markdown(content, md_path, md_to_rst_map, base_dir):
    """
    - Rewrites markdown links based on location
    - Converts <a id="..."></a> to {#...} at the end of the current line
    """
    lines = content.splitlines()
    new_lines = []

    # Regex to match [label](url)
    link_pattern = re.compile(r'\[([^\]]+)\]\(([^)]+)\)')


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
        # Rewrite links
        line = link_pattern.sub(lambda m: rewrite_link(m.group(1), m.group(2)), line)
        new_lines.append(line)

    return "\n".join(new_lines)



def autogenerate_markdown(base_dir, autogen_dir):
    base_dir = Path(base_dir).resolve()
    autogen_dir = Path(autogen_dir).resolve()
    autogen_dir.mkdir(parents=True, exist_ok=True)

    md_files = [
        path for path in sorted(base_dir.rglob("*.md"))
        if not path.is_relative_to(base_dir / ".github")
        and not path.is_relative_to(base_dir / "docs")
        and (not path.is_relative_to(base_dir / "templates") 
             or path.is_relative_to(base_dir / "templates/README.md")
             or path.is_relative_to(base_dir / "templates/deprecated")
             or path.is_relative_to(base_dir / "templates/pythonml/.nix/packages")
             )
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