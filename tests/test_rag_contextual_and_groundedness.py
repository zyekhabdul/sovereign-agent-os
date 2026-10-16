"""Test suite validating Contextual Enrichment (Anthropic Pattern) and Self-RAG Groundedness Audit in agy-guard."""

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
AGY_GUARD = ROOT / "bin" / "agy-guard"


def test_agy_guard_compilation():
    res = subprocess.run([sys.executable, "-m", "py_compile", str(AGY_GUARD)], capture_output=True, text=True)
    assert res.returncode == 0, f"Compilation failed: {res.stderr}"


def test_groundedness_cli_help():
    res = subprocess.run([sys.executable, str(AGY_GUARD), "groundedness", "--help"], capture_output=True, text=True)
    assert res.returncode == 0
    assert "invariants" in res.stdout.lower()
    assert "decisions" in res.stdout.lower()


def test_checkpoint_cli_help_flags():
    res = subprocess.run([sys.executable, str(AGY_GUARD), "checkpoint", "--help"], capture_output=True, text=True)
    assert res.returncode == 0
    assert "--strict" in res.stdout
    assert "--skip-groundedness" in res.stdout


def test_groundedness_execution_on_self():
    res = subprocess.run([sys.executable, str(AGY_GUARD), "groundedness"], cwd=str(ROOT), capture_output=True, text=True)
    assert res.returncode == 0
    assert "SELF-RAG GROUNDEDNESS AUDIT" in res.stdout
    assert "Boundary Confinement" in res.stdout
    assert "Persona Integrity" in res.stdout
