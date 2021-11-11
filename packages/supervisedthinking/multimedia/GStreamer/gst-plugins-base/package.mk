# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="gst-plugins-base"
PKG_VERSION="1.18.5"
PKG_SHA256="960b7af4585700db0fdd5b843554e11e2564fed9e061f591fae88a7be6446fa3"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://gstreamer.freedesktop.org/modules/gst-plugins-base.html"
PKG_URL="https://gstreamer.freedesktop.org/src/gst-plugins-base/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain gstreamer"
PKG_LONGDESC="Base GStreamer plugins and helper libraries"
PKG_BUILD_FLAGS="-gold"

pre_configure_target() {
  PKG_MESON_OPTS_TARGET="-Dexamples=disabled \
                         -Dtests=disabled \
                         -Dgobject-cast-checks=disabled \
                         -Dgtk_doc=disabled \
                         -Dnls=disabled"

  # Fix undefined symbol glPointSizePointerOES
  if [ "${OPENGLES}" = "bcm2835-driver" ]; then
    TARGET_LDFLAGS+=" -lEGL -lGLESv2"
  fi
  # Fix missing dispmanx
  if [ "${DEVICE}" = "RPi4" ]; then
    PKG_MESON_OPTS_TARGET+=" -Dgl_winsys="egl""
  fi
}

post_makeinstall_target(){
  # Clean up
  safe_remove ${INSTALL}/usr/bin
  safe_remove ${INSTALL}/usr/share
}
