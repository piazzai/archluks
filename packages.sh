#!/bin/bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "error: do not run this script as root" >&2
  exit 1
fi

  alsa-utils \
  apparmor \
  blueman \
  bottom \
  breeze-cursors \
  brightnessctl \
  clamav \
  cups \
  cups-pdf \
  dbeaver \
  docker \
  docker-compose \
  dunst \
  fastfetch \
  firefox \
  fprintd \
  fwupd \
  gcc-fortran \
  gimp \
  git \
  git-lfs \
  github-cli \
  globalprotect-openconnect \
  gnome-disk-utility \
  grim \
  gucharmap \
  gvfs \
  hplip \
  hypridle \
  hyprland \
  hyprlauncher \
  hyprlock \
  hyprpaper \
  hyprpolkitagent \
  hyprshutdown \
  imagemagick \
  inkscape \
  intel-ucode \
  ipp-usb \
  jq \
  keepassxc \
  kitty \
  less \
  libreoffice-fresh \
  mesa-utils \
  mullvad-vpn \
  mupdf-gl \
  networkmanager \
  net-tools \
  nm-connection-editor \
  nodejs \
  noto-fonts \
  noto-fonts-cjk \
  noto-fonts-emoji \
  npm \
  nss-mdns \
  nvim \
  openssh \
  pacman-contrib \
  pandoc \
  pass \
  pavucontrol \
  pcmanfm \
  perl-file-homedir \
  perl-yaml-tiny \
  python3-dbus-fast \
  python3-pywayland \
  python3-xkbcommon \
  r \
  reflector \
  rsync \
  ruby \
  ruby-bundler \
  ruby-erb \
  sane \
  sane-airscan \
  shellcheck \
  signal-desktop \
  simple-scan \
  slurp \
  sudo \
  sysstat \
  system-config-printer \
  texlive \
  texlive-langgreek \
  thunderbird \
  tlp \
  traceroute \
  tree \
  ttc-iosevka \
  ttc-iosevka-aile \
  ttc-iosevka-etoile \
  ttc-iosevka-slab \
  ttf-cormorant \
  ttf-montserrat \
  ttf-nerd-fonts-symbols \
  ttf-nerd-fonts-symbols-mono \
  udisks2 \
  ufw \
  uv \
  vlc \
  vlc-plugin-ffmpeg \
  wf-recorder \
  wlr-randr \
  xarchiver \
  xdg-desktop-portal-hyprland \
  yazi

yay -S adobe-base-14-fonts
yay -S cryptomator-bin
yay -S cryptomator-cli
yay -S spotify
yay -S ungoogled-chromium-bin
yay -S vscodium-bin
