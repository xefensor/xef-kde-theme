#!/usr/bin/env bash
set -euo pipefail

data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
look_and_feel_destination="$data_home/plasma/look-and-feel"
color_destination="$data_home/color-schemes"

for package_name in \
    io.github.xefensor.xef-dark \
    io.github.xefensor.xef-light; do
    if [[ -d "$look_and_feel_destination/$package_name" ]]; then
        rm -rf -- "$look_and_feel_destination/$package_name"
        printf 'Removed %s\n' "$package_name"
    fi
done

for scheme_name in XefDark.colors XefLight.colors; do
    if [[ -f "$color_destination/$scheme_name" ]]; then
        rm -- "$color_destination/$scheme_name"
        printf 'Removed %s\n' "$scheme_name"
    fi
done
