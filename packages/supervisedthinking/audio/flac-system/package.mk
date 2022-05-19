# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="flac-system"
PKG_VERSION="1.3.3"
PKG_SHA256="213e82bd716c9de6db2f98bcadbc4c24c7e2efe8c75939a1a84e28539c4e1748"
PKG_LICENSE="GFDL-1.2"
PKG_SITE="https://xiph.org/flac/"
PKG_URL="http://downloads.xiph.org/releases/flac/flac-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libogg-system"
PKG_LONGDESC="An Free Lossless Audio Codec."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

if [ "${TARGET_ARCH}" = "x86_64" ]; then
  PKG_DEPENDS_TARGET+=" nasm:host"
fi

pre_configure_target() {
  PKG_CONFIGURE_OPTS_TARGET="--disable-rpath \
                             --disable-altivec \
                             --disable-doxygen-docs \
                             --disable-thorough-tests \
                             --disable-cpplibs \
                             --disable-xmms-plugin \
                             --disable-oggtest \
                             --with-ogg=${SYSROOT_PREFIX}/usr \
                             --with-gnu-ld"

  if target_has_feature sse; then
    PKG_CONFIGURE_OPTS_TARGET+=" --enable-sse"
  else
    PKG_CONFIGURE_OPTS_TARGET+=" --disable-sse"
  fi
}

post_makeinstall_target() {
  safe_remove ${INSTALL}/usr/bin
}
