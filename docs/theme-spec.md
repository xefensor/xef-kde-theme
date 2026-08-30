# Xef KDE Theme specification

Xef Dark and Xef Light are two Plasma 6 variants of one theme. The specification is grounded in the appearance configuration audited on 2026-08-14; unresolved components remain explicit instead of being filled with invented assets.

## Variant map

| Component | Xef Dark | Xef Light | Ownership |
| --- | --- | --- | --- |
| Global Theme package | `io.github.xefensor.xef-dark` | `io.github.xefensor.xef-light` | Bundled, variant-specific |
| Color scheme | `XefDark` | `XefLight` | Bundled, variant-specific |
| Accent | `18,123,220` | `18,123,220` | Shared Xef blue from the supplied folder reference |
| Icons | `Papirus-Dark-Colorful` | `Papirus-Light-Colorful` | External, variant-specific |
| Application style | Breeze with audited outline/shadow settings | Same | External engine, shared settings bundled |
| Plasma Style | Breeze (`default`) | Breeze (`default`) | External, shared; follows the selected color scheme |
| Window decoration | Breeze / `org.kde.breeze`, accent-colored active titlebar | Same | External engine, shared settings bundled; inactive colors follow the variant |
| Cursor | `Hackneyed-Dark` | Same | External, shared |
| Fonts | Ubuntu 11; Ubuntu Mono 11; Ubuntu 9 minimum | Same | External, shared |
| Task/desktop switcher | `org.kde.breeze.desktop` | Same | External, shared |
| Splash | `org.kde.breeze.desktop` | Same | External, shared |
| Wallpaper | Not selected by the package | Not selected by the package | Documented, not implemented |
| Lock screen | Not selected by the package | Not selected by the package | Documented, not implemented |
| Panel/layout | Not installed by the package | Not installed by the package | Documented, not implemented |
| SDDM | Not installed by the package | Not installed by the package | System-level, out of the user-local installer |

## Xef Dark

`XefDark.colors` began with the installed `XefensorDarkColored.colors` scheme that belongs to the machine's legacy **Xef Dark Colored** Global Theme. Its portable identity is now `XefDark` / **Xef Dark**. Its role structure and dark personality remain the baseline; the final neutral ramp, shared blue identity, link colors, and semantic status roles are deliberate post-audit refinements requested for closer Papirus alignment.

The audit session itself was using the legacy light package. This means Xef Dark cannot honestly be described as the literally active scheme at the instant of the audit. It is nevertheless the existing dark counterpart already created for that desktop, and is therefore the closest non-invented dark baseline. The refined dark hierarchy uses `#202020` views, `#282828` windows, `#323232` controls, and `#3F3F3F` tooltips. Application headers inherit a neutral fallback rather than receiving their own accent-colored group. Each step gets lighter as a surface is raised, following Breeze rather than arbitrarily reversing emphasis.

The live desktop had a custom accent override of `84,108,194` layered over the scheme. The finished variants instead share the user-supplied folder blue `18,123,220` (`#127BDC`) as `AccentColor`, focus, hover, selection, and active-titlebar color. Active links on dark surfaces use the custom Papirus generator's brighter `#4A91E1`, which remains legible without changing the Xef accent identity. The titlebar mechanism is retained from the known-working pre-Papirus version: `TitlebarIsAccentColored=true`, matching blue `[WM]` roles with white title text, no explicit `[Colors:Header]` groups, and Breeze's titlebar gradient enabled. The missing Header groups are intentional; adding them during the Papirus rewrite caused the application header below the titlebar to be colored too. Inactive dark titlebars recede to `#202020`.

## Xef Light

`XefLight.colors` began with the installed and active `XefensorLightColored.colors` source, renamed to the portable `XefLight` identity. It remains a deliberate counterpart rather than stock Breeze Light, but its neutral roles were coordinated with the refined dark ramp so both variants now express the same material hierarchy.

The light variant keeps the family's blue focus/hover and selection identity and violet visited links. Its status roles use Papirus red, orange, and green. Views are white, controls and tooltips are `#F3F3F3`, windows use Papirus paper `#E4E4E4`, and alternate lower surfaces use `#DADADA`. Application headers inherit the neutral light fallback. Primary text is Papirus plastic `#3F3F3F`. Complementary areas intentionally remain dark (`#4F4F4F`). The active titlebar shares Dark's `#127BDC` accent treatment, while the inactive titlebar recedes into `#F3F3F3`.

