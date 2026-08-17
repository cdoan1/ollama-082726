# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a documentation repository that demonstrates how to create skills for LLM agents (specifically those running via Ollama) to manage Git repositories using the `bash` tool.

## Repository Structure

The repository is minimal and documentation-focused:
- **README.md**: Contains the complete documentation, including an example `SKILL.md` template for Git management

## Key Concepts

This repository documents the pattern of creating `SKILL.md` files that:
1. Define specific capabilities for an LLM agent
2. Provide operational instructions for translating natural language requests into bash commands
3. Include safety guidelines for destructive operations

The example focuses on Git operations (status checks, staging, committing, branching, logging) but the pattern applies to any bash-based task automation.

## Notes

- This is a demonstration/educational repository, not an active software project
- There is no build process, testing infrastructure, or deployment pipeline
- Changes will typically be documentation updates to README.md
