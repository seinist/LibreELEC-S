# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="soundfont-generaluser"
PKG_VERSION="1.471"
PKG_SHA256="4203835164766f428c4926c097c9ea58dae431c7fb8f9dbe277b92d80da45ec2"
PKG_LICENSE="GUGSL-2.0.txt"
PKG_SITE="http://www.schristiancollins.com/generaluser.php"
PKG_URL="https://www.dropbox.com/s/4x27l49kxcwamp5/GeneralUser_GS_${PKG_VERSION}.zip"
PKG_SOURCE_DIR="GeneralUser*"
PKG_DEPENDS_TARGET=""
PKG_LONGDESC="GeneralUser GS is a GM and GS compatible SoundFont bank for composing, playing MIDI files, and retro gaming."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/config/soundfonts
  mkdir -p ${INSTALL}/usr/share/soundfonts
    cp -v GeneralUser*${PKG_VERSION}.sf2 ${INSTALL}/usr/share/soundfonts/GeneralUser.sf2
    ln -sf /usr/share/soundfonts/GeneralUser.sf2 ${INSTALL}/usr/config/soundfonts/
}
