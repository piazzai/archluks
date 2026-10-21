#!/bin/bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "error: do not run this script as root" >&2
  exit 1
fi

sudo pacman -Syu --noconfirm

# hyprland compositor and wayland core
sudo pacman -S --needed --noconfirm \
  hyprland \
  hypridle \
  hyprlauncher \
  hyprlock \
  hyprpaper \
  hyprpolkitagent \
  hyprshutdown \
  mesa-utils \
  seatd \
  xdg-desktop-portal-hyprland \
  wayland \
  wayland-protocols

# display and backlight
sudo pacman -S --needed --noconfirm \
  brightnessctl \
  shikane \
  wlr-randr

# screenshots and recording
sudo pacman -S --needed --noconfirm \
  grim \
  slurp \
  wf-recorder

# audio
sudo pacman -S --needed --noconfirm \
  alsa-utils \
  pavucontrol

# bluetooth
sudo pacman -S --needed --noconfirm \
  blueman

# networking
sudo pacman -S --needed --noconfirm \
  globalprotect-openconnect \
  mullvad-vpn \
  openssh \
  net-tools \
  nm-connection-editor \
  nss-mdns \
  traceroute \
  reflector

# security and authentication
sudo pacman -S --needed --noconfirm \
  apparmor \
  clamav \
  fprintd \
  keepassxc \
  pass \
  sudo \
  ufw

# printing and scanning
sudo pacman -S --needed --noconfirm \
  cups \
  cups-pdf \
  hplip \
  ipp-usb \
  sane \
  sane-airscan \
  simple-scan \
  system-config-printer

# disk, storage, and archives
sudo pacman -S --needed --noconfirm \
  7zip \
  gnome-disk-utility \
  gvfs \
  udisks2 \
  xarchiver

# system monitorin and firmware
sudo pacman -S --needed --noconfirm \
  acpi \
  bottom \
  fastfetch \
  sysstat \
  fwupd

# dev tools
sudo pacman -S --needed --noconfirm \
  base-devel \
  dbeaver \
  docker \
  docker-compose \
  gcc-fortran \
  git \
  git-lfs \
  github-cli \
  nodejs \
  pacman-contrib \
  perl-file-homedir \
  perl-yaml-tiny \
  python-dbus-fast \
  python-pywayland \
  python-xkbcommon \
  r \
  ruby \
  ruby-bundler \
  ruby-erb \
  shellcheck \
  uv

# terminal and file management
sudo pacman -S --needed --noconfirm \
  kitty \
  jq \
  less \
  pcmanfm \
  rsync \
  tree \
  yazi

# documents and office
sudo pacman -S --needed --noconfirm \
  libreoffice-fresh \
  mupdf \
  pandoc-cli \
  texlive \
  texlive-langgreek

# graphics and image editing
sudo pacman -S --needed --noconfirm \
  gimp \
  imagemagick \
  inkscape

# web and communication
sudo pacman -S --needed --noconfirm \
  firefox \
  thunderbird \
  signal-desktop

# media playback
sudo pacman -S --needed --noconfirm \
  vlc \
  vlc-plugin-ffmpeg

# fonts
sudo pacman -S --needed --noconfirm \
  noto-fonts \
  noto-fonts-cjk \
  noto-fonts-emoji \
  ttc-iosevka \
  ttc-iosevka-aile \
  ttc-iosevka-etoile \
  ttc-iosevka-slab \
  ttf-cormorant \
  ttf-montserrat \
  ttf-nerd-fonts-symbols \
  ttf-nerd-fonts-symbols-mono

# cursors
sudo pacman -S --needed --noconfirm \
  breeze-cursors

# character map
sudo pacman -S --needed --noconfirm \
  gucharmap

# power management
sudo pacman -S --needed --noconfirm \
  tlp

# cpu microcode
sudo pacman -S --needed --noconfirm \
  intel-ucode

