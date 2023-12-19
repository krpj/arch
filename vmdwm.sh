printf '\033c'
echo "\n....Welcome To Kr. PK's DWM Installer Script For ARCH....\n"

pacman -S xorg-server xorg-xinit xorg-xkill xorg-xsetroot xorg-xbacklight xorg-xprop xorg-xrandr \
     mailcap polkit gnu-free-fonts ttf-fira-code ttf-joypixels ttf-font-awesome \
     sxiv mpv mpd mpc ncmpcpp btop tmux emacs zathura zathura-pdf-mupdf ffmpeg imagemagick \
     fzf ytfzf ueberzug man-db xwallpaper python-pywal yt-dlp unclutter xclip maim \
     zip unzip unrar tar p7zip xdotool brightnessctl \
     dosfstools ntfs-3g git sxhkd zsh pipewire pipewire-pulse \
     rsync qutebrowser python-adblock pdfjs firefox newsboat dash at cronie \
     xcompmgr libnotify dunst jq reflector \
     dhcpcd networkmanager rsync pamixer pulsemixer \
     zsh-syntax-highlighting zsh-completions xdg-user-dirs

printf '\033c'
cd $HOME
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/kr-pk/.files.git dotfiles
rsync --recursive --verbose --exclude '.git' dotfiles/ $HOME/
rm -rf dotfiles

git clone https://github.com/kr-pk/dwm.git ~/.local/src/dwm
sudo make -C ~/.local/src/dwm install

git clone https://github.com/kr-pk/st.git ~/.local/src/st
sudo make -C ~/.local/src/st install

git clone https://github.com/kr-pk/dmenu.git ~/.local/src/dmenu
sudo make -C ~/.local/src/dmenu install

git clone https://github.com/kr-pk/dwmblocks.git ~/.local/src/dwmblocks
sudo make -C ~/.local/src/dwmblocks install

git clone https://github.com/kr-pk/wmname.git ~/.local/src/wmname
sudo make -C ~/.local/src/wmname install

git clone https://github.com/kr-pk/tabbed.git ~/.local/src/tabbed
sudo make -C ~/.local/src/tabbed install

git clone https://github.com/kr-pk/slock.git ~/.local/src/slock
sudo make -C ~/.local/src/slock install

git clone https://aur.archlinux.org/libxft-bgra.git ~/.local/src/libxft-bgra
cd $HOME/.local/src/libxft-bgra
makepkg -si

cd $HOME
ln -s ~/.config/xinit/xinitrc .xinitrc
mkdir dls doc musc vdos kr-pk tmp

#Install ZSH....
cd $HOME
ln -s ~/.config/zsh/profile .zprofile
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd $HOME
mv ~/.oh-my-zsh ~/.config/zsh/oh-my-zsh
rm ~/.zshrc ~/.zsh_history

#.git conifiguration to save his dotfiles to /home/.dotfiles....
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dots config --local status.showUntrackedFiles no
exit
