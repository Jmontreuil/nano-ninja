# Wiki Additions — Session February 23 2026 (Part 2)

---

## Combat — Time Slow on Charge

### Concept
Time slows slightly when the player charges an attack, allowing a brief
window to aim. The slow is intentionally subtle at base level — a feeling
of weight and commitment rather than a mechanical pause to plan.

### Base Level
Time scale approximately 0.85x — barely perceptible. Registers as the
attack feeling deliberate and heavy rather than giving the player a
meaningful planning window. The charge feels like a consequence, not
a safety net.

### Upgrade Scaling
Further upgrades in the dash and agility path lengthen the time slow
duration and add damage boosts to compensate for the increased exposure.
The trade is explicit — you slow the world longer but you hit harder.
This ties the time slow to the power fantasy progression already designed.

Early game: subliminal, almost imperceptible
Late game with full upgrades: dramatic and intentional, earned through
progression

### Design Constraints
- The player cannot parry while charging — forces a genuine choice between
  committing to the attack or staying defensive. You cannot have both.
- The time slow is not a catch your breath moment — pacing and duration
  must be tuned to prevent it feeling like a pause button
- The slow should feel like weight and commitment, not control

---

## Accessibility — Assist Mode and Easy Mode

### Parry Assist
During charge, auto parry activates — the player does not need to time
the parry input manually while managing the charge. The charge, attack,
and parry all still exist in the game. The player is experiencing the
real combat system with one layer of simultaneous timing removed.

This is appropriate for motor accessibility needs — players who struggle
with simultaneous inputs can still experience the full combat loop.

### Easy Mode — Resilience Scaling
Inspired by Hades God Mode. Rather than reducing enemy damage, removing
content, or changing the combat system, the player becomes progressively
more resilient each time they fail.

Proposed implementation:
- Resilience starts at a small damage reduction percentage
- Each death increases resilience by a fixed increment
- Resilience caps at a level where the game remains challenging but
  completable for any player willing to persist
- The combat system, enemy behaviour, nano mechanics, and story are
  completely unchanged

The game is completable for the weak and masterable for the strong.
Every player experiences the full narrative, the full combat system,
and the full upgrade progression — just with different levels of
forgiveness.

### Philosophy
Assist mode and easy mode are not the same thing and should not be
bundled into a single switch. They are independent toggles:

- **Parry assist** — removes simultaneous timing requirement, appropriate
  for motor accessibility
- **Resilience scaling** — adjusts punishment for failure, appropriate
  for players who want to complete the game without mastering every system
- **Colorblindness support** — visual accessibility, separate from both

A player might want parry assist for motor reasons but full damage.
Another might want resilience scaling but full timing requirements.
Treating them as separate options is more respectful and more useful
than a single easy mode label.

No option should be labelled as lesser. The game respects all kinds
of players. This is stated explicitly as a design value alongside the
hard mode and speedrun support — the full spectrum of player experience
is acknowledged and supported.

---

## Speedrunning Support

### Timed Mode
A dedicated game state activated by the player that displays run
information throughout the game. Not just a timer overlay — a full
parallel UI layer showing:

- **Overall run time** — total elapsed time from run start
- **Split times** — time recorded at narrative checkpoints:
  - End of stage one — the sewers
  - Surgical lab awakening
  - Each boss encounter
  - Final confrontation
- **Challenge checklist** — all items required for the hardest
  challenge tier visible at a glance:
  - Collectibles saved count
  - Upgrade points status
  - Gauntlet triggered status
  - Any other tier requirements

The checklist serves double duty — a completion tracker for speedrunners
and a discovery tool for first time players who may not know the
challenge tiers exist.

### Speedrun Friendly Design Considerations

**Skippable cutscenes** — all cutscenes and story sequences must be
skippable from day one. Build this in early rather than retrofitting
later. Essential for run viability.

**Seeded randomization** — any procedural content in a run uses a seed
value so the same seed produces the same run. Allows runners to compare
times meaningfully and enables seed hunting as its own category.

**Load time boundaries** — clear defined load points between scenes
make it easier for the speedrun community to implement load time
removal in their timing tools. Design scene transitions with clear
boundaries from the start.

**Consistent critical path** — regardless of randomization or
procedural content, the critical path to completion must always
be achievable. Randomizer logic respects the nano computer terminal
gating system.

### Randomizer Mode
Shuffles the location of collectibles, upgrades, and enemy placements
while keeping the critical path completable. The nano computer terminal
proximity gating system is well suited to randomizer logic — the game
already tracks access based on exploration, so a randomizer shuffles
what is found where within those constraints.

Randomizer options under consideration:
- Collectible locations shuffled throughout the game world
- Upgrade node contents randomized — unknown until purchased
- Enemy type randomization within encounter budget limits
- Stage order randomization for full game runs

Randomizer and timed mode naturally combine — randomized timed runs
are among the most popular speedrun categories in games that support both.

### Design Philosophy Note
Speedrun support and accessibility support are philosophically opposite
ends of the same spectrum — one strips away forgiveness, the other adds
it. Supporting both explicitly signals that the game respects all kinds
of players. The full range from assisted easy mode to frameless
randomized speedrun is intentional and acknowledged.
