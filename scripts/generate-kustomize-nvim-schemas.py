
#!/usr/bin/env python3
"""Generate local Kustomize and Component schemas."""

import copy
import json
import urllib.request
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / ".config/nvim/schemas/kustomize"

URL = (
    "https://raw.githubusercontent.com/SchemaStore/"
    "schemastore/master/src/schemas/json/kustomization.json"
)


def main():
    print("Downloading Kustomize schema...")

    with urllib.request.urlopen(URL, timeout=60) as response:
        base = json.load(response)

    OUTPUT.mkdir(parents=True, exist_ok=True)

    resources = {
        "kustomization": {
            "apiVersion": "kustomize.config.k8s.io/v1beta1",
            "kind": "Kustomization",
        },
        "component": {
            "apiVersion": "kustomize.config.k8s.io/v1alpha1",
            "kind": "Component",
        },
    }

    for filename, identity in resources.items():
        schema = copy.deepcopy(base)

        # The original schema uses a root $ref.
        # Wrap it to add resource-specific suggestions.
        schema = {
            "$schema": (
                "http://json-schema.org/draft-07/schema#"
            ),
            "title": f"Kustomize {identity['kind']}",
            "allOf": [
                {
                    "$ref": "#/definitions/Kustomization",
                },
                {
                    "type": "object",
                    "properties": {
                        "apiVersion": {
                            "type": "string",
                            "const": identity["apiVersion"],
                        },
                        "kind": {
                            "type": "string",
                            "const": identity["kind"],
                        },
                    },
                },
            ],
            "definitions": schema.get("definitions", {}),
        }

        destination = OUTPUT / f"{filename}.json"
        destination.write_text(
            json.dumps(schema, indent=2) + "\n",
            encoding="utf-8",
        )

        print(f"Generated {destination.name}")

    print("\nGenerated 2 Kustomize schemas")


if __name__ == "__main__":
    main()

