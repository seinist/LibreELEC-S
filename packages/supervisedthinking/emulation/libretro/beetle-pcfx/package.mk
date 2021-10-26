# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="beetle-pcfx"
PKG_VERSION="a1f1734509dd6acb11269f118d61f480ae8dbacf"
PKG_SHA256="76f22fc238748fb7c63d260f725cae6fa3bd7797ad595ab8116a5c15b7c05e04"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/beetle-pcfx-libretro"
PKG_URL="https://github.com/libretro/beetle-pcfx-libretro/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libc"
PKG_LONGDESC="Standalone port of Mednafen PCFX to libretro."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="mednafen_pcfx_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="GIT_VERSION=${PKG_VERSION:0:7}"

pre_configure_target() {
  if [ "${ARCH}" = "arm" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=armv"

    # ARM NEON support
    if target_has_feature neon; then
      PKG_MAKE_OPTS_TARGET+="-neon"
    fi
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
