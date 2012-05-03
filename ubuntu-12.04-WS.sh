#!/bin/bash
#
# GPL
#
# Syntax: # sudo ./ubuntu-12.04-WS.sh
#
#Inspiration Nicolargo & Pierre CLÉMENT
VERSION="0.1"

#=============================================================================
# Application list to install: adapt it to your needs
# See further for applications that requires specific repository
LIST="virtualbox virtualbox-guest-additions nautilus-dropbox"
# Developpement
LIST=$LIST" vim subversion git sublime-text-2 rabbitvcs-nautilus3 oracle-java7-installer"
# Multimedia
LIST=$LIST" spotify-client-qt ffmpeg vlc mkvtoolnix mkvtoolnix-gui python-glade2 python-vte gettext mkv-extractor-gui darktable"
# Network
LIST=$LIST" "
# System
LIST=$LIST" curl htop"
# Web
LIST=$LIST" google-chrome-stable ttf-mscorefonts-installer"
#=============================================================================
# Application list to remove: adapt it to your needs
# Internet
REMOVE_LIST="tomboy"
# Internet
REMOVE_LIST=$REMOVE_LIST" firefox-locale-en thunderbird transmission-common"
# Multimedia 
REMOVE_LIST=$REMOVE_LIST" banshee totem-common shotwell"
# Games 
REMOVE_LIST=$REMOVE_LIST" gnome-games-common gbrainy aisleriot"
# LibreOffice 
REMOVE_LIST=$REMOVE_LIST" libreoffice-common"

# Test que le script est lance en root
if [ $EUID -ne 0 ]; then
  echo "This script has to be run with root permissions: # sudo $0" 1>&2
  exit 1
fi

ADDAPT="add-apt-repository -y"

# Ajout des depots
#-----------------

UBUNTUVERSION=`lsb_release -cs`
echo "Adding repositories for Ubuntu $UBUNTUVERSION"

# Restricted extra
# The Ubuntu Restricted Extras will install Adobe Flash Player, Java Runtime Environment (JRE) (sun-java-jre) with Firefox plug-ins (icedtea), a set of Microsoft Fonts (msttcorefonts), multimedia codecs (w32codecs or w64codecs), mp3-compatible encoding (lame), FFMpeg, extra Gstreamer codecs, the package for DVD decoding (libdvdread4, but see below for info on libdvdcss2), the unrar archiver, odbc, and cabextract. It also installs multiple "stripped" codecs and avutils (libavcodec-unstripped-52 and libavutil-unstripped-49).
LIST=$LIST" ubuntu-restricted-extras"

# Latest NVidia GPU driver
#$ADDAPT ppa:ubuntu-x-swat/x-updates

# VLC
#$ADDAPT ppa:videolan/stable-daily

# Sublime text 2
$ADDAPT ppa:webupd8team/sublime-text-2

# RabbitVCS
$ADDAPT ppa:rabbitvcs/ppa

# MKVExtractor GUI
$ADDAPT ppa:hizo/logiciels

# Darktable
$ADDAPT ppa:pmjdebruijn/darktable-release-plus

# Oracle Java
$ADDAPT ppa:webupd8team/java

# Wine
$ADDAPT ppa:ubuntu-wine/ppa

# Gimp
$ADDAPT ppa:otto-kesselgulasch/gimp

# Google Chrome
egrep '^deb\ .*chrome' /etc/apt/sources.list > /dev/null
if [ $? -ne 0 ]
then
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
        echo "## Google Chrome" >> /etc/apt/sources.list
        echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list
fi

# MKVToolnix
egrep '^deb\ .*bunkus' /etc/apt/sources.list > /dev/null
if [ $? -ne 0 ]
then
        wget -q -O - http://www.bunkus.org/gpg-pub-moritzbunkus.txt | apt-key add -
        echo "## MKVToolnix" >> /etc/apt/sources.list
        echo "deb http://www.bunkus.org/ubuntu/oneiric/ ./" >> /etc/apt/sources.list
fi

