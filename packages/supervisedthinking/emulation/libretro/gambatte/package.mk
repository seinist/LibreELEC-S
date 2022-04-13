# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="gambatte"
PKG_VERSION="15536214cdce31894d374b2ffa2494543057082b"
PKG_SHA256="ca24eababf0b4cbdc1a10d9d3ecf2c3348b9b257fc87d8dfebd1e8d4000ee32e"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/gambatte-libretro"
PKG_URL="https://github.com/libretro/gambatte-libretro/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Gambatte is an accuracy-focused, open-source, cross-platform Game Boy Color emulator written in C++."
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="gambatte_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
