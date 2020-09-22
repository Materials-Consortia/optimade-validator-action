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


def optimade_api_version():
    """Print OPTIMADE API version supported in currently installed optimade package as input for shell array"""
    try:
        from optimade import __api_version__
    except ImportError:
        exit("optimade MUST be installed to run 'api-version'")

    versions = [
        __api_version__.split('-')[0].split('+')[0].split('.')[0],
        '.'.join(__api_version__.split('-')[0].split('+')[0].split('.')[:2]),
        '.'.join(__api_version__.split('-')[0].split('+')[0].split('.')[:3]),
    ]
    print(' '.join(versions))


def optimade_package_version():
    """Print optimade package version in currently installed environment as input for shell array"""
    try:
        from optimade import __version__
    except ImportError:
        exit("optimade MUST be installed to run 'package-version'")

    print(__version__.split('-')[0].split('+')[0].replace('.', ' '))


if __name__ == "__main__":
    commands = ["api-versions", "package-version", "results"]

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
    else:
        exit(f"Wrong command, it must be one of {commands}")
