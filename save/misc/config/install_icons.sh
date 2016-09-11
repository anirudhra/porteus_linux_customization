#!/bin/bash
# Installation script for Faenza icon themes
# Written by Tiheum (matthieu.james@gmail.com)
# Modified by Anirudh Acharya for Porteus installation

ROOT_UID=0

DIR="$( cd -P "$( dirname "$0" )" && pwd )"
cd $DIR

tar xf Faenza.tar.gz 2>/dev/null
tar xf Faenza-Dark.tar.gz 2>/dev/null
tar xf Faenza-Mint.tar.gz 2>/dev/null
tar xf Faenza-Black.tar.gz 2>/dev/null

echo
distro="${input:-$distro}"
distributor="slackware"

iconname="distributor-logo-$distributor"
cd ./Faenza/places/scalable/ && ln -sf ./$iconname.svg distributor-logo.svg && cd ../../..
for size in 48 32 24 22; do
	cd ./Faenza/places/$size/ && ln -sf ./$iconname.png distributor-logo.png && cd ../../..
done

echo
iconname="start-here-$distributor"
for theme in Faenza Faenza-Dark; do
	cd ./$theme/places/scalable/ && ln -sf ./$iconname.svg start-here.svg && ln -sf ./$iconname-symbolic.svg start-here-symbolic.svg && cd ../../..
	for size in 48 32 24 22; do
		cd ./$theme/places/$size/ && ln -sf ./$iconname.png start-here.png && cd ../../..
	done
done

rm -Rf /usr/share/icons/Faenza 2>/dev/null; rm -Rf /usr/share/icons/Faenza-Dark 2>/dev/null; rm -Rf /usr/share/icons/Faenza-Darker 2>/dev/null; rm -Rf /usr/share/icons/Faenza-Darkest 2>/dev/null; rm -Rf /usr/share/icons/Faenza-Ambiance 2>/dev/null; rm -Rf /usr/share/icons/Faenza-Radiance 2>/dev/null
cp -R ./Faenza/ /usr/share/icons/
cp -R ./Faenza-Dark/ /usr/share/icons/
cp -R ./Faenza-Black/ /usr/share/icons/
cp -R ./Faenza-Mint/ /usr/share/icons/
install_dir=/usr/share/icons/

current_dir=$(pwd)
for theme in Faenza Faenza-Dark
do
	cd $install_dir/$theme/apps/22
	ln -sf $install_dir/$theme/status/22/covergloobus-panel.png ./covergloobus.png
	ln -sf $install_dir/$theme/status/22/deluge-panel.png ./deluge.png
	ln -sf $install_dir/$theme/status/22/exaile-panel.png ./exaile.png
	ln -sf $install_dir/$theme/status/22/fusion-icon-symbolic.png ./fusion-icon.png
	ln -sf $install_dir/$theme/status/22/gnome-do-panel.png ./gnome-do.png
	ln -sf $install_dir/$theme/status/22/ibus-panel.png ./ibus.png
	ln -sf $install_dir/$theme/status/22/kupfer-panel.png ./kupfer.png
	ln -sf $install_dir/$theme/status/22/me-tv-panel.png ./me-tv.png
	ln -sf $install_dir/$theme/status/22/zim-panel.png ./zim.png
done
cd $current_dir

dir="/usr/lib/rhythmbox/plugins/audioscrobbler"
if [ -e $dir/as-icon.png ]
then
	mv -n $dir/as-icon.png $dir/as-icon.default.png 2>/dev/null
	ln -sf /usr/share/icons/Faenza/apps/22/lastfm-audioscrobbler.png $dir/as-icon.png 2>/dev/null
fi
dir="/usr/lib/rhythmbox/plugins/umusicstore"
if [ -e $dir/musicstore_icon.png ]
then
	mv -n $dir/musicstore_icon.png $dir/musicstore_icon.default.png 2>/dev/null
	ln -sf /usr/share/icons/Faenza/apps/22/umusicstore.png $dir/musicstore_icon.png 2>/dev/null
fi
dir="/usr/share/dockmanager/data"
for file in skype_away skype_dnd skype_invisible skype_na skype_offline skype_online skype_skypeme
do 
	if [ -e $dir/$file.svg ]
	then
		mv -n $dir/$file.svg $dir/$file.default.svg 2>/dev/null
		ln -sf /usr/share/icons/Faenza/status/scalable/$file.svg $dir/$file.svg 2>/dev/null
	fi
done

echo
echo "Icon Installation complete!"
exit 0
