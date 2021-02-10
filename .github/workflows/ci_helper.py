#!/usr/bin/env python3
import argparse
import json
import os


def check_output(expected_keys: list):
    expected_results_keys = ["success_count", "failure_count"]  # not complete list
    results = json.loads(os.getenv("RESULTS"))

    assert len(results) == len(expected_keys), f"results: {results}\n\nexpected_keys: {expected_keys}\n"

    for key in expected_keys:
        assert key in results, f"key: {key}\n\nresults: {results}\n"
        for sub_key in expected_results_keys:
            assert sub_key in results[key], f"sub_key: {sub_key}\n\nresults[key]: {results[key]}\n"


if __name__ == "__main__":
    commands = ["default", "all_versioned_paths", "validate_unversioned_path"]

    parser = argparse.ArgumentParser()
    parser.add_argument("cmd", help="Command to run.", type=str, choices=commands)
    args = parser.parse_args()

    if args.cmd == "default":
        check_output(["v1"])
    elif args.cmd == "all_versioned_paths":
        check_output(["v1", "v1.0", "v1.0.0"])
    elif args.cmd == "validate_unversioned_path":
        check_output(["unversioned", "v1"])
    else:
        exit(f"Wrong command, it must be one of {commands}")
