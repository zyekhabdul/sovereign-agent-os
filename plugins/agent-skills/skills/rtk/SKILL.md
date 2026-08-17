---
name: rtk
description: "Terminal Command Output Proxy & Token Compression skill (RTK). Intercepts and filters noisy bash command outputs to save up to 90% of input tokens."
---

# RTK — Runtime Terminal Token Compressor

Compress noisy shell and CLI execution outputs for agent ingestion.

## Guidelines
1. **Noise Reduction**: Strip raw ANSI codes, progress bars, and repeated status lines from terminal output.
2. **Error Isolation**: Extract exact error codes and stack trace lines while collapsing passing output.
3. **Efficient Execution**: Run terminal commands cleanly with cat-friendly pagers and controlled output length.
