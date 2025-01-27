#!/bin/bash
set -e

# install opengl drivers
sudo pacman -S mesa

# install aur helper
sudo pacman -S git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# install, configure, and enable greeter
sudo pacman -S ly
sudo sed -i 's/^\(animation =\) none/\1 doom/' /etc/ly/config.ini
sudo sed -i 's/^\(clock =\) null/\1 %Y-%m-%d %H:%M %Z/' /etc/ly/config.ini
sudo sed -i 's/^\(clear_password =\) false/\1 true/' /etc/ly/config.ini
sudo sed -i 's/^\(initial_info_text =\) null/\1 arch linux/' /etc/ly/config.ini
sudo sed -i 's/^\(hide_borders =\) false/\1 true/' /etc/ly/config.ini
sudo sed -i 's/^\(default_input =\) login/\1 password/' /etc/ly/config.ini
sudo systemctl enable ly

# install hyprland
git clone https://github.com/JaKooLit/Arch-Hyprland.git
cd Arch-Hyprland
chmod +x install.sh
./install.sh
cd ..
rm -rf Arch-Hyprland

# enable network manager
sudo systemctl enable NetworkManager

# enable filesystem trim
sudo systemctl enable fstrim.timer

# install and enable pacman cache clearing
sudo systemctl enable paccache.timer

# install and enable battery life optimizer
sudo pacman -S tlp
sudo systemctl enable tlp

# install pacman mirror selector
sudo pacman -S reflector

# install and enable firewall
sudo pacman -S ufw
sudo ufw enable

# install and connect mullvad vpn
yay -S mullvad-vpn-bin
read -rp "Enter your Mullvad VPN account number: " MULLVAD
mullvad account login "$MULLVAD"
mullvad relay set location ch
mullvad connect

# install globalprotect client
yay -S globalprotect-openconnect-git

# install equalizer and download audio profile
sudo pacman -S easyeffects
curl -fsSLO https://github.com/FrameworkComputer/linux-docs/raw/refs/heads/main/easy-effects/fw13-easy-effects.json

# install command-line utilities
sudo pacman -S rsync github-cli fprintd

# install git lfs
sudo pacman -S git-lfs
git lfs install

# install ruby, bundler, and gems
sudo pacman -S ruby ruby-bundler
gem install --user-install jekyll
gem install --user-install neocities

# install r and packages
sudo pacman -S r
RLIBS="Sys.getenv('R_LIBS_USER')"
MIRROR="c(CRAN = 'https://cran.r-project.org')"
R -e "dir.create(path = $RLIBS, showWarnings = FALSE, recursive = TRUE)"
R -e "install.packages('languageserver', lib = $RLIBS, repos = $MIRROR)"
R -e "install.packages('tidyverse', lib = $RLIBS, repos = $MIRROR)"
R -e "install.packages('renv', lib = $RLIBS, repos = $MIRROR)"

# install texlive
sudo pacman -S texlive

# install vscodium and extensions
yay -S vscodium-bin
codium --install-extension James-Yu.latex-workshop
codium --install-extension yzhang.markdown-all-in-one
codium --install-extension jeanp413.open-remote-ssh
codium --install-extension esbenp.prettier-vscode
codium --install-extension reditorsupport.r

# install keepass and cryptomator
sudo pacman -S keepassxc
yay -S cryptomator-bin

# install dropbox
yay -S dropbox

# install signal
sudo pacman -S signal-desktop

# install web browser and mail client
sudo pacman -S firefox thunderbird

# install graphics editors
sudo pacman -S gimp inkscape

# install spotify
sudo pacman -S spotify-launcher

# set bash variables
printf '%s\n' '' '# Add GPG_TTY for gh authentication' "export GPG_TTY=\$(tty)" \
  '' '# Make user-installed gems executable' "export PATH=\$PATH:\$(ruby -e 'puts Gem.user_dir')/bin" \
  '' '# Include custom scripts' "export PATH=\$HOME/.bin:\$PATH" >> ~/.bashrc

# update and reboot
yay
reboot
