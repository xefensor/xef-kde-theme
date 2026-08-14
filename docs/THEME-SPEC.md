# Xef KDE Theme specification

This is the working specification for the theme. Items stay `TBD` until they are deliberately chosen; the repository should not silently invent replacements.

## Variants

| Component | Xef Dark | Xef Light |
| --- | --- | --- |
| Global Theme package | `io.github.xefensor.xef-dark` | `io.github.xefensor.xef-light` |
| Icons | `Papirus-Dark-Colorful` | `Papirus-Light-Colorful` |
| Color scheme | TBD | TBD |
| Application style | TBD | TBD |
| Plasma Style | TBD | TBD |
| Window decoration | TBD | TBD |
| Cursor theme | TBD | TBD |
| Fonts | TBD | TBD |
| Task switcher | TBD | TBD |
| Wallpaper | TBD | TBD |
| Panel/layout | TBD | TBD |
| Splash screen | TBD | TBD |
| Lock screen | TBD | TBD |
| SDDM theme | TBD | TBD |

## Principles

- Light and dark are two variants of one design, kept in one repository.
- Existing projects that can remain independent (especially the Papirus fork) should be dependencies instead of being vendored wholesale.
- Only settings that have been explicitly chosen belong in `contents/defaults`.
- Prefer user-local installation while developing the theme.
- Keep Plasma 6 packages valid KPackages with `KPackageStructure: Plasma/LookAndFeel`.

## Next decisions

1. Add the existing custom KDE color scheme files and wire their `ColorScheme=` names into each Global Theme.
2. Choose the Plasma Style and decide whether to depend on it, fork it, or build a new one.
3. Choose application style and window decorations.
4. Choose cursor theme and fonts.
5. Decide whether the Global Theme should change panel/layout configuration or leave the user's layout alone.
6. Add previews once the visual stack is stable.
7. Choose a license for this repository and for any original visual assets.
