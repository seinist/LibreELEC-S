# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="superbroswar"
PKG_VERSION="724eac234429a3d284b220930f9519e0cafef84a"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/superbroswar-libretro"
PKG_URL="https://github.com/libretro/superbroswar-libretro.git"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="A fan-made multiplayer Super Mario Bros. style deathmatch game"
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="superbroswar_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="-f Makefile.libretro \
                      GIT_VERSION=${PKG_VERSION:0:7}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
    cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
