# mirror_to_wiki.ps1
# Copies public docs from docs/ into the wiki repo and pushes to GitHub.
# Run from the project root: .\mirror_to_wiki.ps1

$wiki = "wiki"

# GDD
Copy-Item docs\gdd\story.md           $wiki\Story-and-Narrative.md   -Force
Copy-Item docs\gdd\combat.md          $wiki\Combat-and-Systems.md    -Force
Copy-Item docs\gdd\enemies.md         $wiki\Enemies-and-Bosses.md    -Force
Copy-Item docs\gdd\progression.md     $wiki\Progression.md           -Force
Copy-Item docs\gdd\player-experience.md $wiki\Player-Experience.md   -Force

# Visual
Copy-Item docs\visual\shaders.md      $wiki\Shaders.md               -Force
Copy-Item docs\visual\visual-systems.md $wiki\Visual-Systems.md      -Force
Copy-Item docs\visual\art-direction.md  $wiki\Art-Direction.md       -Force

# Technical
Copy-Item docs\technical\godot-reference.md    $wiki\Godot-Reference.md     -Force
Copy-Item docs\technical\debug-room.md         $wiki\Debug-Room.md          -Force
Copy-Item docs\technical\floor-transitions.md  $wiki\Floor-Transitions.md   -Force
Copy-Item docs\technical\plugins.md            $wiki\Plugins.md             -Force
Copy-Item docs\technical\development-workflow.md $wiki\Development-Workflow.md -Force

# Top-level public docs
Copy-Item docs\design_pillars.md  $wiki\Design-Pillars.md  -Force
Copy-Item docs\dev_plan_v2.md     $wiki\Dev-Plan.md        -Force
Copy-Item docs\business.md        $wiki\Business.md        -Force

# Commit and push
Set-Location $wiki
git add -A
git commit -m "wiki: sync from docs/"
git push
Set-Location ..

Write-Host "Wiki synced successfully."
