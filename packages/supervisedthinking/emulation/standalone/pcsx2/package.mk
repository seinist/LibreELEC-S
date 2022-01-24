# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="pcsx2"
PKG_VERSION="7e36ee243c20bc75d3dd2b5270e33de233ccec1d" #v1.7.2161
PKG_ARCH="x86_64"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/PCSX2/pcsx2"
PKG_URL="https://github.com/PCSX2/pcsx2.git"
PKG_DEPENDS_TARGET="toolchain alsa-lib adwaita-icon-theme freetype gdk-pixbuf glib gtk3-system hicolor-icon-theme libaio libfmt libpcap libpng libxml2 pngpp pulseaudio sdl2 soundtouch systemd wxwidgets xz rapidyaml zlib"
PKG_LONGDESC="PCSX2 is a free and open-source PlayStation 2 (PS2) emulator."
GET_HANDLER_SUPPORT="git"
PKG_GIT_CLONE_BRANCH="master"
PKG_GIT_CLONE_SINGLE="yes"

configure_package() {
  # Build with XCB support for X11
  if [ ${DISPLAYSERVER} = "x11" ]; then
    PKG_DEPENDS_TARGET+=" libX11 libxcb unclutter-xfixes glew-cmake"
  elif [ ${DISPLAYSERVER} = "wl" ]; then
    PKG_DEPENDS_TARGET+=" wayland"
  fi

  # OpenGL support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGL} glew-cmake"
  fi

  # OpenGLES support
  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGLES}"
  fi
}

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET="-D CMAKE_INSTALL_DOCDIR=/usr/share/doc \
                         -D CMAKE_INSTALL_DATADIR=/usr/share \
                         -D CMAKE_INSTALL_LIBDIR=/usr/lib \
                         -D DISABLE_ADVANCE_SIMD=ON \
                         -D DISABLE_PCSX2_WRAPPER=ON \
                         -D ENABLE_TESTS=OFF \
                         -D SDL2_API=ON \
                         -D PACKAGE_MODE=ON \
                         -D USE_SYSTEM_YAML=ON \
                         -D LTO_PCSX2_CORE=ON \
                         -D USE_VTUNE=OFF \
                         -D XDG_STD=ON \
                         -Wno-dev"
}

pre_make_target() {
  # fix cross compiling
  find ${PKG_BUILD} -name flags.make -exec sed  -i "s:isystem :I:g" \{} \;
  find ${PKG_BUILD} -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
}

post_makeinstall_target() {
  # create directories
  mkdir -p ${INSTALL}${INSTALL}/usr/config

  # install scripts & config files
  cp -rfv ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin/
  cp -rfv ${PKG_DIR}/config/*  ${INSTALL}/usr/config

  # clean up
  safe_remove ${INSTALL}/usr/share/applications
  safe_remove ${INSTALL}/usr/share/pixmaps
}
