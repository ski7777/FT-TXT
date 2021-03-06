#!/bin/sh

set -x

TARGETDIR=$1
echo ">>>$TARGETDIR<<<"

# Update build number
BUILD=`cat ../FT-TXT/board/FT/TXT/BUILD`
BUILDDATE=`date +"%Y-%m-%d %H:%M"`
BUILD=$((BUILD+1))
echo $BUILD > ../FT-TXT/board/FT/TXT/BUILD

# Fix access rights in rootfs source
chmod 600  ../FT-TXT/board/FT/TXT/rootfs/root/.ssh/id*

# Update rootfs in $TARGETDIR from ../FT-TXT/board/FT/TXT/rootfs
rm -rf $TARGETDIR/etc/sudoers
cp -a ../FT-TXT/board/FT/TXT/rootfs/* $TARGETDIR/

# Local support seems to be no longer required by TxtControl
# All references to locale.h, libintl.h, /usr/lib/local are commented out => remove this completely
# cp -v output/staging/usr/bin/locale $TARGETDIR/usr/bin/
# mkdir -p $TARGETDIR/usr/share/i18n
# cp -a output/staging/usr/share/i18n/* $TARGETDIR/usr/share/i18n

# right time zones are not used (all links are to posix) => remove unused time zones
rm -rf $TARGETDIR/usr/share/zoneinfo/right

# Copy fonts
# TODO: fix this such that this works with fontconfig
# Instead of copying the fonts to /usr/lib, create a symlink
ln -s $TARGETDIR/usr/share/fonts/ $TARGETDIR/usr/lib/fonts

# Copy boot loader files
cp $BINARIES_DIR/uImage $TARGETDIR/lib/boot
cp $BINARIES_DIR/am335x-kno_txt.dtb $TARGETDIR/lib/boot

# Set buil dinfo
echo "fischertechnik TXT Rel 2.0 Build $BUILD ($BUILDDATE)" > $TARGETDIR/etc/BUILD

# mkdir ROBOProFiles
mkdir $TARGETDIR/opt/knobloch/ROBOProFiles
chmod 775 $TARGETDIR/opt/knobloch/ROBOProFiles
