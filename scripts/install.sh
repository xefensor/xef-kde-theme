#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'EOF'
Usage: bash scripts/install.sh [dark|light] [options]

Install all user-local Xef dependencies, install both Global Themes, and apply
Xef Dark (the default) or Xef Light.

Options:
  --no-apply       Install everything without changing the active Global Theme.
  --no-download    Do not download missing external dependencies.
  --refresh        Re-download and rebuild user-local external dependencies.
  -h, --help       Show this help.
EOF
}

variant=dark
apply_theme=1
download_dependencies=1
refresh_dependencies=0

while (($#)); do
    case "$1" in
        dark|light)
            variant="$1"
            ;;
        --no-apply)
            apply_theme=0
            ;;
        --no-download)
            download_dependencies=0
            ;;
        --refresh)
            refresh_dependencies=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            printf 'Unknown argument: %s\n\n' "$1" >&2
            usage >&2
            exit 2
            ;;
    esac
    shift
done

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
look_and_feel_destination="$data_home/plasma/look-and-feel"
color_destination="$data_home/color-schemes"
icon_destination="$data_home/icons"
font_destination="$data_home/fonts/Xef-Ubuntu"

papirus_commit=6fcea65d3e9fdf0c80e1c5959f1065753c5365b5
papirus_archive_sha256=02589abb8e25d2892d9471ef1003fa1319def56c0387f7dbb203f36151f31393
papirus_generator_sha256=3d238c5ac8e705a4268cc3d70ffbe19ade703b2b54ce7065501539246bf229b0
papirus_archive_url="https://codeload.github.com/xefensor/papirus-icon-theme/tar.gz/$papirus_commit"
papirus_generator_url="https://raw.githubusercontent.com/xefensor/papirus-icon-theme/$papirus_commit/tools/make-colorful-theme.py"

hackneyed_product_id=999998
hackneyed_archive_name=Hackneyed-Dark-0.9.3-right-handed.tar.bz2
hackneyed_archive_sha256=00b9c5bb9bbf762a341a23071600cbf6bc458a2724afa18d5e227d24a7fac6fa

google_fonts_commit=352f6b7d9d6cc4fa9e242b931291d31b21a6dc84
font_paths=(
    ufl/ubuntu/Ubuntu-Regular.ttf
    ufl/ubuntu/Ubuntu-Bold.ttf
    ufl/ubuntu/Ubuntu-Italic.ttf
    ufl/ubuntu/Ubuntu-BoldItalic.ttf
    ufl/ubuntumono/UbuntuMono-Regular.ttf
    ufl/ubuntumono/UbuntuMono-Bold.ttf
    ufl/ubuntumono/UbuntuMono-Italic.ttf
    ufl/ubuntumono/UbuntuMono-BoldItalic.ttf
)
font_hashes=(
    3128df86a31805618436d0ae5651ba4285d0c9de0a39057d025f64ee33bceb64
    679b5c1e09cab3156bb8ef529735f9382bf31ca7ac737382ab959297f8d82ad4
    4ab857e72f781a8967a6e4a9ac8858fbd6b3a9f9782db349d4b62b78ed02860b
    875d776e7f33c50b1d1b594791da0eba9865648f232f08bcba00bba9dfa01d96
    b35dd9d2131d5d83a9b87fe9ad22c6288fa3d17688d43302c14da29812417d63
    11f15c3a6bbd998a8695fdefb3475931c3789aa035d7546f2efe78e83b352f6b
    960b2bc286c2ff7d49073303858c65e1fc9013c17a971b61123b02c39454ef75
    bd255784bb87b5c41513a12a86f0f9cf061bce4e8256d3bfe7234611002e8f48
)

data_roots=("$data_home")
IFS=: read -r -a configured_data_roots <<< "${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
data_roots+=("${configured_data_roots[@]}")

has_data_path() {
    local relative_path="$1"
    local data_root
    for data_root in "${data_roots[@]}"; do
        [[ -e "$data_root/$relative_path" ]] && return 0
    done
    return 1
}

has_icon_theme() {
    local theme_name="$1"
    has_data_path "icons/$theme_name/index.theme" || [[ -f "$HOME/.icons/$theme_name/index.theme" ]]
}

has_font_family() {
    local font_family="$1"
    local matched_family
    command -v fc-match >/dev/null 2>&1 || return 1
    matched_family="$(fc-match --format '%{family[0]}' "$font_family")"
    [[ "$matched_family" == "$font_family" ]]
}

require_command() {
    local command_name="$1"
    if ! command -v "$command_name" >/dev/null 2>&1; then
        printf 'ERROR: required command is missing: %s\n' "$command_name" >&2
        exit 1
    fi
}

verify_sha256() {
    local expected_hash="$1"
    local path="$2"
    if ! printf '%s  %s\n' "$expected_hash" "$path" | sha256sum --check --status -; then
        printf 'ERROR: checksum verification failed for %s\n' "$path" >&2
        exit 1
    fi
}

