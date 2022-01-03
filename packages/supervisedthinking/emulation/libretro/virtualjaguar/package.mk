# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="virtualjaguar"
PKG_VERSION="d1b1b28a6ad2518b746e3f7537ec6d66db96ec57"
PKG_SHA256="d36e265e3e1409cb54de3b72b055a35c465b9f8c4f2064e77ed2d784671eb89a"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/libretro/virtualjaguar-libretro"
PKG_URL="https://github.com/libretro/virtualjaguar-libretro/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain glibc"
PKG_LONGDESC="Port of Virtual Jaguar to Libretro"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-sysroot"

if [ ! "${ARCH}" = "arm" ]; then
 PKG_BUILD_FLAGS+=" +lto"
fi

PKG_LIBNAME="virtualjaguar_libretro.so"
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
