"""Test integrity of dotfile templates in templates/dotfiles."""

import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DOTFILES_DIR = ROOT / "templates" / "dotfiles"


def test_dotfile_templates_exist():
    expected = [
        "bash_aliases.template",
        "gitconfig.template",
        "ssh_config.template",
        "tmux.conf.template",
        "tmux-sysinfo.sh",
    ]
    for name in expected:
        p = DOTFILES_DIR / name
        assert p.exists(), f"Missing template: {name}"
        assert p.stat().st_size > 0, f"Empty template: {name}"


def test_tmux_template_invariants():
    conf = (DOTFILES_DIR / "tmux.conf.template").read_text(encoding="utf-8")
    assert "__DEFAULT_SHELL__" in conf, "tmux.conf.template missing __DEFAULT_SHELL__ marker"
    assert "status-position top" in conf, "tmux.conf.template missing status-position top"
    assert "sysinfo.sh" in conf, "tmux.conf.template missing sysinfo.sh reference"
    assert "set-clipboard on" in conf, "tmux.conf.template missing OSC 52 clipboard"


def test_tmux_sysinfo_bash_syntax():
    script = DOTFILES_DIR / "tmux-sysinfo.sh"
    res = subprocess.run(["bash", "-n", str(script)], capture_output=True, text=True)
    assert res.returncode == 0, f"Syntax error in tmux-sysinfo.sh: {res.stderr}"