download_file() {
    local url="$1"
    local destination="$2"
    curl -fL --retry 3 --connect-timeout 20 --progress-bar -o "$destination" "$url"
}

bootstrap_root=
cleanup() {
    if [[ -n "$bootstrap_root" && -d "$bootstrap_root" ]]; then
        case "$(basename "$bootstrap_root")" in
            xef-kde-bootstrap.*) rm -rf -- "$bootstrap_root" ;;
        esac
    fi
}
trap cleanup EXIT HUP INT TERM

install_papirus_colorful() {
    local archive="$bootstrap_root/papirus.tar.gz"
    local source_root="$bootstrap_root/papirus-source"
    local generator="$bootstrap_root/make-colorful-theme.py"

    printf '\nDownloading the pinned Papirus Colorful source...\n'
    download_file "$papirus_archive_url" "$archive"
    verify_sha256 "$papirus_archive_sha256" "$archive"
    # The repository intentionally export-ignores tools/ from release archives,
    # so fetch the generator independently from the exact same pinned commit.
    download_file "$papirus_generator_url" "$generator"
    verify_sha256 "$papirus_generator_sha256" "$generator"
    mkdir -p "$source_root" "$icon_destination"
    tar -xzf "$archive" -C "$source_root" --strip-components=1

    if [[ ! -d "$source_root/Papirus-Dark" || \
          ! -d "$source_root/Papirus-Light" || \
          ! -f "$source_root/LICENSE" || \
          ! -f "$source_root/AUTHORS" ]]; then
        printf 'ERROR: the Papirus archive is missing expected theme files.\n' >&2
        exit 1
    fi

    python3 "$generator" \
        --source "$source_root/Papirus-Dark" \
        --output-root "$icon_destination"
    python3 "$generator" \
        --source "$source_root/Papirus-Light" \
        --output-root "$icon_destination"

    for theme_name in Papirus-Dark-Colorful Papirus-Light-Colorful; do
        install -m 0644 "$source_root/LICENSE" "$icon_destination/$theme_name/LICENSE"
        install -m 0644 "$source_root/AUTHORS" "$icon_destination/$theme_name/AUTHORS"
        if command -v gtk-update-icon-cache >/dev/null 2>&1; then
            gtk-update-icon-cache -q "$icon_destination/$theme_name" || true
        fi
        printf 'Installed external icon theme %s\n' "$theme_name"
    done
}

