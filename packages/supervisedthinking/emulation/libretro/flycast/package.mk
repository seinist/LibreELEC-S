# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="flycast"
PKG_VERSION="3d5fd61285a2b57ed4ac7b2b25bc2b830cf43d57" # v1.3
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/flyinghead/flycast"
PKG_URL="https://github.com/flyinghead/flycast.git"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Flycast is a multiplatform Sega Dreamcast, Naomi and Atomiswave emulator"
PKG_GIT_CLONE_BRANCH="master"
PKG_GIT_CLONE_SINGLE="yes"
GET_HANDLER_SUPPORT="git"
PKG_BUILD_FLAGS="-sysroot"

PKG_LIBNAME="flycast_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

configure_package() {
  # Displayserver Support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_DEPENDS_TARGET+=" xorg-server"
  fi

  # OpenGL Support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGL}"
  fi

  # OpenGLES Support
  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGLES}"
  fi

  # Vulkan Support
  if [ "${VULKAN_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${VULKAN}"
  fi
}

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET="-DLIBRETRO=ON \
                         -DUSE_OPENMP=OFF"

  if [ "$OPENGLES_SUPPORT" = yes ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DUSE_GLES=ON"
  fi

  if [ "$VULKAN_SUPPORT" = yes ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DUSE_VULKAN=ON"
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
