# ARCHITECTURAL DECISIONS (ADR) — {{PROJECT_NAME}}
> **Navigation**: [[00-AGY-Memory/{{PROJECT_NAMESPACE}}/INDEX.md|PROJECT_INDEX]]

## ADR-001: [ACTIVE] Project Architecture Initialization
- **Date**: {{DATE}}
- **Status**: [ACTIVE]
- **Context**: Project namespace memory initialized.
- **Decision**: Adhere to 4-file memory schema and strict namespace isolation.

---

## Standard Invariant Laws
- **Law 1**: Ponytail / YAGNI - Minimalist code generation, zero unsolicited refactoring.
- **Law 2**: Empirical Verification - Always verify build/test (exit code 0) before concluding task.
- **Law 3**: Git Push Guard - Remote push forbidden without explicit human command.
- **Law 4**: Sliding Packet Window - Maximum 10 chunks in active execution packet.
