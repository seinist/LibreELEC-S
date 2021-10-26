# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="libvorbis-system"
PKG_VERSION="1.3.7"
PKG_SHA256="b33cc4934322bcbf6efcbacf49e3ca01aadbea4114ec9589d1b1e9d20f72954b"
PKG_LICENSE="BSD"
PKG_SITE="http://www.vorbis.com/"
PKG_URL="http://downloads.xiph.org/releases/vorbis/libvorbis-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libogg-system"
PKG_LONGDESC="Lossless audio compression tools using the ogg-vorbis algorithms."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--with-ogg=${SYSROOT_PREFIX}/usr \
                           --disable-docs \
                           --disable-examples \
                           --disable-oggtest"
