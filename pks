# very basic and mostly necessary packages

base base-devel linux linux-docs linux-headers linux-firmware linux-tools-meta nano man-db man-pages texinfo dialog dhcpcd dnsmasq wpa_supplicant efibootmgr intel-ucode

# xorg drivers, vulkan, hardware video acceleration

xorg xf86-input-libinput xf86-video-amdgpu mesa lib32-mesa intel-media-driver libva-intel-driver lib32-libva-intel-driver libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau libva-vdpau-driver lib32-libva-vdpau-driver libvdpau-va-gl vulkan-icd-loader lib32-vulkan-icd-loader vulkan-intel lib32-vulkan-intel vulkan-radeon lib32-vulkan-radeon amdvlk lib32-amdvlk

# multimedia codecs and libraries

ffmpeg gst-libav gst-plugins-base lib32-gst-plugins-base gst-plugins-good lib32-gst-plugins-good gst-plugins-bad gst-plugins-ugly libde265 gstreamer-vaapi

# fonts

bdf-unifont ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-liberation ttf-droid gnu-free-fonts ttf-linux-libertine noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-roboto ttf-ubuntu-font-family ttf-opensans cantarell-fonts inter-font wqy-microhei wqy-zenhei wqy-bitmapfont otf-ipafont

# zsh

zsh zsh-doc grml-zsh-config zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting zsh-lovers zsh-theme-powerlevel10k powerline

# desktop (KDE Plasma)

plasma-meta kde-applications-meta packagekit-qt5 fwupd hunspell hunspell-en_US xdg-user-dirs xdg-desktop-portal xdg-desktop-portal-kde libappindicator-gtk2 libappindicator-gtk3 lib32-libappindicator-gtk2 lib32-libappindicator-gtk3 appmenu-gtk-module

# other applications

firefox reflector pacman-contrib pkgstats pkgfile neofetch htop git make cmake android-tools android-file-transfer mtpfs cpupower haveged
