# plane-task-creator

> AI agent skill for creating structured tasks in [Plane](https://plane.so) via MCP Plane tools.

Compatible with: **Gemini CLI** · **Claude Code** · **Cursor** · **Windsurf** · any agent supporting `~/.agents/skills/`

---

## Installation

### Gemini CLI / AGY
```bash
gemini extensions install github.com/YOUR_USERNAME/plane
```

### Claude Code
```
/plugin marketplace add YOUR_USERNAME/plane
/plugin install plane-task-creator@plane-task-creator
```

### Cursor / Windsurf / other agents
```bash
git clone https://github.com/YOUR_USERNAME/plane.git ~/.agents/skills/plane-task-creator \
  --filter=blob:none --sparse
cd ~/.agents/skills/plane-task-creator
git sparse-checkout set skills/task-creator
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

- Plane MCP server configured in your AI agent
- Plane workspace with API access

---

## Update

### Gemini CLI
```bash
gemini extensions update plane-task-creator
```

### Claude Code
```
/plugin update plane-task-creator
```

---

## Uninstall

### Gemini CLI
```bash
gemini extensions remove plane-task-creator
```

### Claude Code
```
/plugin remove plane-task-creator
```

---

## License

MIT
