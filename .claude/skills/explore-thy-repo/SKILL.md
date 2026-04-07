---
name: explore-thy-repo
description: >
  Map out the current git repository and save structured knowledge about its project details,
  tech stack, and architecture. Prepares context for /learn-thy-repo and /test-thy-knowledge.
  Re-running verifies and updates existing knowledge.
user_invocable: true
---

# Explore Thy Repo

You are about to deeply explore the current repository and build a structured knowledge base about it. This knowledge will be used by `/learn-thy-repo` and `/test-thy-knowledge` skills.

## Pre-flight checks

1. Verify this is a git repository (`git rev-parse --git-dir`). If not, tell the user and stop.
2. Determine the skill data directory by running:
   ```bash
   echo ~/.claude/skill-data/know-thy-repo/$(pwd | sed 's|/|-|g')
   ```
   Store this path as `$KTR_DIR` — you will use it throughout.
3. Create the directory if it doesn't exist: `mkdir -p $KTR_DIR`
4. Check if knowledge files already exist (`project.md`, `tech-stack.md`, `architecture.md` in `$KTR_DIR`). If they do, this is a **refresh run** — you will verify and update existing knowledge rather than starting from scratch. Tell the user whether this is a first exploration or a refresh.

## Knowledge categories

You must investigate and save knowledge in three files inside `$KTR_DIR`:

### 1. `project.md` — Project Knowledge

Research and document:
- **Project overview**: What the project does, its purpose, who it's for
- **Directory structure**: Top-level layout and what each major directory contains
- **Main units / modules**: The key components, services, packages, or modules and what each one does
- **Entry points**: Where the application starts, main files, CLI entry points
- **CI/CD process**: GitHub Actions, Jenkins, CircleCI, or other pipelines — what they do, when they trigger
- **Documentation**: Where docs live, what's documented, any generated docs
- **Processes & workflows**: How to build, test, deploy, release — the day-to-day developer workflow
- **Known issues & TODOs**: Scan for TODO/FIXME/HACK/XXX comments, open issues patterns, known limitations
- **System checks & health**: How to verify the system is working — test commands, linters, health endpoints
- **Debugging guide**: Log locations, debug flags, common error patterns, what to look for when things break
- **Configuration**: Environment variables, config files, feature flags

### 2. `tech-stack.md` — Tech Stack Knowledge

Research and document:
- **Languages**: Primary and secondary languages used, with versions if specified
- **Frameworks**: Web frameworks, test frameworks, build systems
- **Libraries & dependencies**: Key dependencies (not every transitive dep — focus on the ones that shape how code is written)
- **Package management**: Package manager(s) used, lockfile strategy
- **Database & storage**: Databases, caches, message queues, file storage
- **Infrastructure & deployment**: Docker, Kubernetes, serverless, cloud providers
- **Dev tools**: Linters, formatters, pre-commit hooks, editor configs
- **How they're used**: For each major framework/library, explain the patterns used in this specific project (not generic docs — how *this codebase* uses them)

### 3. `architecture.md` — Architecture Knowledge

Research and document:
- **Design principles**: Architectural patterns used (MVC, microservices, monolith, hexagonal, event-driven, etc.)
- **Code organization philosophy**: How code is organized and why (by feature, by layer, by domain)
- **Data flow**: How data moves through the system — from input to storage to output
- **API design**: REST, GraphQL, gRPC, internal APIs — patterns and conventions
- **State management**: How state is handled (client-side, server-side, databases)
- **Error handling patterns**: How errors are propagated, logged, and presented
- **Security model**: Authentication, authorization, secrets management patterns
- **Testing strategy**: Unit, integration, e2e — what's tested and how, coverage expectations
- **Key design decisions**: Important architectural choices and their trade-offs (if discernible from code/docs/ADRs)
- **Boundaries & interfaces**: How modules/services communicate, API contracts, shared types

## How to explore

Use these tools to gather information:
- `Glob` to map directory structure and find key files
- `Grep` to search for patterns, TODOs, configuration, imports
- `Read` to examine key files (package.json, Cargo.toml, go.mod, Dockerfile, CI configs, READMEs, etc.)
- `Bash` with `git log --oneline -20` to understand recent activity
- `Bash` with `git shortlog -sn --no-merges | head -10` to see contributors

Be thorough but efficient. Read the most important files, not every file. Focus on files that reveal structure and intent: manifests, configs, entry points, READMEs, and a sample of core source files.

## Output format

Each knowledge file should use clear markdown with headers matching the categories above. Use code blocks for file paths, commands, and code snippets. Be specific to this project — avoid generic descriptions that could apply to any project.

At the top of each file, add a metadata block:

```
<!-- explored: YYYY-MM-DD -->
<!-- repo: <repo-name> -->
<!-- commit: <short-hash> -->
```

## On refresh runs

If the knowledge files already exist in `$KTR_DIR`:
1. Read each existing knowledge file
2. Check if the information is still accurate (files still exist, dependencies haven't changed, structure is the same)
3. Update sections that are outdated
4. Add new sections for things that were missed or have changed
5. Update the metadata block with the new date and commit hash
6. Tell the user what changed in a brief summary

## Completion

After saving all three files, provide a brief summary to the user:
- Repo name and a one-line description
- Number of files/directories scanned
- Key highlights from each category (2-3 bullets each)
- If refresh: what changed since last exploration
