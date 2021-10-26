# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="virtualjaguar"
PKG_VERSION="390c44ddd22657cec3757ffe260a10ad88416726"
PKG_SHA256="60c42becc7bc7bbc61ea74e0e0c6f1ac971da21f219443f9b38a5296e4cf9e52"
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
