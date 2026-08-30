# Bootstrap dependencies

`scripts/install.sh` performs a rootless, user-local bootstrap. External projects are downloaded at install time rather than committed to this repository. Downloads are pinned and verified before anything is installed.

## Manifest

| Component | Pinned source | Installed location | License |
| --- | --- | --- | --- |
| Papirus Dark/Light Colorful | `xefensor/papirus-icon-theme` commit `6fcea65d3e9fdf0c80e1c5959f1065753c5365b5` | `${XDG_DATA_HOME:-~/.local/share}/icons/` | GPL-3.0 |
| Hackneyed-Dark | KDE Store product `999998`, upstream release `0.9.3`, scalable right-handed archive | `${XDG_DATA_HOME:-~/.local/share}/icons/Hackneyed-Dark/` | MIT/X11 |
| Ubuntu and Ubuntu Mono | Google Fonts commit `352f6b7d9d6cc4fa9e242b931291d31b21a6dc84`, version 0.83 TTF files | `${XDG_DATA_HOME:-~/.local/share}/fonts/Xef-Ubuntu/` | Ubuntu Font Licence 1.0 |

Papirus is downloaded as a source snapshot. Because that repository intentionally excludes `tools/` from generated archives, its generator is downloaded separately from the same pinned commit. Both files have pinned SHA-256 digests. The generator builds self-contained `Papirus-Dark-Colorful` and `Papirus-Light-Colorful` themes directly into the user's icon directory. Hackneyed is fetched through KDE Store's API so the short-lived signed asset URL is resolved at install time. The exact archive is then checked against the pinned SHA-256 digest. Every font file has its own pinned SHA-256 digest.

The two generated, self-contained Papirus themes used about 1.6 GiB each in the isolated bootstrap validation. A new installation should therefore have roughly 3.2 GiB of free user storage for icons.

## System prerequisites

The script intentionally does not invoke `sudo` or a distribution package manager. The machine must already provide:

- KDE Plasma 6 and the Breeze Plasma Style, Global Theme, application style, and KWin decoration;
- Bash, curl, Python 3, tar with gzip/bzip2 support, and `sha256sum`;
- fontconfig (`fc-match` and preferably `fc-cache`);
- `lookandfeeltool` when automatic activation is requested.

These are normally present on a fresh Plasma 6 installation. If a system Breeze component is missing, the installer stops with the exact missing component instead of silently falling back.

## Update and offline behavior

Normal runs keep already-installed external dependencies. `--refresh` re-downloads and rebuilds them from the pinned manifest. `--no-download` disables all network access and requires the dependencies to already exist.

The Xef uninstaller removes only the two Xef Global Themes and two Xef color schemes. Downloaded fonts, cursor, and Papirus themes remain because they are separately licensed projects that other themes may use.