## Shared design principles

- Both variants are one visual identity, not independent redesigns.
- Semantic colors retain the same meanings and relationships across variants.
- Papirus Colorful supplies the same colored-icon philosophy with dark/light neutral fallbacks.
- Breeze supplies shared widget geometry, Plasma assets, decoration geometry, switching UI, and splash behavior.
- The Breeze adjustments are shared: outlines off, small shadows, and the previously working titlebar gradient. The gradient is confined to the window decoration; application surfaces retain the flat Papirus-influenced treatment.
- Font families, sizes, cursor, and component choices remain shared.
- Variant differences are primarily surface luminance, text luminance, and the corresponding icon variant.
- Personal content, hardware topology, accounts, tray state, application configuration, and recent data are not theme material.

## Color-source notes

The audited source schemes contain the pair's original cyan-blue role color (`61,174,233`). The active session additionally stored a KDE custom accent (`84,108,194`) and generated runtime color overrides from it. At the latest inspection, `accentColorFromWallpaper=true` was still replacing scheme colors with a brown wallpaper-derived accent. Following the audit, a supplied folder reference established `18,123,220` (`#127BDC`) as the final shared identity blue. It replaces the original cyan in selection, focus, and hover, replaces the live accent in both Global Theme defaults, and is encoded directly in the window-manager titlebar roles. The installer disables wallpaper-derived accent mode before reapplying the Xef color scheme. Application Header groups are deliberately omitted to preserve the earlier top-strip-only behavior. Transient keys such as `ColorSchemeHash` and `LastUsedCustomAccentColor` are not bundled.

The custom Papirus generator establishes `#C6362B` red, `#DC8225` amber, `#4BAE4F` green, and `#4A91E1` bright blue. Xef maps those to KDE negative, neutral, positive, and dark-surface link roles respectively. The supplied `#127BDC` remains Xef's deliberate accent/focus identity. The upstream [Papirus Design Notes](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/blob/master/tools/work/DESIGN.md) also supply material anchors for the neutral ramp: paper `#E4E4E4`, plastic `#4F4F4F`, dark grey `#5D5D5D`, and light grey `#CCCCCC`. They are adapted into KDE roles rather than copied indiscriminately.

No mathematical inversion was performed. Both variants use the same semantic meanings and a Breeze-style role model: content views remain distinct from window canvases, raised controls remain distinct from content, application headers remain neutral, and complementary surfaces preserve usable contrast. Papirus influences hue and material character without breaking native KDE state behavior.

## Layout policy

The live setup has two bottom panels because it has two desktop containments. It also contains third-party/application widgets and per-screen IDs. A generated legacy layout script was found, but it contains wallpaper histories, machine-specific containment state, and personal configuration. It was not copied.

A shared layout script remains TBD until there is a deliberate portable policy for single- versus multi-screen installation and for optional widgets. The stable reusable target is documented in [current-state.md](current-state.md): bottom, 50 px, full-length, non-floating, opaque panels with launcher/tasks on the left and tray/clock/show-desktop on the right.

## External dependencies

- KDE Plasma 6 Breeze components: application style, Plasma Style, KWin decoration, switcher, and splash.
- [Papirus Colorful fork](https://github.com/xefensor/papirus-icon-theme): `Papirus-Dark-Colorful` and `Papirus-Light-Colorful`.
- `Hackneyed-Dark` cursor theme.
- Ubuntu and Ubuntu Mono fonts.

The rootless installer downloads and verifies the user-local Papirus, Hackneyed, and font dependencies automatically. Plasma 6 and Breeze remain system prerequisites and are never installed through `sudo`. The complete pinned manifest is in [dependencies.md](dependencies.md).

The current slideshow wallpaper, lock-screen Picture of the Day, and SDDM configuration are not package dependencies because the Global Themes do not attempt to reproduce them.

## Deferred work

- Decide on a portable panel/desktop layout and whether its optional third-party widgets are dependencies.
- Decide whether a stable, redistributable wallpaper or dark/light pair should replace the personal slideshow.
- Decide whether to package a lock-screen wallpaper instead of leaving the current dynamic source untouched.
- Add previews after the appearance stack is tested from a clean user profile.
- Choose a repository license before publishing original visual assets.
