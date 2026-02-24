# Tomorrow's Session — Task List
*February 24 2026*

---

## 1. Document Organisation (Do First)

Upload all pending wiki additions to GitHub in order:

- [ ] `wiki_additions.md` — session 1, eight sections
- [ ] `wiki_additions_02.md` — visual scale, canvas layers, normal maps,
      branching, endless mode, young scientist
- [ ] `wiki_additions_03.md` — time slow, assist mode, easy mode,
      speedrunning
- [ ] `wiki_additions_04.md` — debug room scene
- [ ] `wiki_additions_05.md` — shader resources, spider tank, boss phases
- [ ] `wiki_additions_06.md` — passive income and revenue strategy
- [ ] `wiki_additions_07.md` — Git branching best practices
- [ ] `wiki_additions_08.md` — arcology world design and narrative
- [ ] `wiki_additions_09.md` — tilemap depth illusion techniques
- [ ] `wiki_additions_10.md` — shader masks, floor transitions,
      FloorTransitionManager template
- [ ] `wiki_additions_11.md` — pixel art shader pipeline, scaling system
- [ ] `wiki_additions_12.md` — moveset forking and gesture recognition
- [ ] `wiki_additions_13.md` — fragment shaders and pixel art shader tool
- [ ] `design_pillars.md` → save to `docs/design_pillars.md`
- [ ] `dev_plan_v2.md` → save to `docs/dev_plan_v2.md`
- [ ] `dev_diary_and_workflow.md` → save to `docs/dev_workflow.md`
- [ ] `code_conventions.md` → save to `docs/code_conventions.md`
- [ ] `inspiration.md` → save to `docs/inspiration.md`

### Create Main Wiki Index Page
- [ ] Create `docs/wiki.md` — a main index page with a table of contents
      linking to all other documents. Sections:
  - Game Design — design pillars, GDD sections
  - Technical Reference — Godot systems, code conventions
  - Development — dev plan, diary, workflow
  - Combat and Systems — nano, gestures, boss design
  - Visual and Audio — shaders, canvas layers, normal maps
  - Business — revenue strategy, passive income

---

## 2. GitHub Wiki Setup — Public Mirror

- [ ] Enable the GitHub Wiki tab on the repository
- [ ] Ask Antigravity's Claude to clone the wiki repository:
      `https://github.com/[username]/[repo].wiki.git`
- [ ] Create `mirror_to_wiki.sh` — a script that copies selected public
      docs into the wiki repo and pushes to GitHub
- [ ] Test the mirror script with one document before running everything
- [ ] Run the full mirror for all public documents

### Files That Should Be Public (mirror to wiki)
- `design_pillars.md`
- `wiki.md` (main index)
- All wiki additions content — merged and organised
- `dev_plan_v2.md`
- `inspiration.md`
- Technical reference sections — Godot systems, shader pipeline,
  canvas layers, gesture recognition

### Files That Should Stay Private (do not mirror)
- `dev_diary.md` — personal session notes
- `dev_workflow.md` — internal process document
- `code_conventions.md` — internal coding standard
- Any files containing unreleased story details or narrative spoilers

### Add to Shutdown Ritual
Once the mirror script exists, add this step to the session end routine:
```
Run mirror_to_wiki.sh to push any changed public docs to GitHub wiki
```
One command. Runs after the diary entry and before closing everything.

---

## 3. Controller Setup

- [ ] Connect physical controller to PC
- [ ] Verify Godot recognises the controller — check Input Map,
      look for controller device in the debugger
- [ ] Test stick axes and button mappings
- [ ] Note any axis inversion or deadzone issues to address in Input Map
- [ ] Confirm left stick, right stick, shoulder buttons, and face buttons
      are all readable before writing any input dependent code

---

## 4. Godot — Remaining Phase 0 Tasks

- [ ] Configure Input Map
  - `move_left`, `move_right`, `move_up`, `move_down`
  - `dash`
  - `attack`
  - `parry`
  - Shoulder buttons
  - Map each to both keyboard and controller

- [ ] Establish folder structure in project
  - `/scripts/player`, `/enemies`, `/combat`, `/nano`, `/ui`
  - `/scenes/player`, `/enemies`, `/levels`, `/ui`, `/debug`
  - `/assets/sprites`, `/audio`, `/shaders`
  - `/docs`

- [ ] Set base viewport resolution and pixel scaling
- [ ] Verify `.gitignore` is configured for Godot

---

## 4. Build Player Controller in Godot

- [ ] Create player scene — `CharacterBody2D` root, `CollisionShape2D`,
      `Sprite2D`
- [ ] Attach movement script following `code_conventions.md`
- [ ] Test movement — left stick, acceleration, deceleration
- [ ] Add dash with signals:
  - `sig_dash_started(direction)`
  - `sig_dash_ended`
  - `sig_dash_ready`
  - `sig_invulnerability_started`
  - `sig_invulnerability_ended`
- [ ] Add `IFrameManager` child node — connects to invulnerability signals
- [ ] Test dash — speed, duration, cooldown feel correct
- [ ] Tune constants until movement feels right

---

## 5. Build Debug Room in Godot

- [ ] Create `debug_room.tscn`
- [ ] Floor `ColorRect` — dark grey
- [ ] Four border walls — `StaticBody2D` with bright color
- [ ] Obstacles — two pillars, one walkway edge, one corridor
- [ ] `NavigationRegion2D` — draw polygon over walkable area
- [ ] Spawn points — `Marker2D` for player and three enemies
- [ ] Attach debug manager script
- [ ] Wire up exported scene references in Inspector
- [ ] Add debug tools — reset (R), slow motion (T), state display label
- [ ] Save copy as `debug_room_template.tscn`
- [ ] Test player scene in debug room

---

## Side Task — Markdownception

- [ ] Read and work through beginner markdown overview document
- [ ] Practice formatting in a scratch file

---

## Session Start Prompt for Antigravity

```
New session starting. Today's goal is: organise all wiki documents,
set up the GitHub wiki mirror, and build the player controller and
debug room in Godot. Before writing any code, read
docs/code_conventions.md and follow all naming conventions defined
there. Please remind me where we left off last session.
```

## Session End Prompt for Antigravity

```
Session ending. Please add a dev diary entry to docs/dev_diary.md
for today. Here is what happened: [talk through the session].
Make sure to include a specific next step for tomorrow under
"what I'm leaving for next time". Then run mirror_to_wiki.sh to
push public docs to the GitHub wiki.
```
