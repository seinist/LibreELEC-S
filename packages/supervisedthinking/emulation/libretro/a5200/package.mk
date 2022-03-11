# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="a5200"
PKG_VERSION="7eee43299d0abe28828dee2b86f100b066391866"
PKG_SHA256="7cb11c04b1b67c07d47b0ffa4eed13de50efe4a72f971ae87c3cd5593a68a4b2"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/a5200"
PKG_URL="https://github.com/libretro/a5200/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Port of Atari 5200 emulator for GCW0"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-sysroot"

PKG_LIBNAME="a5200_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="GIT_VERSION=${PKG_VERSION:0:7}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
    cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
