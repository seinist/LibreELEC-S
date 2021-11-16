# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="vulkan-loader"
PKG_VERSION="1.2.198"
PKG_SHA256="b4a0ec6ce8921f50ab291f1c3a16802cfbe2c3dbd86820eb699bfb98890ad126"
PKG_LICENSE="Apache 2.0"
PKG_SITE="https://github.com/KhronosGroup/Vulkan-Loader"
PKG_URL="https://github.com/KhronosGroup/Vulkan-Loader/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain cmake:host vulkan-headers"
PKG_LONGDESC="Vulkan Installable Client Driver (ICD) Loader."

configure_package() {
  # Displayserver Support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_DEPENDS_TARGET+=" libX11 libXrandr libxcb"
  fi
}

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET="-DBUILD_TESTS=Off \
                         -DGIT_FOUND=Off"

  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DBUILD_WSI_WAYLAND_SUPPORT=Off"
  elif [ "${DISPLAYSERVER}" = "weston" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DBUILD_WSI_XCB_SUPPORT=Off \
                             -DBUILD_WSI_XLIB_SUPPORT=Off"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DBUILD_WSI_WAYLAND_SUPPORT=Off \
                             -DBUILD_WSI_XCB_SUPPORT=Off \
                             -DBUILD_WSI_XLIB_SUPPORT=Off"
  fi
}
