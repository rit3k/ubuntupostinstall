#!/bin/bash
#
# GPL
#
# Syntax: # sudo ./ubuntu-12.04-WS.sh
#
#Inspiration Nicolargo & Pierre CLÉMENT
VERSION="0.1"

dpkg -l > /tmp/pkg-before.txt

#=============================================================================
# Application list to install:
# (en vrac a l'occaz : virtualbox virtualbox-guest-additions xchat pidgin verbiste bluefish easystroke darktable imagemagick..
# nautilus-image-converter conky unace unrar zip unzip openshot compizconfig-settings-manager lsb-core(pour google earth) 
# Jupiter (a must have for Laptop) flashplugin-downloader (32bit) gmic gimp-gmic picard geany sublime-text-2-beta
# See further for applications that requires specific repository
# Restricted extra
LIST=" ubuntu-restricted-extras p7zip-full p7zip-rar"
# Developpement
LIST=$LIST" vim git-core oracle-java7-installer"
# Multimedia
LIST=$LIST" spotify-client-qt ffmpeg vlc shutter vlc x264 istanbul gimp gimp-plugin-registry arista mypaint libdvdread4"
# Network
LIST=$LIST" terminator gparted lm-sensors"
# System
LIST=$LIST" curl htop terminator compizconfig-settings-manager hardinfo most tree"
# Web
LIST=$LIST" google-chrome-stable ttf-mscorefonts-installer nautilus-dropbox filezilla"
#=============================================================================

# Application list to remove: adapt it to your needs
# Internet
REMOVE_LIST=""
# Internet
REMOVE_LIST=$REMOVE_LIST"transmission-common"
# Multimedia 
REMOVE_LIST=$REMOVE_LIST""
# Games 
REMOVE_LIST=$REMOVE_LIST" gnome-games-common gbrainy aisleriot"


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

# Shutter screen capture
$ADDAPT ppa:shutter

# Oracle Java
$ADDAPT ppa:webupd8team/java

# Jupiter (a must have for Laptop)
#$ADDAPT ppa:webupd8team/jupiter

# Sublime text 2 (sublime but not FOSS and beta and huge price and mono :()
$ADDAPT ppa:webupd8team/sublime-text-2

# Google Chrome
egrep '^deb\ .*chrome' /etc/apt/sources.list > /dev/null
if [ $? -ne 0 ]
then
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
        echo "## Google Chrome" >> /etc/apt/sources.list
        echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list
fi

# Dropbox
egrep '^deb\ .*dropbox' /etc/apt/sources.list > /dev/null
if [ $? -ne 0 ]
then
        apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
        echo "## Dropbox" >> /etc/apt/sources.list
        echo "deb http://linux.dropbox.com/ubuntu precise main" >> /etc/apt/sources.list
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
#egrep '^deb\ .*virtualbox' /etc/apt/sources.list > /dev/null
#if [ $? -ne 0 ]
#then
#        wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | apt-key add -
#        echo "## VirtualBox" >> /etc/apt/sources.list
#        echo "deb http://download.virtualbox.org/virtualbox/debian oneiric contrib" >> /etc/apt/sources.list
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


fi

# Others
########


#Dropbox 64 bit (https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.4.0_amd64.deb) verifier !!
#cd ~ && wget -O - "http://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
#cd ~ && wget -O - "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.4.0_amd64.deb" | 

# Vimrc
#curl -o .vimrc https://bitbucket.org/Pierrecle/configs/raw/default/vimrc

# Bashrc
#curl -o .bashrc https://bitbucket.org/Pierrecle/configs/raw/default/bashrc

# Gnome-terminal
#wget https://bitbucket.org/Pierrecle/configs/raw/default/GConfTool2/gnome-terminal.xml
#gconftool-2 --load gnome-terminal.xml
#rm gnome-terminal.xml

# Sublime Text 2 config
#if [[ "$LIST" == *"sublime-text-2"* ]]
#then
#        wget -O ~/.config/sublime-text-2/Packages/Default/Preferences.sublime-settings https://bitbucket.org/Pierrecle/configs/raw/default/SublimeText2/Preferences.sublime-settings

fi

dpkg -l > /tmp/pkg-after.txt

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
echo "Pour lancer finir l'installation de dropxbox ~/.dropbox-dist/dropboxd"
echo ""
echo "To change the login image, change the line \"background=...\" in /etc/lightdm/unity-greeter.conf"
echo ""
echo "Press Enter to relaunch your session"
read ANSWER
service lightdm restart


#
#http://gmic.sourceforge.net/gimp.shtml
#http://www.sublimetext.com/2
# Manually downloaded softwares
#
# Firefox extensions
#
# Chrome extensions

# Script end
#-----------
