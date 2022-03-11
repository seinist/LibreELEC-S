# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="snes9x"
PKG_VERSION="361f073be2b1d01a1fe592c2980790f20f1d80f6"
PKG_SHA256="618417913acaa1ce8b452ee70c3728e1d106eaa75028ec8fc5d033b9a211f670"
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
