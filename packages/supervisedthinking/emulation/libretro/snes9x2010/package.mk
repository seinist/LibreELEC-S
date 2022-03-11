# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="snes9x2010"
PKG_VERSION="f422fcf58320e8cce5aad2abd227f2461251222a"
PKG_SHA256="1a481ad54bfa6f8ec3caa1c72231833eb2b5cdde4a18d826bcb03cabf2ad47ad"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/libretro/snes9x2010"
PKG_URL="https://github.com/libretro/snes9x2010/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Snes9x 2010. Port of Snes9x 1.52+ to Libretro (previously called SNES9x Next). Rewritten in C and several optimizations and speedhacks."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="snes9x2010_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="GIT_VERSION=${PKG_VERSION:0:7}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
    cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
