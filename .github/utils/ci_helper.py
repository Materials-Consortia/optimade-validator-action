"""Helper script for CI.

This script takes in four different commands:

- default
- all_versioned_paths
- validate_unversioned_path
- as_type

Each of these maps onto what the expected output from a CI job may be.
"""

import argparse
import json
import os
import sys
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from typing import List


def check_output(expected_keys: "List[str]") -> None:
    """Check CI job output.

    Parameters:
        expected_keys: List of expected keys present in CI output.
            These are hard-coded below in the `cmd_output_mapping` variable.

    """
    expected_results_keys = ["success_count", "failure_count"]  # not complete list
    results = json.loads(os.getenv("RESULTS", ""))

    if len(results) != len(expected_keys):
        raise AssertionError(
            "Number of results keys not equal to expected number of keys:\n  results: "
            f"{results}\n  expected_keys: {expected_keys}\n"
        )

    for key in expected_keys:
        if key not in results:
            raise AssertionError(
                f"Key {key!r} not found in results:\n  results: {results}\n"
            )
        for sub_key in expected_results_keys:
            if sub_key not in results[key]:
                raise AssertionError(
                    f"Key {sub_key!r} not found in results value for key {key!r}:\n  "
                    f"results[{key}]: {results[key]}\n"
                )


if __name__ == "__main__":
    commands = [
        "default",
        "all_versioned_paths",
        "validate_unversioned_path",
        "as_type",
    ]

    parser = argparse.ArgumentParser()
    parser.add_argument("cmd", help="Command to run.", type=str, choices=commands)
    args = parser.parse_args()

    cmd_output_mapping = {
        "default": ["v1"],
        "all_versioned_paths": ["v1", "v1.2", "v1.2.0"],
        "validate_unversioned_path": ["unversioned", "v1"],
        "as_type": ["astype"],
    }

    try:
        check_output(cmd_output_mapping[args.cmd])
    except Exception as exc:  # pylint: disable=broad-except
        sys.exit(f"An exception occurred while running check_output:\n  {exc!r}")
    else:
        sys.exit(0)
