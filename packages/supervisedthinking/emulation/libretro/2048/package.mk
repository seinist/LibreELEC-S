# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="2048"
PKG_VERSION="20051e140346fb56376b59f41f28ef40f8ad7fb8"
PKG_SHA256="6cccc6ddefcd065b13aa01881ad82966eb5377657a97757c172c4e82f955780f"
PKG_LICENSE="Unlicense"
PKG_SITE="https://github.com/libretro/libretro-2048"
PKG_URL="https://github.com/libretro/libretro-2048/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Port of 2048 puzzle game to the libretro API."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="2048_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="-f Makefile.libretro GIT_VERSION=${PKG_VERSION:0:7}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/config/retroarch/playlists
  mkdir -p ${INSTALL}/usr/lib/libretro

  #create Retroarch Playlist
  cp ${PKG_DIR}/config/*   ${INSTALL}/usr/config/retroarch/playlists
  cp -v ${PKG_LIBPATH}    ${INSTALL}/usr/lib/libretro/
}
