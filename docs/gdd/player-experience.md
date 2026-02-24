# Player Experience

---

## Design Philosophy

- The dash is a resource shared between combat and navigation — every use is a decision
- Combat skill is rewarded with navigation currency — successful hits refresh the dash
- The single dash constraint matters most between combats, not during them
- The first upgrade doesn't just increase power — it changes the player's relationship with
  the game's core mechanic
- Upgrades should change behaviour and mindset, not just numbers
- Small but meaningful choices — not minor percentage increases
- Allow players to grow their own way — personal identity through upgrade path
- Player can eventually unlock everything and become ultra powered, but early choices shape
  the journey
- Refund freedom ensures players explore freely rather than playing cautiously
- Hard mode barrier is commitment not gatekeeping — everyone can try, few will finish
- The most powerful version of the character never needed the chip — narrative and mechanical
  design aligned
- The normal ending is a commentary on media, power, and narrative control
- The triumphant ending must be earned, not found
- Games are a power fantasy — if the player puts in the work they should be able to
  absolutely wreck rooms
- Earned power is more satisfying than given power — the system rewards mastery with spectacle
- Hand-crafted story, procedural replayability — know which tool serves which goal

---

## Accessibility

### Parry Assist
During charge, auto parry activates — the player does not need to time the parry input
manually while managing the charge. The charge, attack, and parry all still exist in the
game. The player is experiencing the real combat system with one layer of simultaneous
timing removed.

Appropriate for motor accessibility needs — players who struggle with simultaneous inputs
can still experience the full combat loop.

### Easy Mode — Resilience Scaling
Inspired by Hades God Mode. Rather than reducing enemy damage, removing content, or changing
the combat system, the player becomes progressively more resilient each time they fail.

Proposed implementation:
- Resilience starts at a small damage reduction percentage
- Each death increases resilience by a fixed increment
- Resilience caps at a level where the game remains challenging but completable for any
  player willing to persist
- The combat system, enemy behaviour, nano mechanics, and story are completely unchanged

The game is completable for the weak and masterable for the strong. Every player experiences
the full narrative, the full combat system, and the full upgrade progression — just with
different levels of forgiveness.

### Colorblindness Support
A user-definable color wheel with presets. No player should be excluded by a visual design
decision. To be developed.

### Philosophy
Assist mode and easy mode are not the same thing and should not be bundled into a single
switch. They are independent toggles:

- **Parry assist** — removes simultaneous timing requirement, appropriate for motor accessibility
- **Resilience scaling** — adjusts punishment for failure
- **Colorblindness support** — visual accessibility, separate from both

A player might want parry assist for motor reasons but full damage. Another might want
resilience scaling but full timing requirements. Treating them as separate options is more
respectful and more useful than a single easy mode label.

No option should be labelled as lesser. The game respects all kinds of players.

---

## Speedrunning Support

### Timed Mode
A dedicated game state activated by the player that displays run information throughout
the game. Not just a timer overlay — a full parallel UI layer showing:

- **Overall run time** — total elapsed time from run start
- **Split times** — time recorded at narrative checkpoints:
  - End of stage one — the sewers
  - Surgical lab awakening
  - Each boss encounter
  - Final confrontation
- **Challenge checklist** — all items required for the hardest challenge tier:
  - Collectibles saved count
  - Upgrade points status
  - Gauntlet triggered status
  - Any other tier requirements

The checklist serves double duty — a completion tracker for speedrunners and a discovery
tool for first time players who may not know the challenge tiers exist.

### Speedrun Friendly Design Considerations

**Skippable cutscenes** — all cutscenes and story sequences must be skippable from day one.
Build this in early rather than retrofitting later.

**Seeded randomization** — any procedural content in a run uses a seed value so the same
seed produces the same run. Allows runners to compare times meaningfully and enables seed
hunting as its own category.

**Load time boundaries** — clear defined load points between scenes make it easier for the
speedrun community to implement load time removal in their timing tools.

**Consistent critical path** — regardless of randomization or procedural content, the
critical path to completion must always be achievable.

### Randomizer Mode
Shuffles the location of collectibles, upgrades, and enemy placements while keeping the
critical path completable. The nano computer terminal proximity gating system is well suited
to randomizer logic.

Randomizer options under consideration:
- Collectible locations shuffled throughout the game world
- Upgrade node contents randomized — unknown until purchased
- Enemy type randomization within encounter budget limits
- Stage order randomization for full game runs

Randomizer and timed mode naturally combine — randomized timed runs are among the most
popular speedrun categories in games that support both.

### Design Philosophy Note
Speedrun support and accessibility support are philosophically opposite ends of the same
spectrum — one strips away forgiveness, the other adds it. Supporting both explicitly signals
that the game respects all kinds of players. The full range from assisted easy mode to
frameless randomized speedrun is intentional and acknowledged.
