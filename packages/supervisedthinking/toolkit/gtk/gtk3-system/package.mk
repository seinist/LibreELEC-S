# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="gtk3-system"
PKG_VERSION="3.24.33"
PKG_SHA256="c43a6082093be3e0d771f595df5669d594ae1c9c6dedbfc429fada0da80431d5"
PKG_LICENSE="LGPL-2.0-or-later"
PKG_SITE="http://www.gtk.org/"
PKG_URL="https://github.com/GNOME/gtk/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain at-spi2-atk atk cairo gdk-pixbuf glib libepoxy pango libxkbcommon"
PKG_DEPENDS_CONFIG="gdk-pixbuf"
PKG_LONGDESC="GTK is a multi-platform toolkit for creating graphical user interfaces."
PKG_TOOLCHAIN="meson"

configure_package() {
  # Build with XCB support for X11
  if [ ${DISPLAYSERVER} = "x11" ]; then
    PKG_DEPENDS_TARGET+=" libX11 libXi libXrandr"
    PKG_DEPENDS_CONFIG+=" libXft"
  elif [ ${DISPLAYSERVER} = "wl" ]; then
    PKG_DEPENDS_TARGET+=" wayland"
  fi
}

pre_configure_target() {
  PKG_MESON_OPTS_TARGET="-D quartz_backend=false \
                         -D xinerama=no \
                         -D print_backends=file,lpr \
                         -D colord=no \
                         -D introspection=false \
                         -D demos=false \
                         -D examples=false \
                         -D tests=false \
                         -D builtin_immodules=yes"

  if [ ${DISPLAYSERVER} = "x11" ]; then
    PKG_MESON_OPTS_TARGET+=" -D x11_backend=true \
                             -D wayland_backend=false"
  elif [ ${DISPLAYSERVER} = "wl" ]; then
    PKG_MESON_OPTS_TARGET+=" -D x11_backend=false \
                             -D wayland_backend=true"
  fi

  # ${TOOLCHAIN}/bin/glib-compile-resources requires ${TOOLCHAIN}/lib/libffi.so.6
  export LD_LIBRARY_PATH="${TOOLCHAIN}/lib:${LD_LIBRARY_PATH}"
  export GLIB_COMPILE_RESOURCES=glib-compile-resources GLIB_MKENUMS=glib-mkenums GLIB_GENMARSHAL=glib-genmarshal
}

post_makeinstall_target() {
  # compile GSettings XML schema files
  ${TOOLCHAIN}/bin/glib-compile-schemas ${INSTALL}/usr/share/glib-2.0/schemas

  # GTK basic theme configuration
  cp -PR ${PKG_DIR}/config/* ${INSTALL}/etc/gtk-3.0/
}
