# plane-task-creator

> AI agent skill for creating structured tasks in [Plane](https://plane.so) via MCP Plane tools.

Compatible with: **Claude Code** · **Gemini CLI (AGY)** · **Cursor** · **Windsurf** · any agent supporting `~/.agents/skills/`

---

## What It Does

When you say *"buat task"*, *"tambah issue"*, *"create task in Plane"*, or describe a bug/feature/research topic, this skill guides your AI agent to:

- Identify the correct Plane project via `list_projects`
- Enforce **4 mandatory fields**: project, title, priority, labels
- Always ask about **assignees** before creating
- Apply the correct **structured description template** based on task type
- Call `create_work_item` via MCP Plane with validated, well-formatted data

### 5 Task Templates

| # | Type | Required Fields |
|---|---|---|
| 1 | ✨ New Feature / New Page | User Story format + Acceptance Criteria |
| 2 | 🐛 Bug / Defect | Environment, URL, credentials, actual/expected behavior, steps to reproduce |
| 3 | 🔬 Research / Riset | Background/question + expected outputs |
| 4 | ⚙️ Technical / Infrastructure | Action items breakdown |
| 5 | 🔧 Technical Debt / Refactoring | Detailed current problem description |

---

## Requirements

- Plane MCP server configured in your AI agent (see [plane-mcp](https://github.com/makeplane/plane-mcp) or your runtime's MCP docs)
- Plane workspace with API access

---

## Installation

### Option A — One-line install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/plane-task-creator/main/install.sh | bash
```

### Option B — Manual clone

```bash
git clone https://github.com/YOUR_USERNAME/plane-task-creator.git ~/.agents/skills/plane-task-creator
```

### Option C — Git subtree (monorepo)

```bash
git subtree add --prefix=skills/plane-task-creator \
  https://github.com/YOUR_USERNAME/plane-task-creator.git main --squash
```

---

## Update

```bash
~/.agents/skills/plane-task-creator/update.sh
```

Or manually:

```bash
cd ~/.agents/skills/plane-task-creator && git pull origin main
```

---

## Uninstall

```bash
rm -rf ~/.agents/skills/plane-task-creator
```

---

## Runtime Compatibility

| Runtime | Skills Path | Status |
|---|---|---|
| Claude Code | `~/.claude/skills/` or `~/.agents/skills/` | ✅ |
| Gemini CLI (AGY) | `~/.agents/skills/` | ✅ |
| Cursor (Agent mode) | `~/.agents/skills/` | ✅ |
| Windsurf | `~/.agents/skills/` | ✅ |
| Codex / Copilot CLI | `~/.agents/skills/` | ✅ |

`~/.agents/skills/` is a **cross-runtime standard alias** recognized by all major AI coding agents.

---

## Contributing

1. Fork this repo
2. Edit `SKILL.md`
3. Open a PR — changes go live for all users on next `update.sh`

---

## License

MIT
