#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

bash -n "$repo_root"/scripts/*.sh

python3 - "$repo_root" <<'PY'
import configparser
import json
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])

install_script = (root / "scripts" / "install.sh").read_text(encoding="utf-8")
for required_bootstrap_value in (
    "6fcea65d3e9fdf0c80e1c5959f1065753c5365b5",
    "02589abb8e25d2892d9471ef1003fa1319def56c0387f7dbb203f36151f31393",
    "3d238c5ac8e705a4268cc3d70ffbe19ade703b2b54ce7065501539246bf229b0",
    "Hackneyed-Dark-0.9.3-right-handed.tar.bz2",
    "00b9c5bb9bbf762a341a23071600cbf6bc458a2724afa18d5e227d24a7fac6fa",
    "352f6b7d9d6cc4fa9e242b931291d31b21a6dc84",
    "lookandfeeltool --apply",
    "plasma-apply-colorscheme",
    "accentColorFromWallpaper",
):
    assert required_bootstrap_value in install_script, (
        f"bootstrap manifest/application entry missing: {required_bootstrap_value}"
    )
assert "sudo " not in install_script, "the user-local installer must not invoke sudo"

variants = {
    "io.github.xefensor.xef-dark": {
        "name": "Xef Dark",
        "scheme": "XefDark",
        "icons": "Papirus-Dark-Colorful",
    },
    "io.github.xefensor.xef-light": {
        "name": "Xef Light",
        "scheme": "XefLight",
        "icons": "Papirus-Light-Colorful",
    },
}


def read_ini(path: Path) -> configparser.RawConfigParser:
    parser = configparser.RawConfigParser(interpolation=None, strict=True)
    parser.optionxform = str
    with path.open(encoding="utf-8") as handle:
        parser.read_file(handle)
    return parser


defaults_by_id = {}
for package_id, expected in variants.items():
    package = root / "look-and-feel" / package_id
    metadata_path = package / "metadata.json"
    defaults_path = package / "contents" / "defaults"
    assert metadata_path.is_file(), f"missing {metadata_path}"
    assert defaults_path.is_file(), f"missing {defaults_path}"

    metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
    assert metadata["KPackageStructure"] == "Plasma/LookAndFeel"
    assert metadata["X-Plasma-APIVersion"] == "2"
    plugin = metadata["KPlugin"]
    assert plugin["Id"] == package_id
    assert plugin["Name"] == expected["name"]

    defaults = read_ini(defaults_path)
    defaults_by_id[package_id] = defaults
    assert defaults["kdeglobals][General"]["ColorScheme"] == expected["scheme"]
    assert defaults["kdeglobals][General"]["AccentColor"] == "18,123,220"
    assert defaults["kdeglobals][General"]["accentColorFromWallpaper"] == "false"
    assert defaults["kdeglobals][Icons"]["Theme"] == expected["icons"]
    assert defaults["kdeglobals][KDE"]["widgetStyle"] == "Breeze"
    assert defaults["breezerc][Common"]["OutlineEnabled"] == "false"
    assert defaults["breezerc][Common"]["OutlineIntensity"] == "OutlineOff"
    assert defaults["breezerc][Common"]["ShadowSize"] == "ShadowSmall"
    assert defaults["breezerc][Windeco"]["DrawBackgroundGradient"] == "true"
    assert defaults["plasmarc][Theme"]["name"] == "default"
    assert defaults["kcminputrc][Mouse"]["cursorTheme"] == "Hackneyed-Dark"
    assert defaults["kwinrc][org.kde.kdecoration2"]["library"] == "org.kde.breeze"
    assert defaults["kwinrc][org.kde.kdecoration2"]["theme"] == "Breeze"
    assert defaults["kwinrc][WindowSwitcher"]["LayoutName"] == "org.kde.breeze.desktop"
    assert defaults["kwinrc][DesktopSwitcher"]["LayoutName"] == "org.kde.breeze.desktop"
    assert defaults["ksplashrc][KSplash"]["Theme"] == "org.kde.breeze.desktop"


def normalized_defaults(parser: configparser.RawConfigParser) -> dict[str, dict[str, str]]:
    result = {section: dict(parser[section]) for section in parser.sections()}
    del result["kdeglobals][General"]["ColorScheme"]
    del result["kdeglobals][Icons"]["Theme"]
    return result


dark_defaults = defaults_by_id["io.github.xefensor.xef-dark"]
light_defaults = defaults_by_id["io.github.xefensor.xef-light"]
assert normalized_defaults(dark_defaults) == normalized_defaults(light_defaults), (
    "shared Global Theme defaults differ beyond ColorScheme and icon Theme"
)

color_sections = (
    "Colors:Button",
    "Colors:Complementary",
    "Colors:Selection",
    "Colors:Tooltip",
    "Colors:View",
    "Colors:Window",
)
color_keys = (
    "BackgroundAlternate",
    "BackgroundNormal",
    "DecorationFocus",
    "DecorationHover",
    "ForegroundActive",
    "ForegroundInactive",
    "ForegroundLink",
    "ForegroundNegative",
    "ForegroundNeutral",
    "ForegroundNormal",
    "ForegroundPositive",
    "ForegroundVisited",
)
semantic_colors = {
    "ForegroundNegative": "198,54,43",
    "ForegroundNeutral": "220,130,37",
    "ForegroundPositive": "75,174,79",
}
identity_blue = "18,123,220"
rgb_pattern = re.compile(r"(?:0|[1-9][0-9]{0,2}),(?:0|[1-9][0-9]{0,2}),(?:0|[1-9][0-9]{0,2})\Z")

expected_palettes = {
    "XefDark": {
        "surfaces": {
            "Colors:Button": ("50,50,50", "63,63,63"),
            "Colors:Complementary": ("40,40,40", "50,50,50"),
            "Colors:Selection": ("18,123,220", "14,98,176"),
            "Colors:Tooltip": ("63,63,63", "50,50,50"),
            "Colors:View": ("32,32,32", "40,40,40"),
            "Colors:Window": ("40,40,40", "50,50,50"),
        },
        "wm": ("18,123,220", "255,255,255", "32,32,32", "142,142,142"),
    },
    "XefLight": {
        "surfaces": {
            "Colors:Button": ("243,243,243", "233,233,233"),
            "Colors:Complementary": ("79,79,79", "93,93,93"),
            "Colors:Selection": ("18,123,220", "14,98,176"),
            "Colors:Tooltip": ("243,243,243", "233,233,233"),
            "Colors:View": ("255,255,255", "243,243,243"),
            "Colors:Window": ("228,228,228", "218,218,218"),
        },
        "wm": ("18,123,220", "255,255,255", "243,243,243", "142,142,142"),
    },
}


def parse_rgb(value: str) -> tuple[int, int, int]:
    return tuple(map(int, value.split(",")))


def relative_luminance(value: str) -> float:
    channels = []
    for channel in parse_rgb(value):
        normalized = channel / 255
        channels.append(
            normalized / 12.92
            if normalized <= 0.04045
            else ((normalized + 0.055) / 1.055) ** 2.4
        )
    return 0.2126 * channels[0] + 0.7152 * channels[1] + 0.0722 * channels[2]


def contrast(foreground: str, background: str) -> float:
    light, dark = sorted(
        (relative_luminance(foreground), relative_luminance(background)), reverse=True
    )
    return (light + 0.05) / (dark + 0.05)

for expected in variants.values():
    scheme_id = expected["scheme"]
    path = root / "color-schemes" / f"{scheme_id}.colors"
    assert path.is_file(), f"missing {path}"
    scheme = read_ini(path)
    assert scheme["General"]["ColorScheme"] == scheme_id
    assert scheme["General"]["Name"] == expected["name"]
    assert scheme.has_section("ColorEffects:Disabled")
    assert scheme.has_section("ColorEffects:Inactive")
    assert scheme.has_section("KDE")
    assert scheme.has_section("WM")
    palette = expected_palettes[scheme_id]
    for section in color_sections:
        assert scheme.has_section(section), f"{path}: missing [{section}]"
        for key in color_keys:
            value = scheme[section].get(key)
            assert value and rgb_pattern.fullmatch(value), f"{path}: invalid {section}/{key}={value!r}"
            assert all(0 <= channel <= 255 for channel in map(int, value.split(",")))
        for key, expected_color in semantic_colors.items():
            assert scheme[section][key] == expected_color, (
                f"{path}: {section}/{key} must match Papirus Colorful ({expected_color})"
            )
        assert scheme[section]["DecorationFocus"] == identity_blue
        assert scheme[section]["DecorationHover"] == identity_blue
        expected_normal, expected_alternate = palette["surfaces"][section]
        assert scheme[section]["BackgroundNormal"] == expected_normal
        assert scheme[section]["BackgroundAlternate"] == expected_alternate

    assert scheme["Colors:Selection"]["BackgroundNormal"] == identity_blue
    assert scheme["Colors:Selection"]["ForegroundNormal"] == "255,255,255"
    assert contrast("255,255,255", identity_blue) >= 4.2
    assert not scheme.has_section("Colors:Header"), (
        f"{path}: explicit header roles would tint the application header"
    )
    assert not scheme.has_section("Colors:Header][Inactive"), (
        f"{path}: explicit inactive header roles would tint the application header"
    )
    assert scheme["General"]["TitlebarIsAccentColored"] == "true"

    active_bg, active_fg, inactive_bg, inactive_fg = palette["wm"]
    assert scheme["WM"]["activeBackground"] == active_bg
    assert scheme["WM"]["activeBlend"] == active_bg
    assert scheme["WM"]["activeForeground"] == active_fg
    assert scheme["WM"]["inactiveBackground"] == inactive_bg
    assert scheme["WM"]["inactiveBlend"] == inactive_bg
    assert scheme["WM"]["inactiveForeground"] == inactive_fg
    assert contrast(active_fg, active_bg) >= 4.2

    for section in ("Colors:Button", "Colors:Tooltip", "Colors:View", "Colors:Window"):
        assert contrast(
            scheme[section]["ForegroundNormal"], scheme[section]["BackgroundNormal"]
        ) >= 7, f"{path}: insufficient primary text contrast in [{section}]"

    surface_luminance = {
        section: relative_luminance(scheme[section]["BackgroundNormal"])
        for section in ("Colors:View", "Colors:Window", "Colors:Button", "Colors:Tooltip")
    }
    if scheme_id == "XefDark":
        assert surface_luminance["Colors:View"] < surface_luminance["Colors:Window"]
        assert surface_luminance["Colors:Window"] < surface_luminance["Colors:Button"]
        assert surface_luminance["Colors:Button"] < surface_luminance["Colors:Tooltip"]
    else:
        assert surface_luminance["Colors:View"] > surface_luminance["Colors:Button"]
        assert surface_luminance["Colors:Button"] > surface_luminance["Colors:Window"]

for package_id in variants:
    package = root / "look-and-feel" / package_id
    for path in package.rglob("*"):
        if not path.is_file():
            continue
        text = path.read_text(encoding="utf-8", errors="ignore")
        assert "/home/" not in text, f"personal absolute path found in {path}"
        assert "file:///home/" not in text, f"personal file URL found in {path}"
        assert "activityId=" not in text, f"activity ID found in {path}"
        assert "lastScreen=" not in text, f"screen mapping found in {path}"

print("Validated both Plasma 6 Global Themes and both KDE color schemes")
PY
