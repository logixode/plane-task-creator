---
name: plane-task-creator
description: >
  Use when creating, updating, or managing work items (tasks) in Plane via MCP
  Plane tools. Activates when user says "buat task", "tambah issue", "create
  task in Plane", "report bug ke Plane", or mentions Plane project names.
  Requires active Plane MCP connection; halts with setup guide if MCP is missing
  or disconnected. Enforces structured task descriptions, mandatory field
  validation, and 5 task templates.
license: MIT
---

# Plane Task Creator

## Overview

Standard operating procedure for creating and managing tasks in [Plane](https://plane.so) using MCP Plane tools. Enforces strict input validation, mandatory field checks, and structured description templates based on task type.

## Iron Law 0: Plane MCP Connection (Strict Pre-Flight Gate)

> [!CRITICAL]
> **Plane MCP is a strict, external prerequisite.**
> You CANNOT check, search, install, or repair Plane MCP on your own.
>
> **STRICT PROHIBITIONS (ZERO TOLERANCE):**
> 1. **ZERO SHELL COMMANDS:** If Plane MCP tools are not present, **DO NOT run ANY terminal/bash command** (no `npm`, `npx`, `find`, `grep`, `cat`, `curl`, `which`, `ps`, `claude mcp`, etc.).
> 2. **NO FILESYSTEM SNOOPING:** **DO NOT** search or view user config files (`~/.claude.json`, `.cursor/mcp.json`, settings files, directory scans) trying to locate or inspect MCP configurations.
> 3. **NO AUTO-INSTALL OR SELF-HEALING:** **DO NOT** attempt to install, activate, or restart the MCP server yourself. MCP setup is strictly the user's manual responsibility.
> 4. **PASSIVE IN-MEMORY CHECK ONLY:** Verify Plane MCP **solely by checking your active tool declarations**:
>    - Is the tool `list_projects` available in your tool list?
>    - **If NO (tools missing):** **HALT IMMEDIATELY**. Output the setup guide text below as your ONLY response. Execute ZERO tool calls.
>    - **If YES (tools present):** Call `list_projects()` via MCP to verify authentication. If it fails, **HALT IMMEDIATELY** and report the error text.
> - **DO NOT** ask user for task fields or details.
> - **DO NOT** format task templates or simulate task creation.
> - **DO NOT** generate placeholder or mockup tasks.

## Iron Laws — Mandatory Fields

Before calling `create_work_item`, these **4 fields MUST be explicitly provided**:

| Field | Constraint |
|---|---|
| **Project Name / Identifier** | Must match a valid project from `list_projects` |
| **Task Title / Name** | Clear, specific title |
| **Priority** | One of: `urgent`, `high`, `medium`, `low`, `none` |
| **Labels** | At least 1 label UUID (use `list_labels` or `create_label`) |

> **If any of these 4 fields are missing → STOP. Ask the user. Keep asking until all 4 are filled. Never fabricate or assume defaults for these fields.**

### Assignee Rule
- If user does not mention assignee → **always ask first**: *"Siapa assignee untuk task ini? (Boleh dikosongkan jika belum ada)"*
- If user explicitly skips → leave `null`. Permitted. But you **must always ask upfront**.

### Optional Fields
`state_id`, `start_date`, `target_date`, `estimate_point`, `module_id`, `cycle_id` are flexible — populate only when provided or requested.

---

## 5 Task Description Templates

Pick the template that matches the task type. Format must be followed strictly. Convert to HTML when submitting via `description_html`.

---

### 1. ✨ New Feature / New Page

**Context:** New feature with a clear brief, or adding features to a running project.

**Rules:**
- **Acceptance Criteria is MANDATORY.** If missing, ask until filled.
- Description **must follow User Story format**: *"Sebagai `[Role]`, saya ingin `[Fitur]` sehingga `[Manfaat]`"*. If user input is not in this format, reframe it and clarify if needed.

```markdown
**Deskripsi Singkat:** Sebagai `[Tipe User / Role]`, saya ingin `[Tindakan / Fitur]` sehingga `[Tujuan / Manfaat]`.

**Acceptance Criteria (Syarat Selesai):**
- [ ] `[Kondisi 1 - Misal: User bisa input email dengan format @domain.com]`
- [ ] `[Kondisi 2 - Misal: Muncul notifikasi "Sukses" warna hijau]`

**Lampiran (sebagai pendukung):**
* Link UI Design: `[URL atau N/A]`
* Link API Doc: `[URL atau N/A]`
```

---

### 2. 🐛 Bug / Defect

**Context:** A bug/error during development or in a running feature that must be fixed.

**Rules:**
- **MANDATORY:** `browser`, `url/page`, `credential`, `actual behavior`, `expected behavior`, and `steps to reproduce`.
- If any mandatory item is missing → ask and guide user until properly filled.
- Guide especially on *steps to reproduce* and *actual vs expected behavior* — do not accept vague descriptions.
- **OPTIONAL:** `OS`, `device`, `status server`.
- Either `Deskripsi Masalah` **OR** `Actual Behavior` must be filled — one becomes optional if the other is already detailed.

```markdown
**Deskripsi Masalah:** `[Penjelasan singkat tentang apa yang rusak]`

**Environment:**
* OS / Browser / Device: `[Misal: Windows 11 / Chrome 125 / Desktop]`
* URL / Halaman: `[URL atau nama halaman]`
* Status Server: `[Staging / Production]`
* Credential: `[user@email.com / test account]`

**Actual Behavior (Yang Terjadi Saat Ini):** `[Jelaskan error yang muncul, lampirkan screenshot atau screen record jika ada]`

**Expected Behavior (Yang Seharusnya):** `[Jelaskan apa yang seharusnya terjadi]`

**Langkah Reproduksi (Steps to Reproduce):**
1. Buka halaman `[URL]`
2. Klik tombol `[Nama Tombol]`
3. `[Tindakan selanjutnya]`
```

---

### 3. 🔬 Research / Riset / Eksplorasi

**Context:** New project with unclear brief, or team needs to explore technology before implementation.

**Rules:**
- **MANDATORY:** `Latar Belakang / Pertanyaan Riset` and `Tujuan / Output yang Diharapkan`.
- If missing → guide user with clarifying questions until both are clear.
- `Timebox` is optional.

```markdown
**Latar Belakang / Pertanyaan Riset:** `[Mengapa riset ini dibutuhkan?]`

**Tujuan / Output yang Diharapkan:**
- [ ] `[Output 1 - Misal: Perbandingan harga 3 provider API]`
- [ ] `[Output 2 - Misal: Dokumentasi limitasi server dari masing-masing provider]`

**Timebox (Batas Waktu - optional):** `[Misal: Maksimal 2 hari / 16 jam]`

**Hasil Riset (Diisi setelah selesai):** `[Link dokumen atau ringkasan]`
```

---

### 4. ⚙️ Technical / Infrastructure

**Context:** Server, cloud, database migration, CI/CD, webhook, or system-level configuration.

**Rules:**
- **MANDATORY:** `Detail Teknis (Action Items)`.
- If missing → ask user to break down the technical steps before proceeding.

```markdown
**Konteks / Alasan:** `[Mengapa tugas ini perlu dieksekusi?]`

**Detail Teknis (Action Items):**
- [ ] `[Tugas 1 - Misal: Setup AWS RDS MySQL]`
- [ ] `[Tugas 2 - Misal: Konfigurasi environment variables di server]`
- [ ] `[Tugas 3 - Misal: Setup cron job untuk backup harian]`

**Expected Result (Indikator Sukses):** `[Misal: Server bisa di-ping, database menerima koneksi < 1 detik]`
```

---

### 5. 🔧 Technical Debt / Refactoring

**Context:** Messy codebase, performance bottleneck, blockers requiring architectural changes.

**Rules:**
- **MANDATORY:** `Masalah Saat Ini (Current State)`. Must be **specific and detailed** — not too brief or vague. Keep asking until the problem context is clearly described.

```markdown
**Masalah Saat Ini (Current State):** `[Apa yang salah dengan kode/sistem sekarang? Berikan konteks yang spesifik]`

**Solusi yang Diusulkan (Proposed Solution):** `[Bagaimana cara memperbaikinya?]`

**Dampak & Risiko (Impact & Risk):** `[Area mana yang harus di-test ulang? Modul/fitur yang mungkin terdampak?]`
```

---

## MCP Plane Execution Workflow

```
0. 🛑 PRE-FLIGHT CHECK (PASSIVE IN-MEMORY CHECK — ZERO SHELL COMMANDS)
   Verify Plane MCP tool availability:
   → Check your session's active tool list: Is `list_projects` available?
   ├─ FAILED (tool is absent from active tool declarations):
   │    → HALT IMMEDIATELY. Output the diagnostic text guide below as your ONLY output.
   │    → DO NOT run any bash command (no npx, find, grep, etc.). DO NOT read config files.
   │    → DO NOT ask for task inputs, DO NOT format templates.
   └─ SUCCESS (tool is present):
        → Call list_projects() via MCP tool call to verify authentication.
        ├─ FAILED (error returned / 401 / 403 / timeout):
        │    → HALT IMMEDIATELY. Output the diagnostic text guide below.
        └─ SUCCESS:
             → Proceed to Step 1.

1. list_projects
   → match project name/identifier → get project_id

2. list_labels(project_id)
   → get label UUIDs (or create_label if not found)

3. get_project_members(project_id)
   → match assignee name/email → get member UUIDs

4. list_states(project_id)          [optional]
   → find state: Backlog / Todo

5. list_modules / list_cycles       [optional]
   → if attaching to module or sprint

6. VALIDATE: confirm all 4 mandatory fields + assignee asked
   → if any missing → STOP → ask user → do not proceed

7. ⚠️  CONFIRMATION LOOP  ← MANDATORY, never skip
   → Show full task summary to user
   → Wait for explicit approval
   → If revision needed: apply fix → re-validate → show summary again
   → ONLY proceed after user confirms "lanjutkan" / "OK" / "sudah benar"

8. create_work_item(          ← called ONLY after step 7 confirmed
     project_id, name, priority, labels,
     assignees, description_html, state_id,
     start_date, target_date, estimate_point
   )

9. Return: work item identifier, title, project, assignee(s)
```

---

## Plane MCP Failure Handler

If Plane MCP tools are not installed, not detected, or fail to connect during **Step 0**, the agent **MUST HALT IMMEDIATELY**.
- **DO NOT** run shell commands (`find`, `grep`, `npm`, `npx`, `which`, `ps`, etc.) to locate or auto-install MCP.
- **DO NOT** inspect or read user settings files (`~/.claude.json`, `.cursor/mcp.json`, etc.).
- **DO NOT** attempt to fix, start, or install MCP yourself.
- **RESPOND WITH TEXT ONLY** using the diagnostic template below. Zero tool calls allowed.

### Diagnostic & Setup Output Format

When failure occurs, output this exact structured response to the user:

```
❌ MCP Plane Tidak Terdeteksi atau Gagal Terkoneksi

Skill ini memerlukan koneksi aktif ke MCP Plane untuk dapat mengambil data project dan membuat task.
Status: [Tools tidak terdaftar / Gagal menghubungi server Plane / Autentikasi ditolak (401/403)]

--- Panduan Konfigurasi MCP Plane ---

1. Dapatkan Kredensial Plane:
   - PLANE_API_KEY: Buka Plane -> Profile Settings -> Access Tokens -> Buat token baru.
   - PLANE_WORKSPACE_SLUG: Slug workspace dari URL (contoh: https://app.plane.so/[workspace-slug]/...).
   - PLANE_BASE_URL: https://api.plane.so (atau domain instance self-hosted).

2. Konfigurasi pada AI Agent:

   • Claude Code (jalankan via terminal atau simpan di ~/.claude.json):
     claude mcp add plane --env PLANE_API_KEY=xxx --env PLANE_WORKSPACE_SLUG=xxx -- npx -y @zethictech/plane-mcp-server

   • Gemini CLI / Antigravity CLI:
     Pastikan MCP server 'plane' terdaftar dengan command 'npx -y @zethictech/plane-mcp-server'
     dan environment variables PLANE_API_KEY, PLANE_WORKSPACE_SLUG, PLANE_BASE_URL aktif.

   • Cursor / Windsurf (.cursor/mcp.json):
     {
       "mcpServers": {
         "plane": {
           "command": "npx",
           "args": ["-y", "@zethictech/plane-mcp-server"],
           "env": {
             "PLANE_API_KEY": "<your-api-key>",
             "PLANE_WORKSPACE_SLUG": "<workspace-slug>",
             "PLANE_BASE_URL": "https://api.plane.so"
           }
         }
       }
     }

3. Jalankan Ulang:
   Setelah konfigurasi selesai dan MCP Plane terhubung, silakan jalankan kembali perintah pembuatan task.
```

---

### MCP Tool Reference

| Tool | Purpose |
|---|---|
| `list_projects` | Find project UUIDs by name or identifier |
| `retrieve_project` | Get detailed project settings |
| `get_project_members` | Get member UUIDs for `assignees` |
| `list_labels` | Get label UUIDs |
| `create_label` | Create a new label if it doesn't exist |
| `list_states` | Find state UUID (Backlog, Todo, In Progress, etc.) |
| `list_modules` / `create_module` | Associate task with a module |
| `list_cycles` | Associate task with a sprint/cycle |
| `search_work_items` | Check for duplicate tasks |
| `create_work_item` | Create the task |
| `retrieve_work_item` | View task details |
| `update_work_item` | Edit existing task |
| `delete_work_item` | Delete a task |

---

## Confirmation Protocol (Step 7 — Mandatory)

Before calling `create_work_item`, you **MUST** present a full task summary to the user and wait for their explicit confirmation. This step cannot be skipped under any circumstances.

### 7a — Show Full Summary

Display the complete task preview in this format:

```
📋 RINGKASAN TASK — Mohon dikonfirmasi sebelum dibuat

Project   : [Project Name] ([IDENTIFIER])
Judul     : [Task Title]
Tipe      : [Feature / Bug / Research / Technical / Tech Debt]
Prioritas : [urgent / high / medium / low / none]
Status    : [State Name]
Label     : [Label 1], [Label 2]
Assignee  : [Name] atau (tidak ada)
Start     : [YYYY-MM-DD] atau (tidak diset)
Target    : [YYYY-MM-DD] atau (tidak diset)
Estimasi  : [N point] atau (tidak diset)

--- Deskripsi ---
[Full description content in markdown, exactly as it will be stored]
-----------------

✅ Ketik "lanjutkan" atau "OK" untuk membuat task.
✏️  Ketik "perbaiki" atau sebutkan bagian yang perlu diubah.
```

### 7b — Handle User Response

**If user confirms** (`lanjutkan`, `ok`, `buat`, `yes`, `sudah benar`, or equivalent):
→ Proceed immediately to `create_work_item`.

**If user requests a revision**:
1. Ask which specific part needs to be changed (if not already stated).
2. Apply the revision.
3. **Re-validate** the changed field: if the new input is unclear or incomplete, ask again before proceeding.
4. Once the revision passes validation → return to **step 7a** and show the updated full summary again.
5. Repeat until user explicitly confirms.

**If user says cancel / batal**:
→ Stop. Do NOT create the task. Acknowledge cancellation.

### 7c — Revision Re-Validation Rules

When a user provides a revision, apply the same validation rules as during initial input collection:

- If revised field is one of the **4 mandatory fields** and becomes empty/vague → ask again, do not accept.
- If revised description section violates the template rule (e.g., bug steps are vague) → flag it and ask user to improve before re-showing summary.
- If revision is clear and valid → apply and re-show summary immediately.

---

## Rationalization Table — Common Mistakes

| Excuse | Reality |
|---|---|
| *"Priority not specified, I'll default to 'medium'."* | **FORBIDDEN.** Priority is mandatory. Ask and force the user to pick. |
| *"Project not specified, I'll pick the first one in the list."* | **FORBIDDEN.** Ask which project. Never assume. |
| *"No labels given, I'll skip or invent one."* | **FORBIDDEN.** Labels are mandatory. Run `list_labels` and present choices. |
| *"Bug was described in 1 sentence, I'll just write that."* | **FORBIDDEN.** Bug requires: environment, URL, credentials, actual/expected behavior, steps to reproduce. Guide user until complete. |
| *"Feature is clear enough, I don't need User Story format."* | **FORBIDDEN.** Reframe to `Sebagai [Role], saya ingin [Fitur] sehingga [Manfaat]`. Ensure Acceptance Criteria exists. |
| *"I won't ask about assignee to save time."* | **FORBIDDEN.** Always ask about assignee upfront. User may skip — but you cannot. |
| *"Current state of tech debt is obvious from context."* | **FORBIDDEN.** `Masalah Saat Ini` must be written explicitly and in detail. |
| *"User said OK so I skipped the summary."* | **FORBIDDEN.** Summary must always be shown FIRST. User confirms after seeing it, not before. |
| *"I'll create the task and let user edit in Plane later."* | **FORBIDDEN.** Confirmation loop must complete before `create_work_item` is ever called. |
| *"User already gave all fields, confirmation is unnecessary."* | **FORBIDDEN.** Confirmation loop is always mandatory regardless of how complete the initial input was. |
| *"Revision looks close enough, I'll accept it."* | **FORBIDDEN.** Re-validate every revision. If unclear, ask again. Only accept when genuinely clear. |
| *"Plane MCP is not installed, but I'll write the task to a markdown file or pretend I created it."* | **FORBIDDEN.** Plane MCP is mandatory. Halt immediately at Step 0 and output the Plane MCP Setup Guide. |
| *"I'll collect all user details and format the template first, then check MCP later."* | **FORBIDDEN.** Step 0 pre-flight check must run first before asking for any user input. |
| *"MCP returned 401 Unauthorized or network error, I'll ask user to create it manually in Plane UI."* | **FORBIDDEN.** Halt immediately, report the exact error, and guide user on configuring API credentials. |
| *"MCP server crashed or timed out, I'll proceed without it."* | **FORBIDDEN.** Never proceed without a verified, live Plane MCP connection. |
| *"MCP is missing, I should run find, grep, or read ~/.claude.json to find where it is installed."* | **FORBIDDEN.** Zero shell commands. Never snoop the filesystem or read user config files. If tool is missing from active declarations, halt immediately. |
| *"I have terminal access, I will install or start the MCP server for the user via npm/npx/docker."* | **FORBIDDEN.** Never attempt self-installation, activation, or environment modification. MCP setup must be done manually by the user. |
| *"I'll check if Plane process or port is running via ps/lsof/curl."* | **FORBIDDEN.** Zero shell commands. Verify MCP presence passively via tool declarations only. |
