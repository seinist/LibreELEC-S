# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="spotify"
PKG_VERSION="1.0.3"
PKG_ARCH="x86_64"
PKG_LICENSE="Freeware"
PKG_SITE="http://www.spotify.com"
PKG_DEPENDS_TARGET="toolchain glibc glib zlib alsa-lib atk pango gdk-pixbuf cairo gtk3-system libX11 libXext libICE libSM openssl libcurl-gnutls freetype zlib unclutter-xfixes"
PKG_LONGDESC="A proprietary music streaming service"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  # Creating directories  
  mkdir -p ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/opt/spotify

  # Copy scripts, config files & resources
  cp -v ${PKG_DIR}/files/DefaultAddonMusicSpotify.png ${INSTALL}/opt/spotify/
  cp -rfv ${PKG_DIR}/scripts/*                        ${INSTALL}/usr/bin/
}
