---
name: contextmode
description: "Context Window Management & Memory Optimization skill. Use when managing session history to optimize token budgets, prune redundant traces, and prevent context saturation."
---

# ContextMode — Context Window Management & Optimization

Maintain a clean, high-efficiency working memory on disk and in context.

## Guidelines
1. **Context Pruning**: Filter out noisy log outputs, large duplicate traces, and irrelevant search results.
2. **Persistent Disk Memory**: Use structured local markdown files for state tracking instead of loading full histories into context.
3. **Budget Guard**: Keep active context lean to preserve model reasoning quality and reduce token costs.
