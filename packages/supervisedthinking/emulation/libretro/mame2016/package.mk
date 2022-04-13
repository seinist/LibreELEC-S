# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="mame2016"
PKG_VERSION="01058613a0109424c4e7211e49ed83ac950d3993"
PKG_SHA256="3faaf226279d0c08d2a945a208c43d3851d4b86981b5224231de80098a97ea27"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/mame2016-libretro"
PKG_URL="https://github.com/libretro/mame2016-libretro/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux:host alsa-lib"
PKG_LONGDESC="Late 2016 version of MAME (0.174) for libretro. Compatible with MAME 0.174 romsets."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-sysroot"

PKG_LIBNAME="mamearcade2016_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

pre_make_target() {
  PKG_MAKE_OPTS_TARGET=" \
    REGENIE=1 VERBOSE=1 NOWERROR=1 PYTHON_EXECUTABLE=python3 CONFIG=libretro \
    LIBRETRO_OS="unix" ARCH="" PROJECT="" LIBRETRO_CPU="${ARCH}" DISTRO="debian-stable" \
    CROSS_BUILD="1" OVERRIDE_CC="${CC}" OVERRIDE_CXX="${CXX}" \
    TARGET="mame" SUBTARGET="arcade" PLATFORM="${ARCH}" RETRO=1 OSD="retro" \
    GIT_VERSION=${PKG_VERSION:0:7}"

  if [ "${ARCH}" = "arm" ]; then
    PKG_MAKE_OPTS_TARGET+=" NOASM="1" ARCHITECTURE="""
  elif [ "${ARCH}" = "x86_64" ]; then
    PKG_MAKE_OPTS_TARGET+=" NOASM="0" PTR64="1""
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/mame2016_libretro.so
}
