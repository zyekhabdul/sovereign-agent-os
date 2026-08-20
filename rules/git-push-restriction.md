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

3. **MANDATORY SSH PROTOCOL (ZERO HTTPS FOR GIT REMOTES)**:
   - All AI agents MUST use SSH URLs (`git@gitlab.com:...`, `git@codeberg.org:...`, `git@github.com:...`, `git@gitea.com:...`, `git@bitbucket.org:...`) instead of HTTPS URLs when cloning, adding remotes, or managing repositories.
   - HTTPS remote URLs are strictly forbidden for repository operations.

4. **MANDATORY PRE-MUTATION GIT PULL (PULL SEBELUM MEROMBAK)**:
   - Sebelum merombak, refactor, atau memodifikasi file pada repositori project manapun, AI agent **WAJIB** menjalankan `git pull` terlebih dahulu untuk memastikan working tree lokal sinkron dengan commit remote terbaru.
   - Mencegah konflik merge (*merge conflicts*), regresi kode, atau menimpa perubahan yang sudah ada di remote.


