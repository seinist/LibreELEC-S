# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="mame2003-plus"
PKG_VERSION="6147fc1c8b759eb03110ddc71a21c2dbb3f5a685"
PKG_SHA256="10e1846221f90486d57445dc6934f04b91b11a2a80634d8324bc23d975dd7889"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/mame2003-plus-libretro"
PKG_URL="https://github.com/libretro/mame2003-plus-libretro/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Updated 2018 version of MAME (0.78) for libretro. with added game support plus many fixes and improvements"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="mame2003_plus_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="GIT_VERSION=${PKG_VERSION:0:7}"

pre_configure_target() {
  if [ "${ARCH}" = "arm" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=armv"
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
    cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/

  # copy metadata for manual content scanning
  mkdir -p ${INSTALL}/usr/share/retroarch/database/mame2003-plus
    cp ${PKG_BUILD}/metadata/mame2003-plus.xml ${INSTALL}/usr/share/retroarch/database/mame2003-plus
}
