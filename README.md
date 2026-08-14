# Xef KDE Theme

A work-in-progress Plasma 6 global theme with matching **Xef Dark** and **Xef Light** variants.

The goal is to keep the complete desktop appearance in one repository while sharing as much as possible between the light and dark variants. The first component being wired in is the custom Papirus Colorful icon theme; colors, Plasma Style, decorations, cursors, task switcher, wallpapers, layout, splash/lock screen, and other appearance choices will be added as they are finalized.

## Status

Early structure only. Nothing here should be treated as a finished release yet.

The two Global Theme packages are already valid Plasma 6 `Plasma/LookAndFeel` packages, but for now they intentionally set **only the icon theme**:

- Xef Dark -> `Papirus-Dark-Colorful`
- Xef Light -> `Papirus-Light-Colorful`

Other appearance settings stay untouched until they are explicitly chosen.

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

The current choices and all unresolved components are tracked in [`docs/THEME-SPEC.md`](docs/THEME-SPEC.md).

## Plasma 6 package structure

The Global Theme packages use the Plasma 6 `Plasma/LookAndFeel` KPackage format (`metadata.json` plus `contents/`). User-local Global Themes are installed under:

```text
~/.local/share/plasma/look-and-feel/
```

The two package IDs are:

```text
io.github.xefensor.xef-dark
io.github.xefensor.xef-light
```

## Development install

Install/update both Global Theme packages for the current user:

```bash
bash scripts/install.sh
```

Remove only these two Xef Global Theme packages:

```bash
bash scripts/uninstall.sh
```

The current packages reference Papirus Colorful, so build/install the corresponding icon variants from the Papirus fork separately before selecting the Global Theme.

## Related project

The icon component is developed separately in the Papirus fork:

- https://github.com/xefensor/papirus-icon-theme

This repository references the resulting Papirus Colorful variants rather than vendoring the entire icon theme.

## Validation

GitHub Actions checks that both package metadata files are valid JSON, use `KPackageStructure: Plasma/LookAndFeel`, have the expected package IDs/icon-theme defaults, and that the shell scripts parse successfully.
