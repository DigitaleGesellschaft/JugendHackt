#!/bin/sh

# All steps in this script have to be written in a way that the script can be
# executed several times and the end result is always the same (idempotent).
# E.g. overwriting a file is fine, while adding just a few lines to a file is
# not a good idea.

# Exit on the first error.
set -e

USER=$(whoami)

if [ $(id -u) = 0 ]; then
    echo "Run as a regular user."
    exit
fi

cat << EOF > ~/Desktop/Digitale-Gesellschaft.desktop
[Desktop Entry]
Name=Digitale Gesellschaft
Type=Link
URL=https://www.digitale-gesellschaft.ch
Icon=text-html
EOF

# TODO URL
cat << EOF > ~/Desktop/Code-Of-Conduct.desktop
[Desktop Entry]
Name=Code of Conduct
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
Icon=firefox
Terminal=false
Type=Application
EOF

# .desktop files only execute an application if they are marked as executable.
chmod +x ~/Desktop/*.desktop

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

# gsettings get org.gnome.Terminal.ProfilesList default
# gsettings set org.gnome.desktop.interface monospace-font-name 'DejaVu Sans Mono 12'
# gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 20'
# apt install fonts-ubuntu?

# TODO gnome-terminal default font size?
# TODO nemo default config? panes? date, ...
# TODO nicer icon set? from mint?
# http://ftp.ch.debian.org/debian/pool/main/m/mint-y-icons/mint-y-icons_1.7.7-1_all.deb
# TODO configure syncthing?

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install --yes syncthing blender krita gimp mypaint geany geany-plugins mc vim emacs arduino audacity build-essential python3 nodejs npm mc meld task-cinnamon-desktop
sudo apt-get autoclean

# Allow current user to access /dev/ttyUSB* and /dev/ttyACM*. This is
# necessary to access an Arduino from e.g. the Arduino IDE. Logout/login
# is necessary, to see the effect.
sudo usermod -a -G dialout $USER

# Some Arduino boards identify themselves wrongly as modems and are then
# taken hostage by modemmanager. Simplest idea is to just remove
# modemmanger, assuming using a modem is unlikely to happen.
sudo apt-get remove --yes modemmanager

echo "Setup finished."
echo "Logout and login manually."
