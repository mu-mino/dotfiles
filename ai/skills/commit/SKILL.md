---
name: commit
description: Create a git commit after completing a user task. Use this skill when the user asks to commit, says "commit it", "jetzt committen", "commit the changes", or after finishing a coding task when a commit is appropriate.
version: 1.0.0
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git commit:*), Bash(git rebase:*)
---

# Commit Skill

Creates a git commit following the user's personal commit message style.

## Commit Message Style

The user follows **Conventional Commits** with these conventions:

### Format
```
type(scope): description
```
or (no scope):
```
type: description
```

### Types
Only use these types (no others like `chore`, `docs`, `style`, `refactor`):
- `feat` — new functionality
- `fix` — bug fix or correction
- `perf` — performance improvement
- `init` — initial setup or bootstrapping
- `checkpoint` — intermediate save point (use rarely, only when explicitly requested)

### Rules
- **scope**: lowercase module/component name in parentheses — omit if the change spans multiple modules
- **description**: lowercase, concise, imperative present tense (no capital letter, no full stop at end unless the user's recent commits have one)
- **body**: add `-` bullet points when there are multiple distinct changes to describe
- **Reason:** line: add only if there is a clear, non-obvious motivation to explain
- **No** `Co-Authored-By` line

### Examples from this repo
```
feat(whisper): provide TranscriptSegment.end + 1sec. for context-tolerance
fix(semanticmatch): match sub-windows against next group, enforce guard, add correction hints
fix(auto_range_runner): wait for process, then finish cleanly
perf(auto_range_runner): async function await if 13 parallel processes are running to preserve CPU.
Reason: Never more than 13 threads in Python GIL.
feat: added auto_range_runner to start several parallel proccesses for batch runs
```

## Strategie: 1 Commit = 1 Problem

**Neue kleine Commits vermeiden.** Wenn eine Änderung zu einem Problem gehört, das bereits committed wurde, wird sie rückwirkend dort eingebaut — nicht als neuer Commit angehängt.

### Entscheidungsbaum

1. **Gehört die Änderung zum letzten Commit?**
   → `git add . && git commit --amend --no-edit`

2. **Gehört die Änderung zu einem Commit 2–3 Stellen zurück** (max. 3)?
   → `git add . && git rebase HEAD~N --autosquash` mit `fixup!`-Commit
   → Nur wenn: kleine Fix-Änderung, Problem noch in Entwicklung, **keine** strukturellen Änderungen

3. **Ist es ein eigenständiges neues Problem?**
   → Neuer Commit mit korrektem `type(scope): description`

### Was als "klein" gilt (Amend/Fixup erlaubt)
- Tippfehler, fehlende Imports, vergessene Rückgabewerte
- Off-by-one Korrekturen, Variablenumbenennung
- Kleinere Logikfixes die zum selben Bug gehören

### Was **nicht** geamended wird
- Strukturelle Änderungen (neue Module, geänderte Architektur)
- Änderungen die mehr als 3 Commits zurückliegen
- Änderungen die ein abgeschlossenes, bereits funktionierendes Problem betreffen

## Workflow

1. `git status` + `git diff HEAD` — was hat sich geändert?
2. `git log --oneline -5` — zu welchem bestehenden Commit gehört das?
3. Entscheidung: Amend / Fixup-Rebase / neuer Commit (siehe oben)
4. Ausführen — ohne nachträgliche Zusammenfassung

Do not summarize what you did afterward — the diff speaks for itself.
