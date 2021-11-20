# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="mesen"
PKG_VERSION="1.0.0"
PKG_SHA256="e7828ce179cb7ca9657a065dbb09be0b71036cd76fc6f7a743938ffb1a9afae9"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/NovaSquirrel/Mesen-X"
PKG_URL="https://github.com/NovaSquirrel/Mesen-X/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Mesen is a cross-platform (Windows & Linux) NES/Famicom emulator built in C++ and C#"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="mesen_libretro.so"
PKG_LIBPATH="Libretro/${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="-C Libretro"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
