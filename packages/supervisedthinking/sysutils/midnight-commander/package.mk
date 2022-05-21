# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="midnight-commander"
PKG_VERSION="4.8.27"
PKG_SHA256="3bab1460d187e1f09409be4bb8550ea7dab125fb9b50036a8dbd2b16e8b1985b"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="http://www.midnight-commander.org"
PKG_URL="https://github.com/MidnightCommander/mc/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain gettext:host glib libssh2-system libtool:host ncurses pcre"
PKG_LONGDESC="GNU Midnight Commander (also referred to as MC) is a user shell with text-mode full-screen interface."
PKG_TOOLCHAIN="configure"

pre_configure_target() {
  PKG_CONFIGURE_OPTS_TARGET="--enable-silent-rules \
                             --datadir=/usr/share \
                             --libexecdir=/usr/lib \
                             --sysconfdir=/etc \
                             --with-screen=ncurses \
                             --with-sysroot=${SYSROOT_PREFIX} \
                             --disable-aspell \
                             --without-diff-viewer \
                             --disable-doxygen-doc \
                             --disable-doxygen-dot \
                             --disable-doxygen-html \
                             --with-gnu-ld \
                             --without-libiconv-prefix \
                             --without-libintl-prefix \
                             --with-internal-edit \
                             --disable-mclib \
                             --with-subshell \
                             --enable-vfs-extfs \
                             --enable-vfs-ftp \
                             --enable-vfs-sftp \
                             --enable-vfs-tar \
                             --without-x"

  LDFLAGS+=" -lcrypto -lssl"

  ${PKG_BUILD}/autogen.sh

  # fix Midnight-Commander version
  sed -e "s/MC_CURRENT_VERSION \"unknown\"/MC_CURRENT_VERSION \"${PKG_VERSION}\"/" -i ${PKG_BUILD}/mc-version.h
}

post_makeinstall_target() {
  safe_remove ${INSTALL}/usr/share/mc/help/mc.hlp.*
  mv ${INSTALL}/usr/bin/mc ${INSTALL}/usr/bin/mc-bin
  safe_remove ${INSTALL}/usr/bin/{mcedit,mcview}
  cp ${PKG_DIR}/wrapper/* ${INSTALL}/usr/bin
}
