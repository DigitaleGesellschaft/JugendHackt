
# Create UEFI USB Stick

- Download Debian Image
  - https://www.debian.org/releases/bookworm/debian-installer/
  - `wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.7.0-amd64-netinst.iso`
- Mount CD-ROM ISO
- Adjust preseed.cfg
- Insert USB Stick
- Automatically create bootable USB Stick
  - `./make-usbstick PATH-TO-DEBIAN-ISO USB-STICK-DEVCE`

# Setup Laptop

- Insert USB Stick
- Boot from USB Stick
- Wait (ca. 30 Minutes)
- Login digiges/digiges

# Additional Documentation

- https://wiki.debian.org/DebianInstaller/WritableUSB-Stick
- https://www.debian.org/releases/bookworm/amd64/apb.en.html
