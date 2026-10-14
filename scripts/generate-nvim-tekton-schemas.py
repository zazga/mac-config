
#!/usr/bin/env python3
"""Generate local Tekton JSON schemas from official CRD releases."""

import copy
import json
import sys
import urllib.request
from pathlib import Path

import yaml


REPO_ROOT = Path(__file__).resolve().parent.parent
OUTPUT_DIR = REPO_ROOT / ".config/nvim/schemas/tekton"

SOURCES = {
    "pipeline": (
        "https://infra.tekton.dev/tekton-releases/"
        "pipeline/latest/release.yaml"
    ),
    "triggers": (
        "https://infra.tekton.dev/tekton-releases/"
        "triggers/latest/release.yaml"
    ),
}

TEKTON_GROUPS = {
    "tekton.dev",
    "triggers.tekton.dev",
}


def download_documents(url):
    print(f"Downloading {url}")

    request = urllib.request.Request(
        url,
        headers={"User-Agent": "mac-config-tekton-schema-generator"},
    )

    with urllib.request.urlopen(request, timeout=120) as response:
        content = response.read().decode("utf-8")

    return yaml.safe_load_all(content)


def select_version(crd):
    versions = crd["spec"].get("versions", [])

    available = [
        version
        for version in versions
        if version.get("served")
        and version.get("schema", {}).get("openAPIV3Schema")
    ]

    if not available:
        return None

    # Prefer Tekton v1 where the CRD supports it.
    return next(
        (version for version in available if version["name"] == "v1"),
        next(
            (version for version in available if version.get("storage")),
            available[0],
        ),
    )


def generate():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    generated = {}

    for source, url in SOURCES.items():
        for document in download_documents(url):
            if not isinstance(document, dict):
                continue

            if document.get("kind") != "CustomResourceDefinition":
                continue

            crd = document
            spec = crd.get("spec", {})
            group = spec.get("group")

            if group not in TEKTON_GROUPS:
                continue

            version = select_version(crd)

            if version is None:
                continue

            kind = spec["names"]["kind"]
            api_version = f"{group}/{version['name']}"

            schema = copy.deepcopy(
                version["schema"]["openAPIV3Schema"]
            )

            # Add resource identity suggestions.
            schema.setdefault("type", "object")
            properties = schema.setdefault("properties", {})

            properties["apiVersion"] = {
                "type": "string",
                "const": api_version,
                "description": "Tekton API version",
            }

            properties["kind"] = {
                "type": "string",
                "const": kind,
                "description": "Tekton resource kind",
            }

            # Hint for editors supporting JSON Schema.
            schema["$schema"] = (
                "http://json-schema.org/draft-07/schema#"
            )
            schema["title"] = f"Tekton {kind}"

            filename = f"{kind.lower()}.json"

            generated[filename] = schema

            print(
                f"  {source}: {kind} "
                f"({api_version}) -> {filename}"
            )

    if not generated:
        raise RuntimeError(
            "No Tekton CRD schemas found in release files"
        )

    # Write all generated schemas before removing stale files.
    for filename, schema in sorted(generated.items()):
        destination = OUTPUT_DIR / filename

        destination.write_text(
            json.dumps(schema, indent=2, ensure_ascii=False)
            + "\n",
            encoding="utf-8",
        )

    for old_file in OUTPUT_DIR.glob("*.json"):
        if old_file.name not in generated:
            old_file.unlink()
            print(f"Removed outdated schema: {old_file.name}")

    print(
        f"\nGenerated {len(generated)} schemas "
        f"in {OUTPUT_DIR}"
    )


if __name__ == "__main__":
    try:
        generate()
    except Exception as error:
        print(f"Error: {error}", file=sys.stderr)
        sys.exit(1)

