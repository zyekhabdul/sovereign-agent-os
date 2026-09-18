---
name: rtk
description: "Terminal Command Output Proxy & Token Compression skill (RTK). Use when executing verbose CLI commands to strip terminal noise, ANSI codes, and compress tool outputs."
---

# RTK — Runtime Terminal Token Compressor

Compress noisy shell and CLI execution outputs for agent ingestion.

## Guidelines
1. **Noise Reduction**: Strip raw ANSI codes, progress bars, and repeated status lines from terminal output.
2. **Error Isolation**: Extract exact error codes and stack trace lines while collapsing passing output.
3. **Efficient Execution**: Run terminal commands cleanly with cat-friendly pagers and controlled output length.
