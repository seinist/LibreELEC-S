# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="x264-system"
PKG_VERSION="19856cc41ad11e434549fb3cc6a019e645ce1efe"
PKG_SHA256="538cc74de318e352ec5836d5948464789a65db5e05e3f8c591d82461ffcf907b"
PKG_LICENSE="GPL-1.0-or-later"
PKG_SITE="http://www.videolan.org/developers/x264.html"
PKG_URL="https://code.videolan.org/videolan/x264/-/archive/master/x264-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="x264, the best and fastest H.264 encoder"

if [ "${TARGET_ARCH}" = "x86_64" ]; then
  PKG_DEPENDS_TARGET+=" nasm:host"
fi

pre_configure_target() {
  cd ${PKG_BUILD}
  safe_remove .${TARGET_NAME}

  if [ "${TARGET_ARCH}" = "x86_64" ]; then
    export AS="${TOOLCHAIN}/bin/nasm"
    PKG_X264_LTO="--enable-lto"
  else
    PKG_X264_ASM="--disable-asm"
  fi
}

configure_target() {
  ./configure \
    --cross-prefix="${TARGET_PREFIX}" \
    --extra-cflags="${CFLAGS}" \
    --extra-ldflags="${LDFLAGS}" \
    --host="${TARGET_NAME}" \
    --prefix="/usr" \
    --sysroot="${SYSROOT_PREFIX}" \
    ${PKG_X264_ASM} \
    --disable-cli \
    ${PKG_X264_LTO} \
    --enable-pic \
    --enable-static \
    --enable-strip
}