# Dropbox
egrep '^deb\ .*dropbox' /etc/apt/sources.list > /dev/null
if [ $? -ne 0 ]
then
        apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
        echo "## Dropbox" >> /etc/apt/sources.list
        echo "deb http://linux.dropbox.com/ubuntu oneiric main" >> /etc/apt/sources.list
fi

# Spotify
egrep '^deb\ .*spotify' /etc/apt/sources.list > /dev/null
if [ $? -ne 0 ]
then
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4E9CFF4E
        echo "## Spotify" >> /etc/apt/sources.list
        echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list
fi

# Virtual box
egrep '^deb\ .*virtualbox' /etc/apt/sources.list > /dev/null
if [ $? -ne 0 ]
then
        wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | apt-key add -
        echo "## VirtualBox" >> /etc/apt/sources.list
        echo "deb http://download.virtualbox.org/virtualbox/debian oneiric contrib" >> /etc/apt/sources.list
fi

# Update
#-------

echo "Updating repositories list"
apt-get update

# Remove
#-------

echo "Removing following softwares: $REMOVE_LIST"
apt-get autoremove $REMOVE_LIST

# Upgrade
#-------

echo "Updating system"
apt-get upgrade

# Additionnals installs
#----------------------

echo "Installing following softwares: $LIST"
apt-get install $LIST

# Gnome Shell
#############
if [[ "$LIST" == *"gnome-shell"* ]]
then
        THEME_SHELL="Faience"
        THEME_ICONES="Faenza"
        THEME_WINDOW="Boomerang Deux"
        THEME_GTK=$THEME_WINDOW
        THEME_CURSOR="Adwaita"

        # Gnome Shell Install icons
        apt-get install faenza-icon-theme faenza-icons-mono
        mkdir $HOME/.icons
        cd `mktemp -d`
        wget http://www.deviantart.com/download/255099649/faience_icon_theme_by_tiheum-d47vo5d.zip
        unzip faience_icon_theme_by_tiheum-d47vo5d.zip
        mv Faience* $HOME/.icons/
        rm -rf faience_icon_theme_by_tiheum-*.zip
        chown -R $SUDO_USER:$SUDO_USER $HOME/.icons
        cd

        # Gnome Shell themes
        mkdir $HOME/.themes
        cd `mktemp -d`
        # -- Faience
        wget http://www.deviantart.com/download/255097456/gnome_shell___faience_by_tiheum-d47vmgg.zip
        unzip gnome_shell___faience_by_tiheum-d47vmgg.zip
        mv Faience $HOME/.themes
        rm -rf gnome_shell___faience_by_tiheum-*.zip
        # -- Nord
        wget http://www.deviantart.com/download/214295138/gnome_shell__nord_by_0rax0-d3jl36q.zip
        unzip gnome_shell__nord_by_0rax0-d3jl36q.zip
        mv Nord ~/.themes
        rm -rf nord_by_0rax0-*.zip
        cd

        cd `mktemp -d`
        wget http://www.deviantart.com/download/189180645/boomerang_by_ghogaru-d34mspx.zip
        unzip boomerang_by_ghogaru-d34mspx.zip
        cd Boomerang_GTK_by_ghogaru
        tar zxvf Boomerang.tar.gz
        tar zxvf Boomerang\ Deux.tar.gz
        mv Boomerang Boomerang\ Deux /usr/share/themes/
        cd

        # Set perm for all the themes
        chown -R $SUDO_USER:$SUDO_USER $HOME/.themes

        # Set the theme shell, icons
        gsettings set org.gnome.shell enabled-extensions "user-theme@gnome-shell-extensions.gnome.org, noa11y@colemando.com, alternative-status-menu@gnome-shell-extensions.gnome.org, bottompanel@linuxmint.com, gnome-shell-classic-systray@emergya.com, windowlist@linuxmint.com, auto-move-windows@gnome-shell-extensions.gnome.org"
        gsettings set org.gnome.shell.extensions.user-theme name "$THEME_SHELL"
        gsettings set org.gnome.desktop.interface icon-theme "$THEME_ICONES"
        gsettings set org.gnome.desktop.interface gtk-theme "$THEME_GTK"
        gsettings set org.gnome.desktop.interface cursor-theme "$THEME_CURSOR"
        gconftool-2 -s -t string /desktop/gnome/shell/windows/theme "$THEME_WINDOW"
        gconftool-2 -s -t string /apps/metacity/general/theme "$THEME_WINDOW"

        # See the clock in the date
        gsettings set org.gnome.shell.clock show-date true

        # Hide Nautilus bar on the desktop
        gsettings set org.gnome.desktop.background show-desktop-icons false

        # Get the minimize and maximize button back in Gnome Shell
        gconftool-2 -s -t string /desktop/gnome/shell/windows/button_layout ':minimize,maximize,close'

        # Get classic dualscreen behavior back
        gconftool-2 --set /desktop/gnome/shell/windows/workspaces_only_on_primary -t boolean false

        # ALT-F2 get back to me 
        gconftool-2 --recursive-unset /apps/metacity/global_keybindings

        # Gnome-shell is the default shell
        # sed -i ‘s/user-session.*/user-session=Gnome/’ /etc/lightdm/lightdm.conf
        /usr/lib/lightdm/lightdm-set-defaults -s gnome-shell
