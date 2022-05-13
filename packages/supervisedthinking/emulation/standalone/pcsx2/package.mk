# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="pcsx2"
PKG_VERSION="e934bec4b71516fd5f43a4a644ad1968cc79dc81" #v1.7.2027
PKG_ARCH="x86_64"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/PCSX2/pcsx2"
PKG_URL="https://github.com/PCSX2/pcsx2.git"
PKG_DEPENDS_TARGET="toolchain alsa-lib adwaita-icon-theme freetype gdk-pixbuf glew-cmake glib gtk3-system hicolor-icon-theme libaio libfmt libpcap libpng libX11 libxcb libxml2 mesa pngpp pulseaudio sdl2 soundtouch systemd wxwidgets xz yaml-cpp zlib unclutter-xfixes"
PKG_LONGDESC="PCSX2 is a free and open-source PlayStation 2 (PS2) emulator."
GET_HANDLER_SUPPORT="git"

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
