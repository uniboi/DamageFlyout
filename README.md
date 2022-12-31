# Dependencies

EladNLG's ModSettings are required.
Get the mod here: https://northstar.thunderstore.io/package/EladNLG/ModSettings/

# Usage

There are two different places for macros available. To define a macro, change it in the ModSettings. I recommend writing the macro in a text editor and pasting it in.
A macro is a string that contains tokens that get compiled and executed at runtime. You can declare a token with `${}`.
For example, writing `static` as a macro will always display "static" as title/description.
Writing `${var locals = getstackinfos(3).locals; return locals.damage.tostring()}` DMG instead will output "xDMG" where "x" is the amout of damage the entity has received. It is possible to use `{` and `}` brackets in a macro.
Every token is required to return a string
Macros can't be statically typed.

There is no limit on the number of tokens. For example, something like this is possible: `pre-token ${return "token1"} mid-token ${return "token2"} post token`. This would return "pre-token token1 mid-token token2".

You can switch between a "fancy" flyout and a "compact" one. The compact version looks more like the one from the original DamageDisplay. The fancy one can be a bit distracting because it points to the position of the entity for a few seconds.

## Writing Custom Macros

Tokens get passed some parameters:

- float damage
- vector damagePosition
- entity victim
- bool isCrit
- bool isIneffective
- float summedDamage

You can access those with `getstackinfos(3).locals.variable`. You can also use every other global variable.
To get information about the last flyout, use `lastFlyout`.

lastFlyout contains the rui, the last victim, last damage dealt and the time when.

### Examples

Here are some examples for macros:
```
Get the damage of each individual shot: (x DMG)
${var locals = getstackinfos(3).locals; return locals.damage.tostring()} DMG

Get the combined damage you have dealt to a single individual in the last 3 seconds: (x DMG)
${var locals = getstackinfos(3).locals;var s; if(lastFlyout.victim == locals.victim  && Time() - lastFlyout.damageTime < 3){s = locals.summedDamage + locals.damage}else{s = locals.damage};; return s.tostring()} DMG

Total HP of the Victim and the Max HP of the victim: ( HP / MAXHP)
${var locals = getstackinfos(3).locals; return (locals.victim.GetHealth() - locals.damage).tostring()}/${return getstackinfos(3).locals.victim.GetMaxHealth().tostring()} HP

Remaining health percentage: (x% HP)
${var locals = getstackinfos(3).locals; var totalhealth = locals.victim.GetHealth() - locals.damage;format("%.1f",totalhealth < 0 ? 0 : totalhealth / locals.victim.GetMaxHealth() * 100)}% HP

Viewplayer KD:
${var locals = getstackinfos(3).locals; var kills = GetLocalViewPlayer().GetPlayerGameStat(PGS_KILLS).tofloat();if(locals.victim.GetHealth() - locals.damage < 0){kills++}; var deaths = GetLocalViewPlayer().GetPlayerGameStat(PGS_DEATHS).tofloat(); deaths = deaths ? deaths : 1; return format("%.2f", kills/deaths)} KD

Kills:
${var locals = getstackinfos(3).locals;var kills = GetLocalViewPlayer().GetPlayerGameStat(PGS_KILLS);if(locals.victim.GetHealth() - locals.damage < 0){kills++};return kills.tostring()} Kills
```

You can see what is looks like in this video:

[![Showcase Video](https://media.discordapp.net/attachments/936310823612215326/973730514034913323/DamageDisplay_preview.mp4?format=jpeg&width=600&height=338)](https://cdn.discordapp.com/attachments/936310823612215326/973730514034913323/DamageDisplay_preview.mp4 "Showcase")