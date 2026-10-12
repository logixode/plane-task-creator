---
name: plane-task-creator
description: >
  Use when creating, updating, or managing work items (tasks) in Plane via MCP
  Plane tools. Activates when user says "buat task", "tambah issue", "create
  task in Plane", "report bug ke Plane", or mentions Plane project names.
  Enforces structured task descriptions, mandatory field validation, and
  template-based formatting for 5 task types: feature, bug, research,
  technical/infra, and technical debt.
license: MIT
---

# Plane Task Creator

## Overview

Standard operating procedure for creating and managing tasks in [Plane](https://plane.so) using MCP Plane tools. Enforces strict input validation, mandatory field checks, and structured description templates based on task type.

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

7. create_work_item(
     project_id, name, priority, labels,
     assignees, description_html, state_id,
     start_date, target_date, estimate_point
   )

8. Return: work item identifier, title, project, assignee(s)
```

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
