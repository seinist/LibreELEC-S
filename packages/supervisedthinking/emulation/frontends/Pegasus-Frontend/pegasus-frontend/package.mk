# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="pegasus-frontend"
PKG_VERSION="d852563b003ad7bebc7c0664b0044568907676ef" # Alpha 16
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/mmatyas/pegasus-frontend"
PKG_URL="https://github.com/mmatyas/pegasus-frontend.git"
PKG_DEPENDS_TARGET="toolchain linux glibc zlib libpng sdl2 qt5 pegasus-theme-es2-simple pegasus-theme-gameOS"
PKG_LONGDESC="A cross platform, customizable graphical frontend for launching emulators and managing your game collection."
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto"

post_unpack() {
  cp -r ${PKG_DIR}/files/logos/* ${PKG_BUILD}/src/themes/pegasus-theme-grid/assets/logos
}

configure_package() {
  # Displayserver Support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_DEPENDS_TARGET+=" xorg-server unclutter-xfixes"
  fi

  # Fix EGLFS
  if [ "${DISPLAYSERVER}" = "no" ]; then
    PKG_PATCH_DIRS+=" EGLFS"
  fi

  # Build with OpenGL / OpenGLES support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGL}"
  elif [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGLES}"
  fi
}

configure_target() {
  # Create working dir
  mkdir -p ${PKG_BUILD}/.${TARGET_NAME}
  cd ${PKG_BUILD}/.${TARGET_NAME}

  # Fix EGLFS
  if [ "${DISPLAYSERVER}" = "no" ]; then
    PKG_QMAKE_EXTRA_FLAGS="QMAKE_LIBS_LIBDL=-ldl \
                           QMAKE_CXXFLAGS+=-DMESA_EGL_NO_X11_HEADERS"
  fi

  # Generate qmake config
  qmake ${PKG_BUILD}/pegasus.pro INSTALLDIR=${INSTALL}/usr/bin \
                                 INSTALL_BINDIR=${INSTALL}/usr/bin \
                                 INSTALL_DOCDIR=${INSTALL}/usr/share/doc/pegasus-frontend \
                                 INSTALL_DESKTOPDIR=${INSTALL}/usr/share/applications \
                                 INSTALL_ICONDIR=${INSTALL}/usr/share/icons/trash \
                                 ${PKG_QMAKE_EXTRA_FLAGS}
}

post_makeinstall_target() {
  # Install start scripts
  mkdir -p ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/config/pegasus-frontend/themes
  echo "Place your Pegasus-Frontend Themes here!" > ${INSTALL}/usr/config/pegasus-frontend/themes/readme.txt
  cp -rf ${PKG_DIR}/scripts/*        ${INSTALL}/usr/bin/

  # Clean up
  safe_remove ${INSTALL}/usr/share

  # clean up for KMS based ARM builds
  if [ ! "${DISPLAYSERVER}" = "x11" ]; then
    sed -e "/# Change refresh.*/,+2d" -i ${INSTALL}/usr/bin/*.start
  fi
}
