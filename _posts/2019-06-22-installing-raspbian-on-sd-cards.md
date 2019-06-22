---
layout: post
title: Installing Raspbian on SD Cards
categories: blag
tags: raspberry-pi raspbian
---

Recently I have started dabbling with [Raspberry Pi][rpi] Single Board Computers
(SBCs). One of the first tasks encountered when setting up a new
Raspberry Pi is getting the Raspbian operating system loaded onto a SD card
that the computer will boot from. This involves copying the operating system to
the card and, commonly, configuring WiFi and SSH so that the Pi is accessible
after it boots up. Several articles out on the internet cover various aspects
of this process, but I couldn't find one that gathered everything into one
place, so I decided to write the process down.

  [rpi]: https://www.raspberrypi.org/

## Step 1: Install Raspbian on the card

The first step is to download a [Raspbian][raspbian] disk image and copy it to
the SD card. The latest images can be found at:

&emsp;<https://www.raspberrypi.org/downloads/raspbian/>

The instructions in this article will work with both the "desktop" and "lite"
versions of the distribution. When the download has completed, extract the
archive to get a `.img` file. This image can be written to a SD card using the
`dd` utility:

```sh
sudo dd bs=1m conv=sync \
  if=2019-04-08-raspbian-stretch-lite.img \
  of=«path to SD card device»
```

This process will completely overwrite the SD card with the content of the disk
image which is usually:

  - A `/boot` partition which uses the FAT32 filesystem. This contains the
    bootloader code for Raspberry Pi hardware and is also where configuration
    files can be created in order to ensure the computer starts with systems
    like WiFi and SSH configured.

  - A `/` partition which uses the EXT4 filesystem. This contains the Linux
    operating system which is launched by the `/boot` partition as part of
    startup.

  [raspbian]: https://raspbian.org/


## Step 2: Configure WiFi and SSH

Once the `.img` file has been copied to the SD card, WiFi and SSH can be
configured by mounting the `/boot` partition and writing configuration
files to it. The remainder of this section will assume the partition has
been mounted to `/Volumes/boot`. Substitute another path, such as `/mnt/boot`,
as appropriate.

### Configuring WiFi

The Pi can be configured to connect to a WiFi network when it boots by adding
a [wpa_supplicant.conf][wpa_supplicant] file to the `/boot` partition:

```sh
cat <<'EOF' > /Volumes/boot/wpa_supplicant.conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=«your_ISO-3166-1_two-letter_country_code»

network={
    ssid="«your WiFi network name»"
    psk="«your WiFi password»"
    key_mgmt=WPA-PSK
}
EOF
```

The ISO country code is required to ensure the WiFi transmitter is configured
properly. A list of current codes can be found here:

&emsp;<https://www.iso.org/obp/ui/#search/code/>

  [wpa_supplicant]: https://linux.die.net/man/5/wpa_supplicant.conf

### Configuring SSH

By default, Raspbian will not start the `ssh` service. This can be changed
by adding an empty file named `ssh` to the `/boot` partition:

```sh
touch /Volumes/boot/ssh
```

This will allow SSH access with Raspbian's default username/password of
`pi/raspberry`. If the Pi is connected to a network where it will be
exposed to other users or the internet-at-large, then you must connect
immediately after boot and use `sudo raspi-config` to change the password.
This will prevent a hostile takeover of the computer as the `pi` user has
access to the `root` account via the `sudo` command and the default `raspberry`
password is well-known to other technical users and the internet-at-large.


## References

  - Copying `.img` files to a SD card from various host operating systems:<br>
    <https://www.raspberrypi.org/documentation/installation/installing-images/README.md>

  - Configuring the Pi to connect to a WiFi network after boot:<br>
    <https://raspberrypi.stackexchange.com/a/57023>

  - Enabling `sshd` on first boot:<br>
    <https://www.raspberrypi.org/documentation/remote-access/ssh/README.md>
