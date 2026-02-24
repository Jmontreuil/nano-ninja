# Plugins and Third Party Libraries

---

## Where to Find Plugins

- **Godot Asset Library** — built directly into the editor (AssetLib tab). Browse, download,
  and install without leaving Godot.
- **GitHub** — many plugins live independently and are installed by dropping them into the
  project's `addons` folder.

Almost everything worth using is MIT licensed — readable, modifiable, and shippable as your
own version.

---

## Recommended Plugins for This Project

**Beehave** — open source behaviour tree plugin for enemy AI. More powerful and flexible
than a basic state machine for complex enemies like clones. MIT licensed.

**Phantom Camera** — smooth camera transitions and cinematic effects. Relevant for the
opening cutscene and combat camera work. Open source.

**Dialogic** — visual dialogue system for building conversations and cutscenes. Relevant for
story sequences. Highly customisable.

**GUT (Godot Unit Test)** — testing framework for writing automated tests in GDScript.
Pairs directly with the automated combat testing system.

**Aseprite Wizard** — imports Aseprite animation files directly into Godot with all frames
intact. Essentially mandatory for pixel art workflows.

**2D Destructible Objects** — divides sprites into blocks and makes them explode physically.
Adaptable for the persistent particle debris system.

**Gaea** — open source procedural generation addon using a visual graph system. MIT licensed.
Relevant for endless mode room assembly.

---

## Shader Resources

**godotshaders.com** — community library of free open source shaders. Every shader is
readable and tweakable. A learning resource as much as a plugin library. Bookmark immediately.

See [shaders.md](../visual/shaders.md) for the full shader reference including tools for
building mask textures.

---

## Normal Map Tools

**Laigter** — free open source dedicated 2D normal map generator.

**SpriteIlluminator** — dedicated 2D normal map generator.

**Sprite DLight** — feed in a sprite, generates normal map from shape.

Photoshop and Krita can generate normal maps from height maps via plugins.
