# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="fs-uae"
PKG_VERSION="3.1.66"
PKG_SHA256="31dc1d627b0d69e6241dae1ee6a76c9fe1f70197bc23e26b9dbba4208b66bd48"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/FrodeSolheim/fs-uae"
PKG_URL="https://github.com/FrodeSolheim/fs-uae/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc glib sdl2 glew-cmake libmpeg2 libXi openal-soft-system capsimg zlib libpng"
PKG_LONGDESC="FS-UAE amiga emulator."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+lto"

configure_package() {
  # Displayserver Support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_DEPENDS_TARGET+=" xorg-server unclutter-xfixes"
  fi
}

post_unpack() {
  # Copy custom input configs
  cp -rf ${PKG_DIR}/input/* ${PKG_BUILD}/share/fs-uae/input/
}

pre_configure_target() {
  # Fix cross compiling
  export ac_cv_func_realloc_0_nonnull=yes

  # Fix execution of buildtools with target flags on build machine
  export CFLAGS=$(echo ${CFLAGS} | sed -e "s|x86-64-[^[:blank:]]*|x86-64|g")
  export CXXFLAGS=$(echo ${CXXFLAGS} | sed -e "s|x86-64-[^[:blank:]]*|x86-64|g")
  export LDFLAGS=$(echo ${LDFLAGS} | sed -e "s|x86-64-[^[:blank:]]*|x86-64|g")
}

post_makeinstall_target() {
  # Install scripts
  cp -rfv ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin/

  # Set up default config directory
  mkdir -p ${INSTALL}/usr/config
  cp -rfv ${PKG_DIR}/config ${INSTALL}/usr/config/fs-uae
  ln -sf /storage/roms/bios/Kickstarts ${INSTALL}/usr/config/fs-uae/Kickstarts

  # Create symlink to capsimg for IPF support
  mkdir -p ${INSTALL}/usr/config/fs-uae/Plugins
  ln -sf /usr/lib/libcapsimage.so.5.1 ${INSTALL}/usr/config/fs-uae/Plugins/capsimg.so

  # Clean up
  safe_remove ${INSTALL}/usr/share/applications
  safe_remove ${INSTALL}/usr/share/icons
  safe_remove ${INSTALL}/usr/share/mime
}
