# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="fceumm"
PKG_VERSION="b3c35b6515b2b6a789c589f976a4a323ebebe3eb"
PKG_SHA256="6ae6816f4d6c6c765fd49ae2dad639d867d82781825535428565e43611649339"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/libretro-fceumm"
PKG_URL="https://github.com/libretro/libretro-fceumm/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Libretro port of the NES/Faimcom emulator FCE Ultra mappers mod project."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="fceumm_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="GIT_VERSION=${PKG_VERSION:0:7}"

pre_configure_target() {
  if [ "${ARCH}" = "arm" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=armv"
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
    cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
