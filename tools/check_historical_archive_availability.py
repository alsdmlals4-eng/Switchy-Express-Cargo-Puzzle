"""Classify exact historical archive expiry without treating it as byte verification."""
from __future__ import annotations
import argparse
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
# Only these retired immutable identities may report NOT_RUN instead of blocking
# unrelated current work. Future/current candidates still fail closed on expiry.
RETIRED = {
    ("SX59-POC-ACCEPT-003", 9515705015, "3c871c6ab752492ec706cc3bd81ed4d471d0054f",
     "8b4e630c667b5fd88886878e5a07401c1fe6cfd8f1f9d84b2ab39cb8824923d4"),
    ("SX60-POC-ACCEPT-010", 9766817524, "79323ff0175b674c594d18dfd6d28a8e9951f5bd",
     "e90e735e6f3571e6e10e075759983021bec006d5636f8f292a5437775a2beefc"),
}


def classify(evidence: dict, metadata: dict) -> str:
    try:
        item = evidence["artifact"]
        if (
            type(metadata["id"]) is not int
            or type(metadata["workflow_run"]["id"]) is not int
            or not isinstance(metadata["name"], str)
            or not isinstance(metadata["digest"], str)
        ):
            raise ValueError("Malformed archive identity types")
        expected = (item["id"], item["name"], item["workflow_run_id"],
                    "sha256:" + item["api_digest_sha256"])
        actual = (metadata["id"], metadata["name"], metadata["workflow_run"]["id"],
                  metadata["digest"])
        if actual != expected:
            raise ValueError("Archive metadata identity/digest mismatch")
        if type(metadata["expired"]) is not bool:
            raise ValueError("Archive expired field must be a JSON boolean")
        if not metadata["expired"]:
            return "AVAILABLE"
        identity = (evidence["candidate_id"], item["id"], item["workflow_head_sha"],
                    item["api_digest_sha256"])
        if identity not in RETIRED:
            raise ValueError("Expired archive is not an approved historical identity")
        return "NOT_RUN_EXPIRED_HISTORICAL"
    except (KeyError, TypeError) as exc:
        raise ValueError("Missing or malformed archive metadata/evidence") from exc


def read_local(relative: str) -> dict:
    path = (ROOT / relative).resolve()
    if not path.is_relative_to(ROOT):
        raise ValueError("Archive evidence must stay inside the repository")
    return json.loads(path.read_text(encoding="utf-8"))


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pointer", required=True)
    parser.add_argument("--key", choices=("historical", "post060"), required=True)
    args = parser.parse_args()
    pointer = read_local(args.pointer)
    if pointer.get("candidate_status") in ("NOT_CREATED", "NOT_MINTED"):
        state, identity = "NOT_RUN_UNMINTED", "no package minted"
    else:
        evidence = read_local(pointer["artifact_evidence_owner"])
        if evidence["candidate_id"] != pointer["current_candidate_id"]:
            raise ValueError("Pointer/evidence candidate mismatch")
        artifact_id = evidence["artifact"]["id"]
        endpoint = f"repos/alsdmlals4-eng/Switchy-Express-Cargo-Puzzle/actions/artifacts/{artifact_id}"
        # Query errors, including 404, are errors, never expiry or availability.
        raw = subprocess.check_output(["gh", "api", endpoint], text=True, encoding="utf-8")
        state = classify(evidence, json.loads(raw))
        identity = f"{evidence['candidate_id']} / artifact {artifact_id}"
    message = f"{identity}: {state}; archive bytes have NOT been reverified by this metadata check"
    print(message)
    if os.environ.get("GITHUB_OUTPUT"):
        with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as stream:
            stream.write(f"{args.key}={state}\n")
    if os.environ.get("GITHUB_STEP_SUMMARY"):
        with open(os.environ["GITHUB_STEP_SUMMARY"], "a", encoding="utf-8") as stream:
            stream.write(message + "\n\n")


if __name__ == "__main__":
    main()
