# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="dosbox-staging"
PKG_VERSION="33cca879170e8e5dcd295829f2fdb43c3f0ade89" #v0.78.0
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://dosbox-staging.github.io/"
PKG_URL="https://github.com/dosbox-staging/dosbox-staging.git"
PKG_DEPENDS_TARGET="toolchain linux alsa-lib sdl2 sdl2_net opusfile libpng fluidsynth-system munt libslirp"
PKG_LONGDESC="DOSBox Staging is an attempt to revitalize DOSBox's development process. It's not a rewrite, but a continuation and improvement on the existing DOSBox codebase while leveraging modern development tools and practices."
GET_HANDLER_SUPPORT="git"
PKG_GIT_CLONE_BRANCH="release/0.78.x"
PKG_GIT_CLONE_SINGLE="yes"
PKG_BUILD_FLAGS="+lto +speed"

configure_package() {
  # Displayserver Support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_DEPENDS_TARGET+=" xorg-server unclutter-xfixes"
  fi

  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+="  ${OPENGL} dosbox-svn-shaders"
  fi
}

pre_configure_target() {
  PKG_MESON_OPTS_TARGET="-D unit_tests=disabled"

  # Disable OpenGL if not supported
  if [ ! "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_MESON_OPTS_TARGET+=" -D use_opengl=false"
  fi
}

post_makeinstall_target() {
  # Create config directory & install config
  mkdir -p ${INSTALL}/usr/config/dosbox
  cp -a ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin/
  cp -a ${PKG_DIR}/config/*  ${INSTALL}/usr/config/dosbox/

  # Link soundfont directory
  ln -sf /usr/config/soundfonts/ ${INSTALL}/usr/config/dosbox/

  # Adjust start scripts for KMS based ARM builds
  if [ ! "${DISPLAYSERVER}" = "x11" ]; then
    sed -e "/# Change refresh.*/,+2d" -i ${INSTALL}/usr/bin/*.start
  fi

  # Adjust config files for OpenGLES builds
  if [ "${OPENGL_SUPPORT}" = "no" ]; then
    sed -e "s/output           = opengl/output           = texture/" -i ${INSTALL}/usr/config/dosbox/dosbox-staging*.conf
    sed -e "/#           glshader:.*/,+16d"                          -i ${INSTALL}/usr/config/dosbox/dosbox-staging*.conf
    sed -e "/glshader           = crt.*/d"                           -i ${INSTALL}/usr/config/dosbox/dosbox-staging*.conf
  fi

  # Clean-up
  safe_remove ${INSTALL}/usr/share
}
