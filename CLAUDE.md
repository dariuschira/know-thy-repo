# know-thy-repo

A set of Claude Code skills for learning and understanding any git repository.

## Skills

This project provides three user-invocable skills:

- `/explore-thy-repo` — Scans the current repo and saves structured knowledge as memory files (project details, tech stack, architecture). Safe to re-run — it verifies and updates existing knowledge.
- `/learn-thy-repo` — Interactive guided learning session. Pick a track (project, tech stack, or architecture) and learn concepts one by one with real code examples. Calls `/explore-thy-repo` automatically if no knowledge exists.
- `/test-thy-knowledge` — Quiz mode. Configurable question count, format (multiple choice, single choice, text, mixed), and topic focus. Scores on a 0-10 scale per question.

## Knowledge storage

Skills store knowledge in their own isolated directory at `~/.claude/skill-data/know-thy-repo/<encoded-project-path>/`:
- `project.md` — structure, CI/CD, workflows, debugging, config
- `tech-stack.md` — languages, frameworks, libraries, how they're used
- `architecture.md` — design patterns, data flow, key decisions

This keeps knowledge outside the target repo, outside Claude's shared memory system, and fully namespaced to this skill — no interference with other skills or the user's MEMORY.md.

## Development

When modifying skills:
- Keep skill prompts specific and actionable — Claude should know exactly what to do without ambiguity
- Every instruction that reads repo state must use tool calls (Read, Grep, Glob), not assumptions
- Test skills against repos of varying complexity: small single-file projects, monorepos, polyglot stacks
- Knowledge files are plain markdown stored under `~/.claude/skill-data/know-thy-repo/` — they do not use Claude's memory system
