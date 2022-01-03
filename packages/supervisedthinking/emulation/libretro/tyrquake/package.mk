# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="tyrquake"
PKG_VERSION="423a217d7ef0f913bc711dc9fceff707196c0f2f"
PKG_SHA256="0db39ba41e321b843f436b9b0184bc1b74b853948307f827dcc54a5043c09249"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/libretro/tyrquake"
PKG_URL="https://github.com/libretro/tyrquake/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Libretro port of Tyrquake (Quake 1 engine)"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="tyrquake_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="GIT_VERSION=${PKG_VERSION:0:7}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
