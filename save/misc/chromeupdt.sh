#!/bin/sh

    PKGNAM=google-chrome
    RELEASE=${RELEASE:-stable}    # stable, beta, or unstable

    ARCH=${ARCH:-$(uname -m)}

    case "$ARCH" in
      i?86) DEBARCH="i386" ; LIBDIRSUFFIX="" ; ARCH=i386 ; GARCH=i386 ;;
      x86_64) DEBARCH="amd64" ; LIBDIRSUFFIX="64" ; ARCH=x86_64 ; 
GARCH=amd64 ;;
      *) echo "Package for $(uname -m) architecture is not available." ; 
exit 1 ;;
    esac

    # Download latest version from Google servers
if [ ! -f google-chrome-stable_current_amd64.deb ]; then
    wget --no-check-certificate 
"https://dl.google.com/linux/direct/google-chrome-stable_current_$GARCH.deb"
fi

    # Get the version from the Debian/Ubuntu .deb (thanks to Fred 
Richards):
    VERSION=$(ar p google-chrome-${RELEASE}_current_${DEBARCH}.deb 
control.tar.gz 2> /dev/null | tar zxO ./control 2> /dev/null | grep 
Version | awk '{print $2}' | cut -d- -f1)
    BUILD=${BUILD:-1}


    if [ ! $UID = 0 ]; then
cat << EOF

    This script must be run as root.

EOF
      exit 1
    fi

    if ! /bin/ls google-chrome-*.deb 1> /dev/null 2> /dev/null ; then
cat << EOF

    This is a script to repackage a Debian/Ubuntu Google Chrome .deb 
package
    for Slackware.  Run this script in the same directory as one of 
these
    binary packages:

      google-chrome-stable_current_amd64.deb  (for 64-bit x86_64)
      google-chrome-stable_current_i386.deb   (for 32-bit x86)
     
    This will create a Slackware .txz package.  Install it with 
installpkg
    or use upgradepkg to upgrade from a previous version.

EOF
      exit 1
    fi

    CWD=$(pwd)
    TMP=${TMP:-/tmp}
    PKG=$TMP/package-$PKGNAM
    OUTPUT=${OUTPUT:-/tmp}

    rm -rf $PKG
    mkdir -p $TMP $PKG $OUTPUT
    cd $PKG
    ar p $CWD/google-chrome-${RELEASE}_current_${DEBARCH}.deb 
data.tar.lzma | lzma -d | tar xv || exit 1
    chown -R root:root .
    chmod -R u+w,go+r-w,a-s .

    # Make sure top-level perms are correct:
    chmod 0755 .
    # This needs to be setuid root:
    chmod 4711 opt/google/chrome/chrome-sandbox
    # The cron job is for Debian/Ubuntu only:
    rm -rf etc

    # Link to the standard Mozilla library names:
    sed -i 's,libnss3.so.1d,libnss3.so\x00\x00\x00,g;
            s,libnssutil3.so.1d,libnssutil3.so\x00\x00\x00,g;
            s,libsmime3.so.1d,libsmime3.so\x00\x00\x00,g;
            s,libssl3.so.1d,libssl3.so\x00\x00\x00,g;
            s,libplds4.so.0d,libplds4.so\x00\x00\x00,g;
            s,libplc4.so.0d,libplc4.so\x00\x00\x00,g;
            s,libnspr4.so.0d,libnspr4.so\x00\x00\x00,g;' 
opt/google/chrome/chrome

    # --mandir=/usr/man:
    mv $PKG/usr/share/man $PKG/usr/man
    # Compress manual pages:
    find $PKG/usr/man -type f -exec gzip -9 {} \;
    for i in $( find $PKG/usr/man -type l ) ; do
      ln -s $( readlink $i ).gz $i.gz
      rm $i
    done

    # Install a .desktop launcher:
    sed -i -e 
"s#Icon=google-chrome#Icon=/opt/google/chrome/product_logo_256.png#" \
      $PKG/opt/google/chrome/google-chrome.desktop
    mkdir -p $PKG/usr/share/applications
    cp -a $PKG/opt/google/chrome/google-chrome.desktop \
      $PKG/usr/share/applications/browser.desktop

    mkdir -p $PKG/install
    cat $CWD/slackbuild/slack-desc > $PKG/install/slack-desc

    cd $PKG
    /sbin/makepkg -l y -c n $OUTPUT/$PKGNAM-$VERSION-$ARCH-$BUILD.txz

#    if [ -f "$OUTPUT/$PKGNAM-$VERSION-$ARCH-$BUILD.txz" ]; then txz2xzm 
$OUTPUT/$PKGNAM-$VERSION-$ARCH-$BUILD.txz 
$OUTPUT/$PKGNAM-$VERSION-$ARCH-$BUILD.xzm; fi

#    rm -f $OUTPUT/$PKGNAM-$VERSION-$ARCH-$BUILD.txz

