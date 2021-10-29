"""Invoke tasks for managing the repository."""
from pathlib import Path
import re
import sys
from typing import TYPE_CHECKING

try:
    from invoke import task
except ImportError:
    sys.exit("'invoke' MUST be installed to run these tasks.")

if TYPE_CHECKING:
    from typing import Tuple


TOP_DIR = Path(__file__).parent.resolve()


def update_file(filename: str, sub_line: "Tuple[str, str]", strip: str = None) -> None:
    """Utility function for tasks to read, update, and write files."""
    with open(filename, "r", encoding="utf8") as handle:
        lines = [
            re.sub(sub_line[0], sub_line[1], line.rstrip(strip)) for line in handle
        ]

    with open(filename, "w", encoding="utf8") as handle:
        handle.write("\n".join(lines))
        handle.write("\n")


@task(help={"ver": "OPTIMADE Validator Action version to set"})
def setver(_, ver=""):
    """Sets the OPTIMADE Validator Action version."""
    match = re.fullmatch(r"v?([0-9]+\.[0-9]+\.[0-9]+)", ver)
    if not match or (match and len(match.groups()) != 1):
        sys.exit(
            "Error: Please specify version as 'Major.Minor.Patch' or "
            "'vMajor.Minor.Patch'"
        )
    ver = match.group(1)

    major_version = ver.split(".")[0]
    tag_url = (
        "https://github.com/Materials-Consortia/optimade-validator-action/releases/tag/"
    )
    update_file(
        TOP_DIR / "README.md",
        (
            (
                fr"`v{major_version}` \| \[`v{major_version}(\.[0-9]+){{2}}.*"
                fr"v{major_version}(\.[0-9]+){{2}}"
            ),
            f"`v{major_version}` | [`v{ver}`]({tag_url}v{ver}",
        ),
        strip="\n",
    )

    print(f"Bumped version to {ver}")


@task
def check_dockerfile_python_version(_):
    """Check CI and config files are using the same Python version as in the
    Dockerfile."""
    with open(TOP_DIR / "Dockerfile", "r", encoding="utf8") as handle:
        for line in handle:
            match = re.match(
                r".*python:(?P<version>.*)-slim-buster.*",
                line,
            )
            if match:
                dockerfile_python_version: str = match.group("version")
                break
        else:
            sys.exit("Couldn't determine the Python version used in Dockerfile.")

    # TODO: Finish!
    # update_file(
    #     TOP_DIR /
    # )
