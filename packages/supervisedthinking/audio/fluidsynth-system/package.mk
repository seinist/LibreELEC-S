# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="fluidsynth-system"
PKG_VERSION="2.2.5"
PKG_SHA256="9037e703617f91c4c36039a5059e0f624164799d856af715bcd8a23c07ba03b8"
PKG_LICENSE="LGPL-2.1-or-later"
PKG_SITE="http://fluidsynth.org/"
PKG_URL="https://github.com/FluidSynth/fluidsynth/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain glib glibc dbus alsa-lib pulseaudio systemd sdl2 libsndfile-system soundfont-generaluser soundfont-musescore_general"
PKG_LONGDESC="FluidSynth is a software real-time synthesizer based on the Soundfont specifications."
PKG_BUILD_FLAGS="+pic"
PKG_DEPENDS_CONFIG="libsndfile-system"

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET="-D LIB_SUFFIX= \
                         -D enable-readline=0 \
                         -D enable-oss=0"
}

post_makeinstall_target() {
  # Create directories
  mkdir -p ${INSTALL}/etc/fluidsynth
  mkdir -p ${INSTALL}/usr/config/fluidsynth
  mkdir -p ${INSTALL}/usr/config/soundfonts

  # Create symlinks & install config file
  cp -a ${PKG_DIR}/config/* ${INSTALL}/usr/config/fluidsynth/
  ln -sf /storage/.config/fluidsynth/fluidsynth.conf ${INSTALL}/etc/fluidsynth/
  echo "Place your SoundFonts here!"              >> ${INSTALL}/usr/config/soundfonts/readme.txt
}
