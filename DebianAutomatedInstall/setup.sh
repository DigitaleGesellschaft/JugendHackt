#!/bin/sh

# All steps in this script have to be written in a way that the script can be
# executed several times and the end result is always the same (idempotent).
# E.g. overwriting a file is fine, while adding just a few lines to a file is
# not a good idea. The reason for this is that people who use this script do not
# have to remember if they already execute it once.
#
# This script is also written to it work on an existing installation, but also
# as final step for an automated install (via Debian pressed). This is reason
# why it assumed that this script runs as root. During the automated install,
# the user never logged in so far, which means various directories and files
# are not yet existing inside the user directory.

# Exit on the first error.
set -e

USER=digiges

if [ $(id -u) != 0 ]; then
    echo "Run as Root"
    exit
fi

# Allow current user to access /dev/ttyUSB* and /dev/ttyACM*. This is
# necessary to access an Arduino from e.g. the Arduino IDE. Logout/login
# is necessary, to see the effect.
usermod -a -G dialout $USER

# Some Arduino boards identify themselves wrongly as modems and are then
# taken hostage by modemmanager. Simplest idea is to just remove
# modemmanger, assuming using a modem is unlikely to happen.
apt-get remove --yes modemmanager

apt-get autoclean --yes

su - $USER << EOS

mkdir --parents ~/Desktop

cat << EOF > ~/Desktop/Digitale-Gesellschaft.desktop
[Desktop Entry]
Name=Digitale Gesellschaft
Type=Link
URL=https://www.digitale-gesellschaft.ch
Icon=text-html
EOF

cat << EOF > ~/Desktop/Projekte.desktop
[Desktop Entry]
Name=Projekte
Type=Link
URL=https://pad.medialepfade.net/PJ1jn_5HQ4OPHvBBR7-pqw
Icon=text-html
EOF

cat << EOF > ~/Desktop/Links.desktop
[Desktop Entry]
Name=Tools
Type=Link
URL=https://pad.medialepfade.net/deNW2fTCT--BK0lWh8zikQ#
Icon=text-html
EOF

cat << EOF > ~/Desktop/Syncthing.desktop
[Desktop Entry]
Name=Syncthing
Exec=/usr/bin/syncthing -browser-only
Icon=syncthing
Terminal=false
Type=Application
EOF

cat << EOF > ~/Desktop/Terminal.desktop
[Desktop Entry]
Name=Terminal
Exec=gnome-terminal
Icon=org.gnome.Terminal
Terminal=false
Type=Application
EOF

cat << EOF > ~/Desktop/Firefox.desktop
[Desktop Entry]
Name=Firefox
Exec=firefox -new-window
Icon=firefox-esr
Terminal=false
Type=Application
EOF

# .desktop files only execute an application if they are marked as executable.
chmod +x ~/Desktop/*.desktop

mkdir --parents ~/.config/autostart

cat << EOF > ~/.config/autostart/Syncthing.desktop
[Desktop Entry]
Name=Start Syncthing
Exec=/usr/bin/syncthing serve --no-browser --logfile=default
Icon=syncthing
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true
NoDisplay=false
Hidden=false
X-GNOME-Autostart-Delay=0
EOF

# gsettings only works with a logged in session, maybe create a run-once at startup script?
# gsettings set org.gnome.desktop.interface monospace-font-name 'Monospace 12'
# TODO nemo default config? panes? date, ...
# TODO nicer icon set? from mint?
# http://ftp.ch.debian.org/debian/pool/main/m/mint-y-icons/mint-y-icons_1.7.7-1_all.deb
# TODO configure syncthing?

EOS

echo "Logout and Login"
