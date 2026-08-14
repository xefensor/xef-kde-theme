# Xef KDE Theme

A work-in-progress Plasma 6 global theme with matching **Xef Dark** and **Xef Light** variants.

The goal is to keep the complete desktop appearance in one repository while sharing as much as possible between the light and dark variants. The first component being wired in is the custom Papirus Colorful icon theme; colors, Plasma Style, decorations, cursors, task switcher, wallpapers, layout, splash/lock screen, and other appearance choices will be added as they are finalized.

## Status

Early structure only. Nothing here should be treated as a finished release yet.

## Repository layout

```text
look-and-feel/       Plasma 6 Global Theme packages
color-schemes/       KDE .colors files
plasma-style/        Plasma desktop themes/styles
window-decorations/  Aurorae or decoration assets/config
cursors/             Optional bundled cursor themes
wallpapers/          Wallpaper packages/assets
task-switchers/      KWin task switcher themes
scripts/             Local install/uninstall helpers
docs/                Theme specification and design decisions
```

## Plasma 6

The Global Theme packages use the Plasma 6 `Plasma/LookAndFeel` KPackage format (`metadata.json` plus `contents/`). User-local Global Themes are installed under:

```text
~/.local/share/plasma/look-and-feel/
```

## Related project

The icon component is developed separately in the Papirus fork:

- https://github.com/xefensor/papirus-icon-theme

This repository will reference/install the resulting Papirus Colorful variants rather than vendoring the entire icon theme.
