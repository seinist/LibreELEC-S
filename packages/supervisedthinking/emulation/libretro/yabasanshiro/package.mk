# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="yabasanshiro"
PKG_VERSION="2848d5053fef1a69f68c600b65a1b9e0d915056c"
PKG_SHA256="b647f9d5320f1ed570e9c2a9b978eaeea5996af39f24eb57952f8d20e402a04f"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/yabause"
PKG_URL="https://github.com/libretro/yabause/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="YabaSanshiro Sega Saturn emulator libretro port."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="yabasanshiro_libretro.so"
PKG_LIBPATH="yabause/src/libretro/${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="-C yabause/src/libretro GIT_VERSION=${PKG_VERSION:0:7}"

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
}

pre_configure_target() {
  if [ "${PROJECT}" = "Amlogic" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=AMLG12B"
  elif [ "${PROJECT}" = "Rockchip" ]; then
    case ${DEVICE} in
      RK3399)
        PKG_MAKE_OPTS_TARGET+=" platform=RK3399"
        ;;
      TinkerBoard|MiQi)
        PKG_MAKE_OPTS_TARGET+=" platform=RK3288"
        ;;
    esac
  elif [ "${ARCH}" = "arm" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=armv"
    # ARM NEON support
    if target_has_feature neon; then
      PKG_MAKE_OPTS_TARGET+="-neon"
    fi
    PKG_MAKE_OPTS_TARGET+="-${TARGET_FLOAT}float-${TARGET_CPU}"
  fi

  # OpenGL ES support
  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_MAKE_OPTS_TARGET+=" FORCE_GLES=1"
  fi
}

pre_make_target() {
  make CC=${HOST_CC} -C yabause/src/libretro generate-files
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
