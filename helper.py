#!/usr/bin/env python3
import argparse
from glob import iglob


def create_output():
    """Create single JSON object from found JSON files"""
    import json

    results = {}
    for filename in iglob("*.json"):
        name = filename[:-len(".json")]
        with open(filename) as handle:
            try:
                results[name] = json.load(handle)
            except json.JSONDecodeError:
                continue
    print(json.dumps(results))


def delete_files(path):
    """Delete files"""
    import os

    for filename in iglob(path):
        os.remove(filename)


if __name__ == "__main__":
    commands = ["api-versions", "package-version", "results"]

    parser = argparse.ArgumentParser()
    parser.add_argument("cmd", help="Command to run.", type=str, choices=commands)
    args = parser.parse_args()

    if args.cmd == "api-versions":
        pass
    elif args.cmd == "package-version":
        pass
    elif args.cmd == "results":
        create_output()
        delete_files("*.json")
    else:
        exit(f"Wrong command, it must be one of {commands}")
