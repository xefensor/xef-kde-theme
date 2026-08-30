# Current Plasma appearance audit

Audit date: 2026-08-14. The machine is running Plasma/KWin 6.7.4.

The selected Global Theme at audit time was the legacy **Xef Light Colored** package. The machine also has a corresponding legacy **Xef Dark Colored** package and custom dark scheme. This distinction matters: the live session was light even though Xef Dark is the requested baseline. The repository uses the existing installed dark counterpart rather than inventing a new dark palette.

## Appearance summary

| Item | Actual current configuration | Repository decision | Classification |
| --- | --- | --- | --- |
| Global Theme | `Xef Light Colored` (legacy local package) | Replaced by clean IDs for both variants | Bundled; variant-specific |
| Color scheme | `XefensorLightColored`; paired dark source is `XefensorDarkColored` | Used as the baselines for `XefLight` / `XefDark`, then refined with a shared Papirus palette and Breeze role hierarchy | Bundled; variant-specific |
| Accent | Custom `84,108,194` over the scheme's authored cyan-blue roles | Audited value documented; repository variants deliberately use supplied folder blue `18,123,220` | Shared |
| Icons | `Papirus-Light-Colorful`; dark variant is also installed | Reference the requested dark/light pair | External dependency; variant-specific |
| Plasma Style | `default` (Breeze) | Reference `default` in both variants | External dependency; shared |
| Application style | `Breeze`; outlines disabled and small shadows | Reference Breeze and reproduce its `breezerc` adjustments in both variants | External dependency; shared settings bundled |
| Window decoration | library `org.kde.breeze`, theme `Breeze`; background gradient enabled | Reference Breeze and retain the working titlebar gradient in both variants | External dependency; shared settings bundled |
| Cursor | `Hackneyed-Dark` from the user's icon search path | Reference in both variants | External dependency; shared |
| General fonts | Ubuntu Regular 11 | Reproduce in both variants | External dependency; shared |
| Fixed font | Ubuntu Mono Regular 11 | Reproduce in both variants | External dependency; shared |
| Smallest readable font | Ubuntu Regular 9 | Reproduce in both variants | External dependency; shared |
| Font rendering | Antialiasing on; slight hinting; subpixel mode `none` | Antialiasing and hinting represented; subpixel omitted as display-specific | Shared / partially represented |
| Task switcher | Breeze Global Theme switcher ID `org.kde.breeze.desktop` inherited from the active legacy package | Reference in both variants | External dependency; shared |
| Desktop switcher | Same Breeze ID | Reference in both variants | External dependency; shared |
| Splash | Selection resolves through the legacy current Global Theme, which has no bundled splash; effective implementation falls back to Breeze | Explicitly select `org.kde.breeze.desktop` | External dependency; shared |
| Desktop wallpaper | Slideshow using personal local images on both desktops | Do not copy or select | Not yet represented |
| Lock screen | `org.kde.potd` (Picture of the Day); an inactive Scarlet Tree image configuration is also present | Leave untouched | Not yet represented |
| Panel/layout | Two bottom panels, one per desktop/screen containment | Document now; do not copy generated IDs/state | Not yet represented |
| SDDM | System override selects `breeze`, `Hackneyed-Dark`, and Ubuntu 11 | Do not install system-level SDDM settings from a user-local installer | Documented only |

## Color details

The active source file is:

```text
~/.local/share/color-schemes/XefensorLightColored.colors
```

The existing dark counterpart is:

```text
~/.local/share/color-schemes/XefensorDarkColored.colors
```

Both are custom schemes and were the initial source material. The light source has light window/view/button/tooltip surfaces while retaining a dark complementary surface. After the audit, the user explicitly requested a more complete Papirus treatment while preserving Breeze's predictable light/dark hierarchy, so the repository schemes are now deliberate refinements rather than byte-for-byte copies.

The final schemes use the custom Papirus generator's negative/error `#C6362B`, neutral/warning `#DC8225`, positive/success `#4BAE4F`, and bright link blue `#4A91E1`. Their neutral ramps are also Papirus-informed, while each KDE surface role remains ordered in a Breeze-like way. These are documented post-audit design changes, not claims about the original live files.

The live `kdeglobals` also contains KDE-generated color overrides for a custom `84,108,194` accent. Those generated groups and their hash were not copied as personal runtime state. After the audit, the user supplied a folder-color reference with dominant blue `18,123,220` (`#127BDC`); both Global Theme defaults and both schemes now use it for their shared accent identity.

## Panel and desktop layout

Two folder-view desktop containments were found. Both use the slideshow wallpaper plugin with personal local image sources; one desktop also contains an analog clock widget. The wallpaper paths, slideshow history, activity IDs, screen mappings, and containment IDs are deliberately excluded.

Two bottom panels were found, corresponding to the two desktop/screen containments:

- Both are 50 px high, non-floating, opaque, normally visible, and full-length/default-length.
- The reusable ordering is launcher, icon task manager, separators/spacers, system tray, digital clock, and show-desktop.
- The clock has no reusable overrides, so it uses Plasma defaults.
- One panel additionally contains PlasmaLLM and Web Browser widgets; both panels use a third-party dotted separator. These are documented but not copied into a portable layout.
- System tray item lists, hidden-item state, pinned applications, and widget-specific personal settings are excluded.

The installed legacy Global Theme contains a generated 429-line layout script. It embeds machine-specific containment state and personal wallpaper/plugin configuration, so it is not a safe source asset. A clean shared layout is deferred rather than silently changing panel behavior.

## Breeze adjustments

The reusable Breeze configuration is represented in both Global Theme defaults:

```ini
[breezerc][Common]
OutlineEnabled=false
OutlineIntensity=OutlineOff
ShadowSize=ShadowSmall

[breezerc][Windeco]
DrawBackgroundGradient=true
```

No custom window-button layout was present in `kwinrc`, so Plasma's default button arrangement remains untouched.

## Wallpaper and lock screen

The active desktop wallpaper is not a stable package: it is a slideshow over personal files. No image was copied and no wallpaper was invented.

The lock screen currently uses Picture of the Day, whose displayed image changes and may depend on a remote provider. A cached/inactive configuration references KDE's system `ScarletTree` wallpaper (`Next`, CC-BY-SA-4.0), but that is not the active lock-screen plugin and is therefore not selected by Xef.

## Excluded configuration

No application settings, accounts, shortcuts, recent files, wallpaper paths, activity identifiers, display mapping, scaling/DPI, tray state, pinned applications, device configuration, or other private/machine-specific values were copied. Only reusable appearance identifiers and font/color choices are represented.
