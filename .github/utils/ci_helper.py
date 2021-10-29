#!/usr/bin/env python3
import argparse
import json
import os


def check_output(expected_keys: list):
    expected_results_keys = ["success_count", "failure_count"]  # not complete list
    results = json.loads(os.getenv("RESULTS"))

    assert len(results) == len(
        expected_keys
    ), f"results: {results}\n\nexpected_keys: {expected_keys}\n"

    for key in expected_keys:
        assert key in results, f"key: {key}\n\nresults: {results}\n"
        for sub_key in expected_results_keys:
            assert (
                sub_key in results[key]
            ), f"sub_key: {sub_key}\n\nresults[key]: {results[key]}\n"


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
        "all_versioned_paths": ["v1", "v1.1", "v1.1.0"],
        "validate_unversioned_path": ["unversioned", "v1"],
        "as_type": ["astype"],
    }

    try:
        check_output(cmd_output_mapping[args.cmd])
    except Exception as exc:
        exit(f"An exception occurred while running check_output:\n{exc!r}")
    else:
        exit(0)
