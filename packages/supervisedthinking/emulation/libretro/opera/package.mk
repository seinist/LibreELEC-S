# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="opera"
PKG_VERSION="7369aa80f2e965036f705a311e5d5f30ab98cc14"
PKG_SHA256="8b4d50ace3afc277ea727ad81bd689797bbe76ee6eea8bf86063fb94b4c56619"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/opera-libretro"
PKG_URL="https://github.com/libretro/opera-libretro/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain glibc"
PKG_LONGDESC="Port of 4DO/libfreedo to libretro."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="opera_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="GIT_VERSION=${PKG_VERSION:0:7}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
