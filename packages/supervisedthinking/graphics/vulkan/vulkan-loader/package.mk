# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="vulkan-loader"
PKG_VERSION="6d9e5b07d6623d17070169c12fe8cc8eaca4274f" #v1.2.196
PKG_LICENSE="Apache 2.0"
PKG_SITE="https://github.com/KhronosGroup/Vulkan-Loader"
PKG_URL="https://github.com/KhronosGroup/Vulkan-Loader.git"
PKG_DEPENDS_TARGET="toolchain cmake:host vulkan-headers"
PKG_LONGDESC="Vulkan Installable Client Driver (ICD) Loader."
GET_HANDLER_SUPPORT="git"

configure_package() {
  # Displayserver Support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_DEPENDS_TARGET+=" libX11 libXrandr libxcb"
  fi
}

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET="-DBUILD_TESTS=Off \
                         -DGIT_FOUND=Off \
                         -DBUILD_WSI_WAYLAND_SUPPORT=Off"

  # Mali Vulkan support
  if [ ! "${DISPLAYSERVER}" = "x11" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DBUILD_WSI_XCB_SUPPORT=Off \
                             -DBUILD_WSI_XLIB_SUPPORT=Off"
  fi
}
