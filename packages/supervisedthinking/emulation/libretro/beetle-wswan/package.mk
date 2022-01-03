# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="beetle-wswan"
PKG_VERSION="ea00c1d8eb9894538dd8758975cd9d6ae99ead1e"
PKG_SHA256="b61c5794aa89a18ef9dd5006b3964b7f9969d84060814a8e8f7df1b3de548395"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/beetle-wswan-libretro"
PKG_URL="https://github.com/libretro/beetle-wswan-libretro/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Standalone port of Mednafen WonderSwan to libretro, itself a fork of Cygne."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="mednafen_wswan_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="GIT_VERSION=${PKG_VERSION:0:7}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
