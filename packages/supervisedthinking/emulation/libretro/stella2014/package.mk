# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="stella2014"
PKG_VERSION="1351a4fe2ca6b1f3a66c7db0df2ec268ab002d41"
PKG_SHA256="7836f41bf95a345735701e818e340ffcfa008542bb5ad0b2f760d807bd3b3620"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/stella2014-libretro"
PKG_URL="https://github.com/libretro/stella2014-libretro/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Port of Stella to libretro."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="stella2014_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="GIT_VERSION=${PKG_VERSION:0:7}"

pre_configure_target() {
  if [ "${ARCH}" = "arm" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=armv"

    # NEON Support ?
    if target_has_feature neon; then
      PKG_MAKE_OPTS_TARGET+="-neon"
    fi
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
