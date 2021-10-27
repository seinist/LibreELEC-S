# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="pegasus-frontend"
PKG_VERSION="fff1a5b2390aaa195d644b651e54c27c2a9b8a1d" # continuous
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/mmatyas/pegasus-frontend"
PKG_URL="https://github.com/mmatyas/pegasus-frontend.git"
PKG_DEPENDS_TARGET="toolchain linux glibc zlib libpng sdl2 qt-everywhere pegasus-theme-es2-simple pegasus-theme-gameOS"
PKG_LONGDESC="A cross platform, customizable graphical frontend for launching emulators and managing your game collection."
GET_HANDLER_SUPPORT="git"

post_unpack() {
  cp -r ${PKG_DIR}/files/logos/* ${PKG_BUILD}/src/themes/pegasus-theme-grid/assets/logos
}

configure_package() {
  # Displayserver Support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_DEPENDS_TARGET+=" xorg-server unclutter-xfixes"
  fi

  # Build with OpenGL / OpenGLES support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGL}"
  elif [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGLES}"
  fi
}

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET="-DPEGASUS_USE_SDL2_POWER=off"
}

post_makeinstall_target() {
  # Install start scripts
  cp -rf ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin/

  # Create readme
  mkdir -p ${INSTALL}/usr/config/pegasus-frontend/themes
  echo "Place your Pegasus-Frontend Themes here!" > ${INSTALL}/usr/config/pegasus-frontend/themes/readme.txt

  # Clean up
  safe_remove ${INSTALL}/usr/share

  # clean up for KMS based ARM builds
  if [ ! "${DISPLAYSERVER}" = "x11" ]; then
    sed -e "/# Change refresh.*/,+2d" -i ${INSTALL}/usr/bin/*.start
  fi
}
