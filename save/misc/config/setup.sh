#!/bin/sh

FILE="/tmp/out.$$"
GREP="/bin/grep"

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "********************************"
   echo "This script MUST be run as root\!"
   echo "********************************"
   exit 1
fi


echo "*****************************************************************************"
echo "Connect to WiFi before running this script, else Firewall settings will fail!"
echo "*****************************************************************************"

MOUNT_USB=/mnt/sdb1
ROOT=$MOUNT/porteus/save/misc
USER_HOME=/home/guest
PERM=644
PERM_DIR=755
USER_NAME=guest

# Audio setup
cp $ROOT/config/asoundrc /etc/asound.conf
cp $ROOT/config/asoundrc $USER_HOME/.asoundrc
chmod $PERM $USER_HOME/.asoundrc
/etc/rc.d/rc.alsa restart
echo "Audio setup done!"
echo

# sudo setup
cp /etc/sudoers /etc/sudoers.bak
echo 'guest ALL = (ALL)ALL' >> /etc/sudoers
echo "sudo setup done!"
echo

# setup desktop

USER_FILE=/usr/share/applications/google-chrome.desktop
cp $ROOT/config/google-chrome.desktop $USER_FILE
chmod -R $PERM $USER_FILE

USER_DIR=$USER_HOME/.themes
USER_FILE=$ROOT/config/themes.tar.gz
mkdir -p $USER_DIR
tar -xzf $USER_FILE -C $USER_DIR
chown -R $USER_NAME $USER_DIR
chmod -R $PERM_DIR $USER_DIR

USER_DIR=$USER_HOME/.icons
USER_FILE=$ROOT/config/icons.tar.gz
mkdir -p $USER_DIR
tar -xzf $USER_FILE -C $USER_DIR
chown -R $USER_NAME $USER_DIR
chmod -R $PERM_DIR $USER_DIR

USER_DIR=$USER_HOME/.config/fontconfig
USER_FILE=$USER_HOME/.config/fontconfig/fonts.conf
mkdir -p $USER_DIR
cp $ROOT/config/fontconfig/fonts.conf $USER_FILE
chown -R $USER_NAME $USER_DIR
chmod -R $PERM_DIR $USER_DIR
chmod -R $PERM $USER_FILE

USER_FILE=$USER_HOME/.config/lxqt/lxqt.conf
cp $ROOT/config/lxqt/lxqt.conf $USER_FILE
chown -R $USER_NAME $USER_FILE
chmod $PERM $USER_FILE

USER_FILE=$USER_HOME/.config/lxqt/panel.conf
cp $ROOT/config/lxqt/panel.conf $USER_FILE
chown -R $USER_NAME $USER_FILE
chmod $PERM $USER_FILE

USER_FILE=$USER_HOME/.config/lxterminal/lxterminal.conf
cp $ROOT/config/lxterminal/lxterminal.conf $USER_FILE
chown -R $USER_NAME $USER_FILE
chmod $PERM $USER_FILE

USER_FILE=$USER_HOME/.config/leafpad/leafpadrc
USER_DIR=$USER_HOME/.config/leafpad
mkdir -p $USER_DIR
cp $ROOT/config/leafpad/leafpadrc $USER_FILE
chown -R $USER_NAME $USER_DIR
chmod -R $PERM_DIR $USER_DIR
chmod -R $PERM $USER_FILE

USER_FILE=$USER_HOME/.config/openbox/rc.xml
USER_DIR=$USER_HOME/.config/openbox
mkdir -p $USER_DIR
cp $ROOT/config/openbox/rc.xml $USER_FILE
chown -R $USER_NAME $USER_DIR
chmod -R $PERM_DIR $USER_DIR
chmod -R $PERM $USER_FILE


USER_FILE=$USER_HOME/.config/pcmanfm-qt/lxqt/settings.conf
cp $ROOT/config/pcmanfm-qt/lxqt/settings.conf $USER_FILE
chown -R $USER_NAME $USER_FILE
chmod $PERM $USER_FILE

USER_FILE=$USER_HOME/.config/Trolltech.conf
cp $ROOT/config/Trolltech.conf $USER_FILE
chown -R $USER_NAME $USER_FILE
chmod $PERM $USER_FILE


USER_DIR=$USER_HOME/.qt
USER_FILE=$USER_HOME/.qt/qtrc
mkdir -p $USER_DIR
chown -R $USER_NAME $USER_DIR
chmod -R $PERM_DIR $USER_DIR
cp $ROOT/config/qt/qtrc $USER_FILE
chown -R $USER_NAME $USER_FILE
chmod $PERM $USER_FILE

# Remove clipboard etc. from autostarting
rm -rf $USER_HOME/.config/autostart/*

echo "Environment setup done!"
echo

# Network settings
hostname porteus-ani

# Doesn't work for now
#USER_FILE=/etc/NetworkManager/system-connections/Hells_Pass_Upper
#cp $ROOT/config/system_connections/Hells_Pass_Upper $USER_FILE
#chmod $PERM $USER_FILE

#Wifi - doesn't work for now
#cp $ROOT/config/wpa_supplicant.conf /etc/wpa_supplicant.conf
#wpa_supplicant -Dwext -iwlan0 -c /etc/wpa_supplicant.conf > /dev/null 2>&1

# Firewall
chmod a+x /etc/rc.d/rc.FireWall
/etc/rc.d/rc.FireWall start

echo "Netowrk settings done!"
echo

MOUNT_HDD=/mnt/sda1
if [ -d "$MOUNT_HDD" ]; then
  umount $MOUNT_HDD
fi

# need to logout and log back in for changes to be effective
echo "All done! Please logout and log back in as 'guest' for changes to be effective"
echo
