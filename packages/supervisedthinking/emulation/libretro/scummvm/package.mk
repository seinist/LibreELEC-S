# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="scummvm"
PKG_VERSION="22f1c6f2147f46f8be0eb4cf2f3a594b9295254b"
PKG_SHA256="a230a60ddde96e6a2c6d07fa5a121b4f99e1f7fd8ce59e13ee5ac64d34e5f7c2"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/diablodiab/scummvm"
PKG_URL="https://github.com/diablodiab/scummvm/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="ScummVM is an interpreter for point-and-click adventure games that can be used as a libretro core."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-sysroot"

PKG_LIBNAME="scummvm_libretro.so"
PKG_LIBPATH="backends/platform/libretro/build/${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="-C backends/platform/libretro/build GIT_VERSION=${PKG_VERSION:0:7}"

pre_configure_target() {
  if [ "${ARCH}" = "arm" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=armv"
    # ARM NEON support
    if target_has_feature neon; then
      PKG_MAKE_OPTS_TARGET+="-neon"
    fi
    PKG_MAKE_OPTS_TARGET+="-${TARGET_FLOAT}float-${TARGET_CPU}"
  fi
}

pre_make_target() {
  # Fix build path
  cd ${PKG_BUILD}

  CXXFLAGS+=" -DHAVE_POSIX_MEMALIGN=1"
  export AR+=" cru"
  export LD="${CC}"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
