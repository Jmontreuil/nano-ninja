# Development Workflow

---

## Git Branching — Best Practices

### The Core Mental Model
Main is not where you work. Main is where finished work lives. Think of main as a published
document and branches as drafts. Never edit the published version while still figuring out
what you want to say.

---

### Checking Your Current Branch
Always check which branch you're on before touching anything at session start:

```
git branch
```

Lists all branches with an asterisk next to the current one. Make this the first action of
every session.

---

### Working on Main by Accident — Recovery

**Uncommitted work on the wrong branch — use stash:**

```
git stash
git checkout -b correct-branch-name
git stash pop
```

**Already committed to the wrong branch:**
`git cherry-pick` can copy specific commits from one branch to another. More advanced —
ask Antigravity to walk through it when needed rather than memorising the commands now.

---

### Branching Habits Worth Building

**Branch before you write a single line of code** — not after you've started. The sequence
is: decide what you're working on, create the branch, then open the relevant files.

**Pull before you branch** — always start a new branch from the latest version of main:

```
git checkout main
git pull origin main
git checkout -b new-branch-name
```

**Name branches descriptively:**

```
feature/player-dash
feature/spider-tank-legs
fix/enemy-spawn-bug
experiment/camera-zoom-combat
```

Names like `test-branch-2` become meaningless within a week.

---

### Managing Branches Over Time

**Delete merged branches** — once a branch has been merged its job is done:

```
git branch -d branch-name
```

Use `-D` to force delete an unmerged branch — be certain before doing this.

**Audit stale branches periodically** — a branch untouched for two weeks signals something.
Either the idea was abandoned or it's blocking progress.

---

### Merge Conflicts
A conflict occurs when the same line was changed in two places and Git doesn't know which
version to keep. Git marks conflicts clearly in the file and asks you to choose. Minimise
conflicts by merging or pulling from main into long-running feature branches regularly —
small merges are much easier than large ones.

---

### Protecting Main
GitHub's branch protection setting prevents pushing directly to main without a pull request.
For a solo developer this acts as a safety net.

Enable in GitHub: Repository Settings → Branches → Add branch protection rule → require
pull request before merging.

---

### Commit Message Conventions

**Standard prefixes:**
- `feat:` — new feature
- `fix:` — bug fix
- `chore:` — maintenance (folder structure, configs, etc.)
- `docs:` — documentation changes

**For work in progress:**

```
git commit -m "dash system — movement working, signals not yet connected"
git commit -m "WIP: shader controller — stopped mid _ready() setup"
```

---

### Session Rhythm

**Commit locally during the session** — every time something meaningful works, commit
immediately. Free checkpoints to roll back to if something breaks later.

**Push once at session end** — sends all of the session's commits to GitHub together. One
push captures the full session history.

```
Feature works     →  commit locally immediately
Something breaks  →  roll back to last commit
Session ends      →  push everything, write diary entry
```

---

### Branch Structure As the Project Grows

```
main              →  stable, always working
dev               →  integration branch, features merge here first
feature/[name]    →  specific features in development
fix/[name]        →  bug fixes
experiment/[name] →  risky ideas that might be thrown away
```

The `dev` branch acts as a buffer — features merge into dev first, dev gets tested, then
dev merges into main. Optional overhead early on but valuable once multiple systems interact.

---

### Rebase — Note for Later
Rebasing rewrites branch history to appear as if it was always built on top of main,
producing a cleaner linear history than merge commits. More advanced workflow — revisit once
basic branching habits are solid.
