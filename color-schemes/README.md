# Color schemes

This directory contains the two bundled standalone KDE color schemes:

- `XefDark.colors` (`ColorScheme=XefDark`)
- `XefLight.colors` (`ColorScheme=XefLight`)

They began with the installed custom Xef dark/light pair found during the live Plasma audit. Their final palettes use Breeze's role hierarchy with Papirus-inspired neutral ramps: dark surfaces run from `#202020` to `#3F3F3F`, while light surfaces run from white through `#F3F3F3`, `#E4E4E4`, and `#DADADA`. The supplied folder blue (`#127BDC`) is the shared accent/focus/hover/selection identity. The pre-Papirus working titlebar structure is preserved exactly: `TitlebarIsAccentColored=true`, blue `[WM]` roles, and no explicit `[Colors:Header]` groups. This colors the KWin titlebar while application headers fall back to their normal neutral surface roles. KDE's negative/neutral/positive roles use Papirus Colorful red/orange/green. See [`../docs/theme-spec.md`](../docs/theme-spec.md) for the complete rationale.
