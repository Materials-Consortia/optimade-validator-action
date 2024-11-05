"""Helper commands for the action.

These commands are useful to check OPTIMADE Python tools-specific things,
as well as parsing JSON files to stdout.
"""

# pylint: disable=import-outside-toplevel
import argparse
from glob import iglob
import sys


def create_output() -> None:
    """Create single JSON object from found JSON files."""
    import json

    results = {}
    for filename in iglob("*.json"):
        name = filename[: -len(".json")]
        with open(filename, encoding="utf8") as handle:
            try:
                results[name] = json.load(handle)
            except json.JSONDecodeError:
                continue
    print(json.dumps(results, indent=None, separators=(",", ":")))


def delete_files(path: str) -> None:
    """Deletes all files matching the pattern passed in `path`.

    Parameters:
        path: Glob path string.

    """
    import os

    for filename in iglob(path):
        if os.path.isfile(filename):
            os.remove(filename)
        else:
            import warnings

            warnings.warn(
                f"{filename!r} does not seem to be a file, did not remove it."
            )


def optimade_api_version() -> None:
    """Print OPTIMADE API version supported in currently installed optimade package as
    input for shell array."""
    try:
        from optimade import __api_version__
    except ImportError:
        sys.exit("optimade MUST be installed to run 'api-version'")

    split_version = (
        __api_version__.split("-", maxsplit=1)[0].split("+", maxsplit=1)[0].split(".")
    )

    print(
        " ".join(
            [split_version[0], ".".join(split_version[:2]), ".".join(split_version[:3])]
        )
    )


def optimade_package_version() -> None:
    """Print optimade package version in currently installed environment as input for
    shell array."""
    try:
        from optimade import __version__
    except ImportError:
        sys.exit("optimade MUST be installed to run 'package-version'")

    print(__version__.split("-", maxsplit=1)[0].split("+")[0].replace(".", " "))


def remove_trailing_slash(string: str) -> None:
    """Remove trailing slashes."""
    print(string.rstrip("/"))


def assert_leading_slash(string: str) -> None:
    """Assert that a string has a leading slash."""
    if not string.startswith("/"):
        print(f"/{string}")
    else:
        print(string)


if __name__ == "__main__":
    commands = [
        "api-versions",
        "package-version",
        "results",
        "remove-trailing-slash",
        "assert-leading-slash",
    ]

    parser = argparse.ArgumentParser()
    parser.add_argument("cmd", help="Command to run.", type=str, choices=commands)
    args = parser.parse_args()

    if args.cmd == "api-versions":
        optimade_api_version()
    elif args.cmd == "package-version":
        optimade_package_version()
    elif args.cmd == "results":
        create_output()
        delete_files("*.json")
    elif args.cmd == "remove-trailing-slash":
        remove_trailing_slash(sys.argv[2])
    elif args.cmd == "assert-leading-slash":
        assert_leading_slash(sys.argv[2])
    else:
        sys.exit(f"Wrong command, it must be one of {commands}")
