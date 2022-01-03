# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="prboom"
PKG_VERSION="e389ee83fd153b7c1d036c001bd7c14a3bae291c"
PKG_SHA256="ea791868b325cf396d3ac8f1c63f9c4d440e39e8aa1db4d9b71d6be443af72d7"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/libretro-prboom"
PKG_URL="https://github.com/libretro/libretro-prboom/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Port of prboom to libretro - plays Doom, Doom II, Final Doom and other Doom IWAD mods."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="prboom_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="GIT_VERSION=${PKG_VERSION:0:7}"

pre_configure_target() {
  if [ "${ARCH}" = "arm" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=armv"

    # ARM NEON Support
    if target_has_feature neon; then
      PKG_MAKE_OPTS_TARGET+="-neon"
    fi
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  mkdir -p ${INSTALL}/usr/share/prboom

  cp ${PKG_BUILD}/prboom.wad ${INSTALL}/usr/share/prboom
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}

