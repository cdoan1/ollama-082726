# Ollama Git Management Skill

This repository demonstrates how to define a skill that enables an LLM (running via Ollama) to manage Git repositories using the `bash` tool.

## Overview

In this environment, skills are defined using `SKILL.md` files. A skill provides specific instructions to the agent, guiding it on how to use available tools (like `bash`) to accomplish complex tasks.

## Creating a Git Skill

To create a skill for managing Git, you need to create a `SKILL.md` file that instructs the agent on how to interpret git-related requests and which `bash` commands to execute.

### Step 1: Define the Skill Name and Purpose
The `SKILL.md` should start with a clear identification of what the skill is for.

### Step 2: Provide Operational Instructions
The core of the skill is the instruction set. Instead of just "use git", provide specific patterns for common operations.

### Step 3: Example `SKILL.md`
Here is an example of a `SKILL.md` for Git management:

```markdown
# Git Management Skill

This skill empowers the agent to perform Git operations by translating natural language requests into `bash` commands.

## Capabilities

- **Status Check**: When asked about the state of the repository, use `git status`.
- **Staging Changes**: When asked to "stage" or "add" files, use `git add <file_path>`.
- **Committing**: When asked to "commit" changes, use `git commit -m "<message>"`.
- **Branching**: To create or switch branches, use `git checkout -b <branch_name>` or `git checkout <branch_name>`.
- **Logging**: To view history, use `git log --oneline`.

## Safety Guidelines
- Always verify the current branch before performing destructive operations like `git reset`.
- If a command fails, inspect the error output from `bash` and attempt to fix the command or report the issue.
```

## Usage

1. Place the `SKILL.md` file in a directory accessible to the agent.
2. Load the skill using the `skill` tool: `skill(name="git_manager")`.
3. Once loaded, you can simply ask: "Can you show me what has changed in this repo?" or "Commit my current changes with the message 'update readme'".

The agent will then use its knowledge from the skill and the `bash` tool to execute the appropriate Git commands.

## Advanced Skills

### Claude Code Git Skill

This is a high-level skill designed to turn the agent into a specialized Git automation expert. It uses a "Reasoning Loop" where the agent:
1.  Interprets intent via LLM reasoning (Ollama).
2.  Checks repository context via `bash`.
3.  Executes precise commands.
4.  Verifies results.

To use this skill, load it with:
`skill(name="claude_code_git")`
