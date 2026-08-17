---
trigger: always_on
description: Mandatory Global Rule - Allow local git commit, STRICTLY PROHIBIT automatic git push without explicit user command
---

# MANDATORY GLOBAL RULE: GIT PUSH PERMISSION CONTROL

1. **GIT COMMIT (ALLOWED)**:
   - Antigravity CLI (`agy`) IS ALLOWED to run `git commit` on local repositories to save progress and create incremental checkpoints.

2. **GIT PUSH (STRICTLY PROHIBITED WITHOUT EXPLICIT USER COMMAND)**:
   - Antigravity CLI (`agy`) MUST NEVER execute `git push` to remote repositories (origin, main, master, etc.) automatically.
   - `git push` IS ONLY PERMITTED when the USER explicitly types or instructs a push command in chat (e.g., "push", "push ke main", "push repositori").
