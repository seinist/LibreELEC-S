# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="snes9x"
PKG_VERSION="fb93aedd612537e233c6872a5d7ebe65e8169ade"
PKG_SHA256="a9d1d690850375e2720597daa763d0e6644c4d20cc2eee0d0d4ec07d3497bdcd"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/libretro/snes9x"
PKG_URL="https://github.com/libretro/snes9x/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Snes9x - Portable Super Nintendo Entertainment System (TM) emulator"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="snes9x_libretro.so"
PKG_LIBPATH="libretro/${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="-C libretro GIT_VERSION=${PKG_VERSION:0:7}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
