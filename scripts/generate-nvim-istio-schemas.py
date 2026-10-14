
#!/usr/bin/env python3
"""Generate Neovim JSON schemas from official Istio CRDs."""

import copy
import json
import urllib.request
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / ".config/nvim/schemas/istio"

URL = (
    "https://raw.githubusercontent.com/istio/istio/"
    "master/manifests/charts/base/files/crd-all.gen.yaml"
)

GROUPS = {
    "networking.istio.io",
    "security.istio.io",
    "telemetry.istio.io",
    "extensions.istio.io",
}


def select_version(crd):
    available = [
        version
        for version in crd["spec"].get("versions", [])
        if version.get("served")
        and version.get("schema", {}).get("openAPIV3Schema")
    ]

    if not available:
        return None

    for name in ("v1", "v1beta1", "v1alpha3"):
        for version in available:
            if version["name"] == name:
                return version

    return next(
        (v for v in available if v.get("storage")),
        available[0],
    )


def main():
    print("Downloading official Istio CRDs...")

    with urllib.request.urlopen(URL, timeout=120) as response:
        documents = list(
            yaml.safe_load_all(response.read().decode("utf-8"))
        )

    generated = {}

    for crd in documents:
        if not isinstance(crd, dict):
            continue

        if crd.get("kind") != "CustomResourceDefinition":
            continue

        spec = crd["spec"]
        group = spec["group"]

        if group not in GROUPS:
            continue

        version = select_version(crd)

        if version is None:
            continue

        kind = spec["names"]["kind"]
        schema = copy.deepcopy(
            version["schema"]["openAPIV3Schema"]
        )

        schema["$schema"] = (
            "http://json-schema.org/draft-07/schema#"
        )
        schema["title"] = f"Istio {kind}"
        schema.setdefault("type", "object")

        properties = schema.setdefault("properties", {})
        properties["apiVersion"] = {
            "type": "string",
            "const": f"{group}/{version['name']}",
        }
        properties["kind"] = {
            "type": "string",
            "const": kind,
        }

        generated[f"{kind.lower()}.json"] = schema

    if not generated:
        raise RuntimeError("No Istio schemas found")

    OUTPUT.mkdir(parents=True, exist_ok=True)

    for filename, schema in sorted(generated.items()):
        destination = OUTPUT / filename
        destination.write_text(
            json.dumps(schema, indent=2) + "\n",
            encoding="utf-8",
        )
        print(f"Generated {filename}")

    print(f"\nGenerated {len(generated)} Istio schemas")


if __name__ == "__main__":
    main()

