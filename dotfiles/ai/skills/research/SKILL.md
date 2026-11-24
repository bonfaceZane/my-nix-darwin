---
name: research
description: Research a technical or product question using current, high-trust primary sources. Use when the user asks to research, verify, or compare claims and documentation.
---

# Research

Adapted from Matt Pocock's [`research`](https://github.com/mattpocock/skills/blob/main/skills/engineering/research/SKILL.md) skill. Investigate the question against sources that own the facts: official documentation, specifications, source code, and first-party APIs.

## Workflow

1. Define the question and any version, platform, date, or project constraints.
2. Find primary sources first. For version-sensitive libraries or tools, check
   the current documentation for the version the project uses.
3. Verify each important claim against the source that owns it. Separate facts
   from inference, explain conflicts or uncertainty, and cite claims with
   direct links.
4. Give the user a concise answer with the evidence and relevant limitations.
5. Save findings to a Markdown file only when the user asks for a durable
   research artifact or the project has an established research-note workflow.

Use available search and documentation tools directly. Do not delegate research
to another agent by default. Do not treat a search result snippet as sufficient
evidence when the source page can be inspected.
