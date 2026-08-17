---
name: headroom
description: "Tool Output Trimming & Context Compression skill. Collapses long terminal logs, tool payloads, and RAG chunks before model ingestion to save context headroom."
---

# Headroom — Tool Output Trimming & Context Compression

Optimize input context headroom by compressing verbose tool execution outputs.

## Guidelines
1. **Log Trimming**: Summarize long build/test outputs and stack traces to highlight root causes.
2. **Payload Compaction**: Filter out redundant JSON metadata and duplicate log lines.
3. **Headroom Preservation**: Ensure critical model context is reserved for active reasoning rather than raw tool noise.
