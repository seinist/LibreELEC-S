# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="genesis-plus-gx"
PKG_VERSION="7dc006bc9234bd9154195f5bbe5683a92b6d6f11"
PKG_SHA256="d22457ba99647e0669767b47a11f6b8ec555daabd57e59fab564d7f87465cef5"
PKG_LICENSE="Modified BSD / LGPL-2.1-or-later"
PKG_SITE="https://github.com/libretro/Genesis-Plus-GX"
PKG_URL="https://github.com/libretro/Genesis-Plus-GX/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="An enhanced port of Genesis Plus - accurate & portable Sega 8/16 bit emulator"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="genesis_plus_gx_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="-f Makefile.libretro GIT_VERSION=${PKG_VERSION:0:7}"

pre_configure_target() {
  case ${PROJECT} in
    Amlogic)
      PKG_MAKE_OPTS_TARGET+=" platform=${DEVICE}"
      ;;
    RPi)
      case ${DEVICE} in
        RPi)
          PKG_MAKE_OPTS_TARGET+=" platform=rpi"
          ;;
        RPi2)
          PKG_MAKE_OPTS_TARGET+=" platform=rpi2"
          ;;
        RPi4)
          PKG_MAKE_OPTS_TARGET+=" platform=rpi4"
          ;;
      esac
      ;;
    Rockchip)
        PKG_MAKE_OPTS_TARGET+=" platform=${DEVICE}"
      ;;
    *)
      if [ "${ARCH}" = "arm" ]; then
        PKG_MAKE_OPTS_TARGET+=" platform=armv"
        CFLAGS+=" -DALIGN_LONG"
      fi
      ;;
  esac
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
