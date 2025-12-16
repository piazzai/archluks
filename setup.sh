#!/bin/bash

set -e

# enable firewall
sudo ufw enable

# set up antivirus
sudo freshclam

# enable timed services
sudo systemctl enable fstrim.timer
sudo systemctl enable paccache.timer
sudo systemctl enable reflector.timer

# enable user services
systemctl --user enable ssh-agent.service

# enable other services
sudo systemctl enable apparmor.service
sudo systemctl enable bluetooth.service
sudo systemctl enable clamav-freshclam.service
sudo systemctl enable cups.service
sudo systemctl enable docker.service
sudo systemctl enable NetworkManager.service
sudo systemctl enable tlp.service

# add user to docker group
sudo usermod -aG docker "$(whoami)"

# disable installation of debug packages
sudo sed -i 's/^\(OPTIONS.*\) debug/\1 !debug/' /etc/makepkg.conf

# configure package manager
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf

# set up mullvad vpn
mullvad auto-connect set on
mullvad lan set allow
mullvad tunnel set daita on
mullvad relay set location ch
mullvad relay set multihop on
mullvad relay set ownership owned
mullvad dns set default --block-ads --block-malware --block-trackers

# install codium extensions
codium --install-extension foam.foam-vscode
codium --install-extension James-Yu.latex-workshop
codium --install-extension jeanp413.open-remote-ssh
codium --install-extension ms-python.python
codium --install-extension REditorSupport.r
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

# download color profile
cd ~ && curl -fsSLO https://www.notebookcheck.net/uploads/tx_nbc2/BOE_CQ_______NE135FBM_N41_01.icm -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:134.0) Gecko/20100101 Firefox/134.0'
sudo mv BOE_CQ_______NE135FBM_N41_01.icm /usr/share/color/icc/colord/BOE_CQ_______NE135FBM_N41_01.icm

# install color profile (after rebooting and restoring i3 config)
#colormgr device-add-profile xrandr-BOE "$(colormgr get-profiles | grep -A1 BOE | grep ID | sed 's/^.*icc/icc/')"
