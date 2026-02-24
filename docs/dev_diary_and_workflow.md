# Developer Diary and Daily Workflow

---

## Dev Diary Template

Location: `docs/dev_diary.md`
Method: Append a new entry at the bottom after each session.
Antigravity's Claude maintains this file — tell it to add a diary entry
at the end of each session using the template below.

---

### Entry Format

```
## [Date] — [One line session summary]

### What I worked on
A brief description of the main task or tasks attempted in this session.
Does not need to be exhaustive — the headline is enough.

### What I learned
The most important thing that clicked today. Could be technical, design
related, or about the development process itself. One thing is enough.

### What surprised me
Something unexpected — a problem that was harder than anticipated, a
solution that was simpler than expected, a design idea that came from
nowhere, or something that didn't work the way it should have.

### Decisions made
Any design or technical decisions that were committed to in this session.
These are the choices worth remembering — things that would be confusing
to encounter later without context.

### What I'm leaving for next time
The specific next step waiting at the start of the next session. Written
as an instruction to future self — concrete and actionable, not vague.
Example: "Open debug_room.tscn and connect the enemy spawn signals to
the AttackCycleManager — we stopped just before this step."

### Energy and mood
An honest one or two sentence check in. Was this session frustrating,
satisfying, scattered, focused? The emotional arc of development is
worth capturing. This is what makes the diary worth reading later.

### Session length
Approximate time spent.
```

---

### Example Entry

```
## February 23 2026 — First pass on debug room scene structure

### What I worked on
Built the debug room scene skeleton — floor, borders, spawn points,
and the debug manager script. Got the player instancing working via
exported variables in the Inspector.

### What I learned
The @export annotation is much more powerful than I expected. Being
able to swap what scene is being tested directly in the Inspector
without touching code is going to save a lot of time.

### What surprised me
The NavigationRegion2D polygon has to be drawn manually — I assumed
it could be generated automatically from the collision shapes. More
work than expected but straightforward once I understood it.

### Decisions made
Decided to use Marker2D nodes for spawn points rather than hardcoding
positions in the script. Keeps the scene flexible and the code clean.

### What I'm leaving for next time
Add the slow motion toggle and reset button to the debug manager script.
The functions are stubbed out — just need the input actions registered
in the Input Map and the logic written. Should be a quick start.

### Energy and mood
Good session. Satisfying to see the room take shape. Slightly frustrated
by the navigation region setup but got there in the end.

### Session length
Approximately two hours.
```

---

## Daily Workflow — Starting and Ending a Development Day

### The Problem This Solves
The biggest killer of development momentum is sitting down and not knowing
where to start. The second biggest is stopping mid-thought and losing the
thread. A consistent start and end ritual solves both by making the
transition into and out of work deliberate rather than accidental.

---

### Starting a Session — The Warmup Ritual

**Step 1 — Read yesterday's next step first**
Before opening anything else, read the "what I'm leaving for next time"
entry from the previous session. This is the instruction you left for
yourself. Start there, not somewhere new.

**Step 2 — Read the last few diary entries**
Two or three minutes of context. What has been happening, what decisions
were made, what the current momentum is. Prevents sessions that feel
disconnected from what came before.

**Step 3 — Define one primary goal for the session**
Not a list. One thing. The session is a success if that one thing is
done. Write it at the top of a scratch note or tell Antigravity's Claude
at the start of the session. Having it stated makes it real.

**Step 4 — Check the branch**
Confirm you are on the right Git branch before writing a single line of
code. A quick `git branch` in the terminal shows the current branch.
Starting work on the wrong branch is a common and avoidable frustration.

**Step 5 — Open only what you need**
Resist the temptation to open everything at once. Open the specific scene
or script relevant to the session goal. Other files can wait.

---

### Ending a Session — The Shutdown Ritual

**Step 1 — Stop at a natural boundary, not mid-thought**
Aim to finish a discrete unit of work before stopping — a function
complete, a feature working, a test passing. Stopping mid-thought makes
the next session harder. If time runs out before a natural boundary,
leave a detailed comment in the code explaining exactly where you are:

```gdscript
# STOPPED HERE — signal connected but _on_hit_confirmed not yet written
# Next step: write the function body and test with debug print
```

**Step 2 — Commit what works**
Before anything else, commit the session's work to Git. Even incomplete
work should be committed if it is stable. Use a descriptive message:
"debug room — spawn points and manager script, reset button TODO"
Never leave uncommitted work overnight.

**Step 3 — Write the diary entry**
Tell Antigravity's Claude to add a diary entry for the session. Talk
through what happened conversationally — Claude formats and appends it.
Five minutes of conversation produces a complete entry. Be specific about
the next step — this is the most important part of the entry.

**Step 4 — Write tomorrow's first action**
Separate from the diary, write one concrete sentence on paper, a sticky
note, or a pinned note in Antigravity:

"Tomorrow: [specific action]"

Having it physically present when you sit down tomorrow means you start
immediately rather than spending the first twenty minutes remembering
where you were.

**Step 5 — Close everything deliberately**
Close Godot, close Antigravity, close the project. A clean shutdown
makes the next open feel like a fresh start rather than a continuation
of a previous unresolved state.

---

### Antigravity's Claude — Session Start Prompt

At the start of each session, paste or say this to Antigravity's Claude:

```
New session starting. Today's goal is: [one sentence goal].
Please read the last entry in docs/dev_diary.md and remind me
where we left off and what the next step was.
```

### Antigravity's Claude — Session End Prompt

At the end of each session, paste or say this to Antigravity's Claude:

```
Session ending. Please add a dev diary entry to docs/dev_diary.md
for today. Here is what happened: [talk through the session].
Make sure to include a specific next step for tomorrow under
"what I'm leaving for next time".
```

---

### Sustaining the Habit

**Lower the bar on bad days** — a three sentence entry is better than
no entry. On days where energy is low, the minimum viable diary entry is:
what I worked on, and what I'm leaving for next time. Everything else
is optional.

**Never skip the next step note** — even if the diary entry gets skipped,
always write tomorrow's first action. This single habit has the highest
return on investment of anything in this system.

**Review the diary monthly** — once a month ask Antigravity's Claude to
summarize the last month of diary entries. Patterns emerge — recurring
frustrations, skills that keep coming up, areas where momentum is
strongest. This is also the raw material for devlog content.

**Protect the start ritual** — the warmup ritual is more important than
the shutdown ritual. A session that starts well tends to end well. A
session that starts scattered tends to stay scattered. Spend the first
five minutes on the ritual even when it feels like a waste of time.
