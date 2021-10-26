# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="gstreamer"
PKG_VERSION="1.18.4"
PKG_SHA256="9aeec99b38e310817012aa2d1d76573b787af47f8a725a65b833880a094dfbc5"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://gstreamer.freedesktop.org"
PKG_URL="https://gstreamer.freedesktop.org/src/gstreamer/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="GStreamer open-source multimedia framework core library"

PKG_MESON_OPTS_TARGET="-Dlibunwind=disabled \
                       -Dgtk_doc=disabled \
                       -Dexamples=disabled \
                       -Dtests=disabled \
                       -Dnls=disabled"

post_makeinstall_target() {
  # clean up
  safe_remove ${INSTALL}/usr/share
}
