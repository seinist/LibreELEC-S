# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="desmume"
PKG_VERSION="7ea0fc96804fcd9c8d33e8f76cf64b1be50cc5ea"
PKG_SHA256="5da45ba5fb269fa47a2c2674459fd5a074d0b94fcea5c7ce9bb63a678c010488"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/desmume"
PKG_URL="https://github.com/libretro/desmume/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc libpcap"
PKG_LONGDESC="DeSmuME is a Nintendo DS emulator"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="desmume_libretro.so"
PKG_LIBPATH="desmume/src/frontend/libretro/${PKG_LIBNAME}"

# Disable OpenGL if not supported
if [ ! ${OPENGL_SUPPORT} = "yes" ]; then
  PKG_PATCH_DIRS="no-opengl"
fi

PKG_MAKE_OPTS_TARGET="-C desmume/src/frontend/libretro GIT_VERSION=${PKG_VERSION:0:7}"

configure_package() {
  # Displayserver Support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_DEPENDS_TARGET+=" xorg-server"
  fi

  # OpenGL Support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGL}"
  fi
}

pre_configure_target() {
  if [ "${ARCH}" = "arm" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=armv-${TARGET_FLOAT}float-${TARGET_CPU}"
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
