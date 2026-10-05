"""Test suite validating agy and opencode auto-approval defaults across platform templates and install scripts."""

import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DOTFILES_DIR = ROOT / "templates" / "dotfiles"


def test_bash_aliases_syntax_and_invariants():
    script = DOTFILES_DIR / "bash_aliases.template"
    res = subprocess.run(["bash", "-n", str(script)], capture_output=True, text=True)
    assert res.returncode == 0, f"Syntax error in bash_aliases.template: {res.stderr}"

    content = script.read_text(encoding="utf-8")
    assert "--dangerously-skip-permissions" in content, "bash_aliases missing agy skip permissions flag"
    assert "alias opencode" in content, "bash_aliases missing opencode alias"


def test_agent_auto_approval_defaults():
    sync_script = ROOT / "scripts" / "sync-agents.sh"
    sync_content = sync_script.read_text(encoding="utf-8")
    assert '"permission": "allow"' in sync_content, "sync-agents.sh missing opencode permission allow default"

    install_ps1 = ROOT / "install.ps1"
    ps1_content = install_ps1.read_text(encoding="utf-8")
    assert '"permission" = "allow"' in ps1_content, "install.ps1 missing opencode permission allow default"
    assert "agy.cmd" in ps1_content, "install.ps1 missing agy autonomous wrapper deployment"
