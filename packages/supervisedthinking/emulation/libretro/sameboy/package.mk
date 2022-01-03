# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="sameboy"
PKG_VERSION="b154b7d3d885a3cf31203f0b8f50d3b37c8b742b"
PKG_SHA256="a8728627d7343abc097d74ff0a0f7ad6ebb5d5b70aba1f7ff81b73ce8f192806"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/SameBoy"
PKG_URL="https://github.com/libretro/SameBoy/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Gameboy and Gameboy Color emulator written in C"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="sameboy_libretro.so"
PKG_LIBPATH="libretro/${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET=" -C libretro GIT_VERSION=${PKG_VERSION:0:7}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
