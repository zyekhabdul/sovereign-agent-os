"""Hard gate: thiwin reference config must not carry literal secrets.

Every secret-typed field in provisioning/thiwin/opencode.windows.json must be
an env reference (${VAR}) or empty. Real values live only in the encrypted
vault / per-machine bundle, never in git. Asserts key paths only, never values.
"""
import json
import re
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent
TARGET = BASE / "provisioning" / "thiwin" / "opencode.windows.json"
SECRET_KEY = re.compile(r"TOKEN|SECRET|PASSWORD|PASSWD|API_KEY|ACCESS_KEY|PRIVATE", re.I)


def _secret_fields(o, path=""):
    if isinstance(o, dict):
        for k, v in o.items():
            yield from _secret_fields(v, f"{path}.{k}")
    elif isinstance(o, list):
        for v in o:
            yield from _secret_fields(v, path)
    elif isinstance(o, str) and SECRET_KEY.search(path):
        yield path, o


def test_no_literal_secrets_in_thiwin_config():
    assert TARGET.exists(), f"{TARGET} must exist"
    data = json.loads(TARGET.read_text(encoding="utf-8"))
    bad = sorted(p for p, v in _secret_fields(data) if v and not v.startswith("$"))
    assert not bad, f"literal secrets in git (paths only): {bad}"


def test_config_is_valid_json_with_mcp_section():
    data = json.loads(TARGET.read_text(encoding="utf-8"))
    assert "mcp" in data and isinstance(data["mcp"], dict)
