# plane-task-creator

> AI agent skill for creating structured tasks in [Plane](https://plane.so) via MCP Plane tools.

Compatible with: **Claude Code** · **Gemini CLI** · **Cursor** · **Windsurf** · **GitHub Copilot** · **IBM watsonx** · any agent supporting the [Agent Skills](https://agentskills.io) standard.

---

## Installation

### Universal — Skills CLI (recommended)

Works with any agent:

```bash
npx skills add logixode/plane-task-creator
```

Pick your agent with `--agent`, install without prompts with `--skill '*'`, or install globally with `--global`:

```bash
# Install globally (for your user, not just project)
npx skills add logixode/plane-task-creator --global

# Install for a specific agent
npx skills add logixode/plane-task-creator --agent cursor

# Install all skills without prompts
npx skills add logixode/plane-task-creator --skill '*'
```

---

### Gemini CLI / AGY

```bash
gemini extensions install github.com/logixode/plane-task-creator
```

### Claude Code

```
/plugin marketplace add logixode/plane-task-creator
/plugin install plane-task-creator@plane-task-creator
```

---

## What It Does

When you say *"buat task"*, *"tambah issue"*, *"create task in Plane"*, or describe a bug/feature/research topic, this skill guides your AI agent to:

- Identify the correct Plane project via MCP `list_projects`
- Enforce **4 mandatory fields**: project, title, priority, labels
- Always ask about **assignees** upfront
- Apply the correct **structured description template** based on task type
- Show a **full task summary** for confirmation before creating
- Only call `create_work_item` after explicit user confirmation

### 5 Task Templates

| # | Type | Key Required Fields |
|---|---|---|
| 1 | ✨ New Feature / Page | User Story format + Acceptance Criteria |
| 2 | 🐛 Bug / Defect | Environment, URL, credentials, actual/expected behavior, steps to reproduce |
| 3 | 🔬 Research / Riset | Background/question + expected outputs |
| 4 | ⚙️ Technical / Infrastructure | Action items breakdown |
| 5 | 🔧 Technical Debt / Refactoring | Detailed current problem description |

---

## Requirements

- Plane MCP server configured in your AI agent (use [@zethictech/plane-mcp-server](https://github.com/ZethicTech/plane-mcp-server/))
- Plane workspace with API access

---

## Update

```bash
npx skills update logixode/plane-task-creator
```

Or per agent:

```bash
# Gemini CLI
gemini extensions update plane-task-creator

# Claude Code
/plugin update plane-task-creator
```

---

## Uninstall

```bash
npx skills remove plane-task-creator
```

---

## License

MIT
