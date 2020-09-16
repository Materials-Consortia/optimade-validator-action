from pathlib import Path
import re
from typing import Tuple

try:
    from invoke import task
except ImportError:
    import sys

    sys.exit("'invoke' MUST be installed to run these tasks.")


TOP_DIR = Path(__file__).parent.resolve()


def update_file(filename: str, sub_line: Tuple[str, str], strip: str = None):
    """Utility function for tasks to read, update, and write files"""
    with open(filename, "r") as handle:
        lines = [
            re.sub(sub_line[0], sub_line[1], line.rstrip(strip)) for line in handle
        ]

    with open(filename, "w") as handle:
        handle.write("\n".join(lines))
        handle.write("\n")


@task(help={"ver": "OPTIMADE Validator Action version to set"})
def setver(_, ver=""):
    """Sets the OPTIMADE Validator Action version"""
    match = re.fullmatch(r"v?([0-9]+\.[0-9]+\.[0-9]+)", ver)
    if not match or (match and len(match.groups()) != 1):
        print(
            "Error: Please specify version as 'Major.Minor.Patch' or 'vMajor.Minor.Patch'"
        )
        sys.exit(1)
    ver = match.group(1)

    major_version = ver.split(".")[0]
    tag_url = "https://github.com/Materials-Consortia/optimade-validator-action/releases/tag/"
    update_file(
        TOP_DIR.joinpath("README.md"),
        (
            fr"`v{major_version}` \| \[`v{major_version}(\.[0-9]+){{2}}.*v{major_version}(\.[0-9]+){{2}}",
            f"`v{major_version}` | [`v{ver}`]({tag_url}v{ver}",
        ),
        strip="\n",
    )

    print(f"Bumped version to {ver}")
