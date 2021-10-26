# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="boom3"
PKG_VERSION="6e6afe95c0b6e0138f8bd7d0e4f27fa9ec05cea9"
PKG_SHA256="7f04ccaba9c9077806b2fbe05b5082766b91b97fb871595d1631743c9a6ad0a9"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/libretro/boom3"
PKG_URL="https://github.com/libretro/boom3/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="dhewm3 port to libretro."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="boom3_libretro.so"
PKG_LIBPATH="neo/${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET=" -C neo GIT_VERSION=${PKG_VERSION:0:7}"

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

pre_make_target() {
  cd $PKG_BUILD
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
