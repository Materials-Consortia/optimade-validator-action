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
    from typing import Optional, Tuple, Union


TOP_DIR = Path(__file__).parent.resolve()


def update_file(
    filename: "Union[Path, str]",
    sub_line: "Tuple[str, str]",
    strip: "Optional[str]" = None,
) -> None:
    """Utility function for tasks to read, update, and write files."""
    if isinstance(filename, str):
        filename = Path(filename)

    if not filename.exists():
        raise FileNotFoundError(f"Could not find file to be updated: {filename}")

    lines = [
        re.sub(sub_line[0], sub_line[1], line.rstrip(strip))
        for line in filename.read_text(encoding="utf8").splitlines()
    ]

    filename.write_text("\n".join(lines) + "\n", encoding="utf8")


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
                rf"`v{major_version}` \| \[`v{major_version}(\.[0-9]+){{2}}.*"
                rf"v{major_version}(\.[0-9]+){{2}}"
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
    with (TOP_DIR / "Dockerfile").open() as handle:
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

    update_file(
        TOP_DIR / ".github" / "workflows" / "ci_tests.yml",
        (
            r"PYTHON_VERSION: 3\.[0-9]+.*",
            f"PYTHON_VERSION: {dockerfile_python_version}",
        ),
    )
    update_file(
        TOP_DIR / "pyproject.toml",
        (
            r"python_version = \".*\"",
            f"python_version = \"{'.'.join(dockerfile_python_version.split('.')[:2])}\"",
        ),
    )

    print(
        "Successfully updated CI and config files to use Python "
        f"{dockerfile_python_version}"
    )