install_hackneyed_cursor() {
    local metadata="$bootstrap_root/hackneyed-metadata.json"
    local archive="$bootstrap_root/$hackneyed_archive_name"
    local extracted="$bootstrap_root/hackneyed-extracted"
    local -a asset_info

    printf '\nDownloading Hackneyed-Dark 0.9.3 from KDE Store...\n'
    curl -fsSL --retry 3 -H 'Accept: application/json' \
        -o "$metadata" \
        "https://api.kde-look.org/ocs/v1/content/data/$hackneyed_product_id?format=json"

    mapfile -t asset_info < <(python3 - "$metadata" "$hackneyed_archive_name" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as handle:
    item = json.load(handle)["data"][0]

wanted_name = sys.argv[2]
for index in range(1, 64):
    if item.get(f"downloadname{index}") == wanted_name:
        print(item[f"downloadlink{index}"])
        break
else:
    raise SystemExit(f"KDE Store asset not found: {wanted_name}")
PY
    )
    if [[ ${#asset_info[@]} -ne 1 || -z "${asset_info[0]}" ]]; then
        printf 'ERROR: KDE Store did not return the expected Hackneyed archive.\n' >&2
        exit 1
    fi

    download_file "${asset_info[0]}" "$archive"
    verify_sha256 "$hackneyed_archive_sha256" "$archive"
    mkdir -p "$extracted" "$icon_destination"
    tar -xjf "$archive" -C "$extracted"
    if [[ ! -f "$extracted/Hackneyed-Dark/index.theme" ]]; then
        printf 'ERROR: the Hackneyed archive has an unexpected layout.\n' >&2
        exit 1
    fi

    rm -rf -- "$icon_destination/Hackneyed-Dark"
    cp -a -- "$extracted/Hackneyed-Dark" "$icon_destination/Hackneyed-Dark"
    printf 'Installed external cursor theme Hackneyed-Dark\n'
}

install_ubuntu_fonts() {
    local index
    local relative_path
    local filename
    local downloaded

    printf '\nDownloading pinned Ubuntu and Ubuntu Mono fonts...\n'
    mkdir -p "$font_destination"
    for index in "${!font_paths[@]}"; do
        relative_path="${font_paths[$index]}"
        filename="$(basename "$relative_path")"
        downloaded="$bootstrap_root/$filename"
        download_file \
            "https://raw.githubusercontent.com/google/fonts/$google_fonts_commit/$relative_path" \
            "$downloaded"
        verify_sha256 "${font_hashes[$index]}" "$downloaded"
        install -m 0644 "$downloaded" "$font_destination/$filename"
    done
    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f "$font_destination"
    fi
    printf 'Installed external fonts Ubuntu and Ubuntu Mono\n'
}

if (( download_dependencies )); then
    require_command curl
    require_command python3
    require_command sha256sum
    require_command tar
    bootstrap_root="$(mktemp -d "${TMPDIR:-/tmp}/xef-kde-bootstrap.XXXXXX")"

    if (( refresh_dependencies )) || \
        ! has_icon_theme Papirus-Dark-Colorful || \
        ! has_icon_theme Papirus-Light-Colorful; then
        install_papirus_colorful
    else
        printf 'Papirus Colorful icon themes are already installed; keeping them.\n'
    fi

    if (( refresh_dependencies )) || ! has_icon_theme Hackneyed-Dark; then
        install_hackneyed_cursor
    else
        printf 'Hackneyed-Dark cursor theme is already installed; keeping it.\n'
    fi

    if (( refresh_dependencies )) || \
        ! has_font_family Ubuntu || ! has_font_family 'Ubuntu Mono'; then
        install_ubuntu_fonts
    else
        printf 'Ubuntu and Ubuntu Mono fonts are already installed; keeping them.\n'
    fi
else
    printf 'Skipping external dependency downloads (--no-download).\n'
fi

mkdir -p "$look_and_feel_destination" "$color_destination"

for package_name in \
    io.github.xefensor.xef-dark \
    io.github.xefensor.xef-light; do
    package="$repo_root/look-and-feel/$package_name"
    rm -rf -- "$look_and_feel_destination/$package_name"
    cp -a -- "$package" "$look_and_feel_destination/$package_name"
    printf 'Installed %s\n' "$package_name"
done

for scheme_name in XefDark.colors XefLight.colors; do
    install -m 0644 "$repo_root/color-schemes/$scheme_name" "$color_destination/$scheme_name"
    printf 'Installed %s\n' "$scheme_name"
done

missing_dependencies=0
for icon_theme in Papirus-Dark-Colorful Papirus-Light-Colorful Hackneyed-Dark; do
    if ! has_icon_theme "$icon_theme"; then
        printf 'ERROR: required icon/cursor theme is missing: %s\n' "$icon_theme" >&2
        missing_dependencies=1
    fi
done

for font_family in Ubuntu 'Ubuntu Mono'; do
    if ! has_font_family "$font_family"; then
        printf 'ERROR: required font is missing: %s\n' "$font_family" >&2
        missing_dependencies=1
    fi
done

for required_path in \
    plasma/desktoptheme/default/metadata.json \
    plasma/look-and-feel/org.kde.breeze.desktop/metadata.json; do
    if ! has_data_path "$required_path"; then
        printf 'ERROR: required KDE Breeze component is missing: %s\n' "$required_path" >&2
        missing_dependencies=1
    fi
done

qt_plugin_roots=(
    /usr/lib/qt6/plugins
    /usr/lib64/qt6/plugins
    /usr/lib/x86_64-linux-gnu/qt6/plugins
    /usr/lib/aarch64-linux-gnu/qt6/plugins
)
if command -v qtpaths6 >/dev/null 2>&1; then
    qt_plugin_roots+=("$(qtpaths6 --plugin-dir)")
fi

has_qt_plugin() {
    local relative_path="$1"
    local plugin_root
    for plugin_root in "${qt_plugin_roots[@]}"; do
        [[ -f "$plugin_root/$relative_path" ]] && return 0
    done
    return 1
}

for required_plugin in \
    styles/breeze6.so \
    org.kde.kdecoration3/org.kde.breeze.so; do
    if ! has_qt_plugin "$required_plugin"; then
        printf 'ERROR: required KDE Breeze plugin is missing: %s\n' "$required_plugin" >&2
        missing_dependencies=1
    fi
done

if (( missing_dependencies )); then
    printf '\nInstallation cannot be completed. Install the missing Plasma 6/Breeze system components or rerun with downloads enabled.\n' >&2
    exit 1
fi

printf '\nGlobal Theme packages installed in %s\n' "$look_and_feel_destination"
printf 'Color schemes installed in %s\n' "$color_destination"
printf 'All required dependencies are present.\n'

if (( apply_theme )); then
    require_command lookandfeeltool
    require_command kwriteconfig6
    require_command plasma-apply-colorscheme
    package_id="io.github.xefensor.xef-$variant"
    scheme_id="Xef${variant^}"
    printf 'Applying %s...\n' "$package_id"
    lookandfeeltool --apply "$package_id"
    # A pre-existing wallpaper-derived accent otherwise overrides the theme's
    # authored titlebar and accent colors after the Global Theme is applied.
    kwriteconfig6 \
        --file kdeglobals \
        --group General \
        --key accentColorFromWallpaper \
        false
    plasma-apply-colorscheme "$scheme_id"
    plasma-apply-colorscheme --accent-color '#127BDC'
    printf 'Xef %s is installed and active.\n' "${variant^}"
else
    printf 'Theme activation skipped (--no-apply).\n'
fi
