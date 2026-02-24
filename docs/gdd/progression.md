# Progression, Challenge Tiers, and Endless Mode

---

## Upgrade System

### Overview
All upgrades are delivered via the chip implant using the finite collectible resource. The
player can eventually unlock everything and become fully powered. Early choices are meaningful
and identity-defining but never permanent — refund stations allow free respeccing at any time.

Upgrades should change behaviour and mindset, not just numbers. Small but meaningful choices,
not minor percentage increases.

### Refund Stations
Located at designated points in the environment. Free to use. Exist so players never feel
locked into choices, never feel locked out of the hard mode challenge, and always feel free
to experiment.

### Upgrade Paths

**Movement and Dodge**
- Base: single dash
- First upgrade: cooldown reset and multiple dashes — changes the player's relationship with
  the entire game
- Further upgrades to be developed
- Completing the game with a single dash is an intended challenge

**Damage and Knockback**
- Upgrades for juggling and armor breaking
- Knockback as a combat tool for repositioning enemies and extending combos
- Further upgrades to be developed

**Nano Effects**
See [combat.md](combat.md) for the full nano system.

---

## Progression and Stages

### The Collectible Resource
A finite item found throughout the game. Spending it unlocks chip upgrades. Saving all of
it instead unlocks a secret final boss. The player faces this choice from the moment the
resource is introduced in Stage 2.

### Stage 1 — The Sewers
Teaches basic combat, the core movement loop, and the dash as a resource. No upgrades.
The player learns the game in its most constrained form. Ends with capture.

### Stage 2 — The Surgical Lab
The player awakens with the chip implanted. The stage teaches each upgrade path by giving
the player the first node of each before the stage ends — double dash, knockback, and nano
respectively. The collectible resource is introduced here. The player immediately faces the
choice of spending or saving.

Navigation to nano computer terminals gates further story and upgrade access. The environment
is a mechanical obstacle as well as an aesthetic one.

### Nano Computer Terminals
Your chip communicates with the facility's nano AI infrastructure. Physical proximity to
terminals gates story progression and upgrade access. The chip's range does not expand —
you navigate to the terminals, not the other way around. Exploration is mechanical
progression, not just aesthetic.

### Later Stages
To be developed.

---

## Challenge Tiers and Hard Mode

### The Four Tiers

**Tier 1 — Normal Run**
Spend your upgrades. Enjoy the power fantasy. See the bittersweet exile ending. The intended
experience for most players.

**Tier 2 — Secret Boss Run**
Hoard all collectibles. Spend nothing. Face the final boss underpowered but not stripped bare.
Tests patience and resource discipline over the entire game. Unlocks the secret final boss.

**Tier 3 — Gauntlet Run**
Voluntarily forfeit all upgrade points. Single dash. No upgrades. The game locks into
gauntlet state — irreversible for that run. Tests pure mechanical mastery. Unlocks the mech
boss and the true hero ending.

The parry is the hard mode lifeline. Skill-based defense replaces upgrade-based offense.
The nano system still functions, building slowly through successful parries. The challenge is
meaningful because the cost is real.

**Tier 4 — The Hidden Layer**
Save every collectible AND forfeit all upgrades simultaneously. The game recognises total
commitment. Unlocks something nobody will find by accident. To be developed.

The barrier to entry for all challenge tiers is commitment and courage, not hidden knowledge
or grinding. Everyone can attempt them. Few will finish.

### Hard Mode Design Notes
- The single dash constraint matters most in the spaces between combat — navigation,
  positioning, choosing when to engage
- A skilled player who stays in the combat loop effectively never runs out of dash because
  they keep refreshing it on successful hits
- The parry gives a skill-based defensive option that doesn't cost the dash — hard mode is
  active and skillful, not just cautious rationing
- The nano burst from parry chains gives the hard mode player occasional moments of genuine
  power — cultivated and earned

---

## Hard Mode — Gauntlet Trigger and Environmental Design

### The Overcharge Trigger
Activating hard mode is framed in-universe as overcharging the matter replication system.
The player isn't simply forfeiting their upgrades — they are weaponising the corporation's
own infrastructure against itself. The building becomes hostile to everyone, including the
player. This gives the mechanical sacrifice narrative weight.

### The Environmental Gauntlet
With the matter replication system overloaded, the building itself becomes the gauntlet.
Matter projections destabilise unpredictably, environmental hazards activate, and the
structure begins coming apart. The final mech fight takes place on top of the ruined building
and includes a significant environmental challenge component — the arena itself is dangerous,
not just the mech.

### CEO Mech Progression
Rather than the gauntlet being a single brutal sprint, it is a structured narrative journey.
The CEO starts in a basic suit — relatively vulnerable. Each challenge completed in the
gauntlet feeds the in-game narrative of the suit being developed around him in real time.

Each completed challenge adds a new phase to the final fight:
- Complete no challenges — the final boss is manageable
- Complete some challenges — the fight escalates
- Complete all challenges — face the fully realised mech, the hardest possible version

**Thematic note:** The harder you push through the gauntlet, the more formidable you make
your final opponent. Your own excellence arms your enemy.

### Opt-Out Options

- **Point of no return warning** — a clear confirmation screen before the overcharge locks in
- **Surrender with cost** — players can exit via pause menu at any time, but doing so
  permanently costs upgrade points for that run
- **Physical in-world exit** — an in-universe emergency terminal somewhere in the gauntlet
  that stabilises the system and ends the run. Quitting requires navigating to it under pressure
- **Natural off-ramps** — stabilisation zones between gauntlet sections where the player can
  choose to continue or stand down

Preferred direction: options 3 and 4 are most consistent with the design philosophy. The
barrier is commitment, and even the exit should require something from the player.

---

## Endless and Tower Mode

### Framing
In-universe: a combat simulator in the lab. The player is not a guest — they are an escaped
captive exploiting their captors' own infrastructure. Every session is an act of defiance.

### Modes

**Stage Select**
Player chooses which environment or enemy composition to run. Curated options with distinct challenges.

**Random Mode**
Procedurally selected stages and enemy combinations. Maximum replayability.

**Endless Mode**
The full power fantasy destination. A fully upgraded player can wreck rooms indefinitely as
a reward for mastery. This is where the upgrade system pays off completely.

**Tower Mode**
Structured escalating challenge for players who want meaningful progression within the mode
rather than pure endless play.

### Procedural Modifier System
Each run draws a random set of modifiers that change the rules. Examples:
- No parry available
- Nano effects spread twice as fast
- Double dash from the start
- Nano meter starts full

Modifiers are simple to implement but dramatically change how each run feels. They create
variety without requiring new content and give experienced players a constantly shifting challenge.

---

## Procedural Generation

### Design Principle
Procedural generation is a tool, not a goal. Hand-crafted story, procedural replayability.
Know which serves which purpose.

### Where Procedural Generation Is Used
- **Endless and tower mode** — hand-crafted components assembled procedurally. Designed pieces,
  dynamic arrangement. Feels designed rather than random
- **Enemy group composition** — encounter budgets define room difficulty, specific enemies
  selected from a pool. Fresh on replays without disrupting designed experience
- **Nano combinations in endless mode** — each run seeds different active nano types or
  starting upgrade nodes. Forces adaptation
- **Procedural modifiers** — random run conditions in endless and tower mode

### Where Procedural Generation Is Not Used
- **Main story stages** — entirely hand-crafted. Narrative pacing and environmental
  storytelling require authorial control
- **Boss fights** — authored experiences with specific rhythms and meanings. Never randomised
