# == MY ARCH SETUP INSTALLER == #
#part1
printf '\033c'
echo "\n....Welcome To Kr. PK's Arch[UEFI-GPT] Installer Script....\n"
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
pacman -Sy archlinux-keyring
loadkeys us
lsblk
echo "\nNote: This Installer Script Is For UEFI[GPT] System.... So, Create Partition's As Mentioned Below[SWAP Partition Is Optional]....\n"
echo "....1. EFI[MIN: 500MB]........2. SWAP[MIN: 1.5GB]........3. LINUX[MIN: 50GB]....\n\n"
echo "Enter The Drive: "
read drive
cfdisk $drive 
echo "Enter The Linux Partition: "
read partition
mkfs.ext4 $partition 
read -p "Did You Created A SWAP Partition? [y/n]: " answerswap
if [[ $answerswap = y ]] ; then
  echo "Enter SWAP Partition: "
  read swappartition
  mkswap $swappartition
  swapon $swappartition
fi
read -p "Did You Created A EFI Partition? [y/n]: " answerefi
if [[ $answerefi = y ]] ; then
  echo "Enter EFI partition: "
  read efipartition
  mkfs.vfat -F 32 $efipartition
fi
mount $partition /mnt 
pacstrap /mnt base base-devel linux linux-firmware sudo neovim vi intel-ucode xf86-video-intel vulkan-intel 
genfstab -U /mnt >> /mnt/etc/fstab
sed '1,/^#part2$/d' `basename $0` > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
exit 

#part2
printf '\033c'
pacman -S sed
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
timedatectl set-ntp true
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "Hostname: "
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts
mkinitcpio -P
passwd
pacman -S grub efibootmgr os-prober
echo "Enter EFI partition: " 
read efipartition
mkdir /boot/efi
mount $efipartition /boot/efi 
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
sed -i 's/quiet/pci=noaer/g' /etc/default/grub
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S xorg-server xorg-xinit xorg-xkill xorg-xsetroot xorg-xbacklight xorg-xprop xorg-xrandr \
     mailcap polkit gnu-free-fonts ttf-fira-code ttf-joypixels ttf-font-awesome \
     sxiv mpv mpd mpc ncmpcpp btop tmux emacs zathura zathura-pdf-mupdf ffmpeg imagemagick \
     fzf man-db xwallpaper python-pywal yt-dlp unclutter xclip maim \
     zip unzip unrar tar p7zip xdotool brightnessctl \
     dosfstools ntfs-3g git sxhkd zsh pipewire pipewire-pulse \
     rsync qutebrowser python-adblock pdfjs firefox newsboat dash at cronie \
     xcompmgr libnotify dunst jq reflector \
     dhcpcd networkmanager rsync pamixer pulsemixer \
     zsh-syntax-highlighting zsh-completions xdg-user-dirs

systemctl enable NetworkManager.service 
rm /bin/sh
ln -s dash /bin/sh
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Enter Username: "
read username
useradd -m -G wheel -s /bin/zsh $username
passwd $username
echo "Pre-Installation Finish Reboot now"

ai3_path=/home/$username/arch_install3.sh
sed '1,/^#part3$/d' arch_install2.sh > $ai3_path
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username
exit

#part3
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
