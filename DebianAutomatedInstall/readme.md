
# Setup UEFI USB Stick

- Download Debian Image
  - https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.7.0-amd64-netinst.iso
  - https://www.debian.org/releases/bookworm/debian-installer/
- Mount CD-ROM ISO
- Prepare USB Stick
  - `parted --script /dev/sdX mklabel msdos`
  - `parted --script /dev/sdX mkpart primary fat32 0% 100%`
  - `mkfs.vfat /dev/sdX1`
  - `mount /dev/sdX1 /mnt/usbstick`
- Copy CD-ROM -> USB-Stick
  - `rsync -av /mnt/cdrom/ /mnt/usbstick`
- Copy grub.cfg
  - `cp grub.cfg /mnt/usbstick/boot/grub/grub.cfg`
- Adjust preseed.cfg
  - MY-SSID
  - MY-PASSWORD
- Copy preseed.cfg
  - `cp preseed.cfg /mnt/usbstick/preseed.cfg`
- Unmount USB Stick
  - `umount /mnt/usbstick`

# Setup Laptop

- Insert USB-Stick
- Boot from USB-Stick
- Select "Digitale Gesellschaft Install"
- Wait (ca. 30 Minutes)
- Login digiges/digiges
- Configure User
  - `curl -sS https://thomasstauffer666.github.io/DigitaleGesellschaft/DebianAutomatedInstall/setup.sh | sh`

# TODO

- Grub Auto Install?
- Auto Select ESSID
- Install Cinnamon
- Execute setup.sh?

# Additional Documentation

- https://wiki.debian.org/DebianInstaller/WritableUSB-Stick
- https://www.debian.org/releases/bookworm/amd64/apb.en.html
