# Xef KDE Theme

A Plasma 6 Global Theme with matching **Xef Dark** and **Xef Light** variants, bootstrapped from the KDE appearance configuration on the development machine.

The variants share one component language and differ mainly in color-scheme luminance and the matching Papirus Colorful icon variant. Their shared `#127BDC` identity blue drives selection, focus, hover, and only the KWin titlebar containing the application name; application headers and toolbars remain neutral. The titlebar color is authored in the scheme instead of following a user- or wallpaper-selected accent. Error, warning, success, links, and neutral surfaces follow the Papirus palette without giving up Breeze's predictable visual hierarchy. The custom color schemes are bundled; established third-party/system components remain external dependencies.

## Variants

- Xef Dark -> `Papirus-Dark-Colorful`
- Xef Light -> `Papirus-Light-Colorful`

Both packages also select their bundled Xef color scheme and the audited shared Breeze application/Plasma/decoration/switcher/splash stack. They retain the working Breeze titlebar gradient as a deliberate exception to the otherwise flat Papirus-influenced palette. They also select the `Hackneyed-Dark` cursor, Ubuntu fonts, and the shared Xef blue accent (`#127BDC`).

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

The audited machine state is in [`docs/current-state.md`](docs/current-state.md). Design and derivation decisions are in [`docs/theme-spec.md`](docs/theme-spec.md).

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

## One-command install

From a Plasma 6 desktop session, install every user-local dependency, install both Global Themes, and activate **Xef Dark**:

```bash
bash scripts/install.sh
```

Activate **Xef Light** instead:

```bash
bash scripts/install.sh light
```

The installer is rootless. It downloads pinned, checksum-verified releases of both Papirus Colorful variants, Hackneyed-Dark, Ubuntu, and Ubuntu Mono when they are missing. It then installs both Xef packages and color schemes below `~/.local/share/`, applies the selected Global Theme, disables wallpaper-derived accent mode, and reapplies Xef's authored `#127BDC` accent.

Useful options:

```bash
bash scripts/install.sh --no-apply       # install without changing the active theme
bash scripts/install.sh --no-download    # use only dependencies already installed
bash scripts/install.sh --refresh light  # rebuild dependencies and activate Xef Light
```

The host must already be a Plasma 6 installation with Breeze. The bootstrap also requires `bash`, `curl`, `python3`, `tar`, and `sha256sum`; these foundational/system packages are not installed with root privileges.

Allow roughly 3.2 GiB for the two generated Papirus themes. They are deliberately self-contained, so the first run can take several minutes; later runs keep them unless `--refresh` is used.

Remove only these two Xef Global Theme packages and their two bundled color schemes:

```bash
bash scripts/uninstall.sh
```

Downloaded external projects remain installed when `scripts/uninstall.sh` removes Xef itself because they may be shared by other themes. Wallpapers, lock-screen content, panel layout, and SDDM are intentionally not changed; see the audit for why.

## Related project

The icon component is developed separately in the Papirus fork:

- https://github.com/xefensor/papirus-icon-theme

This repository references the resulting Papirus Colorful variants rather than vendoring the entire icon theme.

Pinned dependency sources, versions, checksums, and licenses are documented in [`docs/dependencies.md`](docs/dependencies.md).

## Validation

Run the same validation used by CI locally:

```bash
bash scripts/validate.sh
```

It checks both package metadata/defaults, both KDE color schemes, exact cross-references, shared defaults, privacy-sensitive path patterns, and shell syntax.
