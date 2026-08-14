#!/usr/bin/env bash
set -euo pipefail

data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
destination="$data_home/plasma/look-and-feel"

for package_name in \
    io.github.xefensor.xef-dark \
    io.github.xefensor.xef-light; do
    if [[ -d "$destination/$package_name" ]]; then
        rm -rf -- "$destination/$package_name"
        printf 'Removed %s\n' "$package_name"
    fi
done