fi

# Others
########

# Choose default editor
update-alternatives --config editor

# Vimrc
curl -o .vimrc https://bitbucket.org/Pierrecle/configs/raw/default/vimrc

# Bashrc
curl -o .bashrc https://bitbucket.org/Pierrecle/configs/raw/default/bashrc

# Gnome-terminal
wget https://bitbucket.org/Pierrecle/configs/raw/default/GConfTool2/gnome-terminal.xml
gconftool-2 --load gnome-terminal.xml
rm gnome-terminal.xml

# Sublime Text 2 config
if [[ "$LIST" == *"sublime-text-2"* ]]
then
        wget -O ~/.config/sublime-text-2/Packages/Default/Preferences.sublime-settings https://bitbucket.org/Pierrecle/configs/raw/default/SublimeText2/Preferences.sublime-settings
fi

# Login screen
cd /usr/share/backgrounds
wget -O BlueMoon.jpg http://www.desktopography.net/media/BAhbBlsHOgZmIjQyMDExLzExLzA2LzExXzAxXzA0Xzk1OV9CbHVlX01vb25fMTkyMHgxMjAwLmpwZw
wget -O YineanLaelia.jpg http://www.deviantart.com/download/175402912/yinean___laelia_by_senzune-d2wfhr4.jpg
wget http://www.deviantart.com/download/57695746/experiment_Wallpapers_by_petercui.zip
unzip experiment_Wallpapers_by_petercui.zip
rm -rf __MACOSX TREMS.rtf
wget http://www.deviantart.com/download/70704663/TRAVEL___experiment_Wall_2_by_petercui.zip
unzip TRAVEL___experiment_Wall_2_by_petercui.zip
mv Travel_Experiment\ 2/*.jpg ./
rm -rf __MACOSX/ Travel_Experiment\ 2/ TRAVEL___experiment_Wall_2_by_petercui.zip
echo "To change the login image, change the line \"background=...\" in /etc/lightdm/unity-greeter.conf" > README
LOGIN_IMG="/usr/share/backgrounds/Experiment Wall_1.jpg"
LOGIN_IMG="${LOGIN_IMG//\//\\/}"
sed -i "s/background=.*$/background=$LOGIN_IMG/" /etc/lightdm/unity-greeter.conf
chmod 644 *
cd

# example.desktop
if [ -e "example.desktop" ]
then
        rm example.desktop
fi

# Restart Nautilus
nautilus -q
echo "========================================================================"
echo
echo "Removed softwares: $REMOVE_LIST"
echo
echo "========================================================================"
echo
echo "Installed softwares: $LIST"
echo
echo "========================================================================"
echo
echo "Your session has to be relaunched tocomplete the isntallation."
echo "Save and close every opened file."
echo "When your session will start, choose Gnome 3."
echo ""
echo "To change the login image, change the line \"background=...\" in /etc/lightdm/unity-greeter.conf"
echo ""
echo "Press Enter to relaunch your session"
read ANSWER
service lightdm restart


# Script end
#-----------
