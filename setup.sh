#!/bin/bash
set -euo pipefail

# enable firewall
sudo ufw enable

# set up antivirus
sudo freshclam

# enable timed services
sudo systemctl enable --now fstrim.timer
sudo systemctl enable --now paccache.timer
sudo systemctl enable --now reflector.timer

# enable other services
sudo systemctl enable --now apparmor
sudo systemctl enable --now avahi-daemon
sudo systemctl enable --now bluetooth
sudo systemctl enable --now clamav-freshclam
sudo systemctl enable --now cups
sudo systemctl enable --now docker
sudo systemctl enable --now ipp-usb
sudo systemctl enable --now mullvad-daemon
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now tlp

# set up mullvad vpn
mullvad auto-connect set on
mullvad tunnel set daita on
mullvad relay set location gb
mullvad relay set multihop on
mullvad relay set ownership owned
mullvad dns set default --block-ads --block-malware --block-trackers

# generate additional locales
sudo sed -i 's/^# en_GB.UTF-8/en_GB.UTF-8/' /etc/locale.gen
sudo locale-gen

# add user to docker group
sudo usermod -aG docker "$(whoami)"

# add apparmor security module, lock down kernel, and quiet boot
LOADER="$(find /boot/loader/entries -name '*linux.conf')"
if ! grep -q 'quiet lsm=landlock,lockdown,yama,apparmor,bpf,integrity lockdown=confidentiality' "$LOADER"; then
  sudo sed -i 's/rw/rw quiet lsm=landlock,lockdown,yama,apparmor,bpf,integrity lockdown=confidentiality/' "$LOADER"
fi

# disable installation of debug packages
sudo sed -i 's/^\(OPTIONS.*\) debug/\1 !debug/' /etc/makepkg.conf

# configure package manager
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
grep -q '^ILoveCandy' /etc/pacman.conf || sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf

# install codium extensions
codium --install-extension esbenp.prettier-vscode
codium --install-extension foam.foam-vscode
codium --install-extension James-Yu.latex-workshop
codium --install-extension jeanp413.open-remote-ssh
codium --install-extension ms-python.python
codium --install-extension REditorSupport.r
codium --install-extension sumneko.lua
codium --install-extension timonwong.shellcheck
codium --install-extension yzhang.markdown-all-in-one

# install user gems
gem install --user-install jekyll

# install r packages
R -e "dir.create(path = Sys.getenv('R_LIBS_USER'), showWarnings = FALSE, recursive = TRUE)"
R -e "install.packages('languageserver', lib = Sys.getenv('R_LIBS_USER'), repos = c(CRAN = 'https://cran.r-project.org'))"
R -e "install.packages('renv', lib = Sys.getenv('R_LIBS_USER'), repos = c(CRAN = 'https://cran.r-project.org'))"
R -e "install.packages('stringi', lib = Sys.getenv('R_LIBS_USER'), repos = c(CRAN = 'https://cran.r-project.org'))"
R -e "install.packages('tidyverse', lib = Sys.getenv('R_LIBS_USER'), repos = c(CRAN = 'https://cran.r-project.org'))"

# enable user services
systemctl --user enable ssh-agent

# enable tap to click
sudo tee << 'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf > /dev/null
Section "InputClass"
  Identifier "touchpad"
  Driver "libinput"
  MatchIsTouchpad "on"
  Option "Tapping" "on"
EndSection
EOF

# enable via configurations
sudo tee << 'EOF' /etc/udev/rules.d/99-keychron.rules > /dev/null
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="01e0", MODE="0660", GROUP="wheel", TAG+="uaccess", TAG+="udev-acl"
EOF
sudo cp /etc/udev/rules.d/99-keychron.rules /etc/udev/rules.d/99-ploopy.rules
sudo sed -i 's/3434/5043/' /etc/udev/rules.d/99-ploopy.rules
sudo sed -i 's/01e0/5c47/' /etc/udev/rules.d/99-ploopy.rules
sudo udevadm control --reload-rules
sudo udevadm trigger

# enable fingerprint auth
PAMFILE=/etc/pam.d/system-local-login
if ! grep -q 'pam_fprintd.so' "$PAMFILE"; then
  sudo sed -i '0,/^auth /s//auth sufficient pam_fprintd.so max_tries=3 timeout=10\nauth sufficient pam_unix.so try_first_pass likeauth\nauth /' "$PAMFILE"
fi

# enroll fingerprints
fprintd-enroll -f left-index-finger
fprintd-enroll -f right-index-finger

# skip username input at login
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf > /dev/null << EOF
[Service]
ExecStart=
ExecStart=-/bin/login -- $(whoami)
EOF
