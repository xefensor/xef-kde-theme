#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
destination="$data_home/plasma/look-and-feel"

mkdir -p "$destination"

for package in "$repo_root"/look-and-feel/*; do
    [[ -d "$package" ]] || continue
    package_name="$(basename "$package")"
    rm -rf -- "$destination/$package_name"
    cp -a -- "$package" "$destination/$package_name"
    printf 'Installed %s\n' "$package_name"
done

printf '\nGlobal Theme packages installed in %s\n' "$destination"
printf 'The Papirus Colorful icon variants must be installed separately for the current defaults to resolve.\n'
