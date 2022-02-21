# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)
# Copyright (C) 2021-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="vulkan-loader"
PKG_VERSION="1.3.206"
PKG_SHA256="115263a3e9d37fe0b9f9e8a30d7b5769889ec1002b2ee2db1a2d38d4756f74b3"
PKG_LICENSE="Apache-2.0"
PKG_SITE="https://github.com/KhronosGroup/Vulkan-Loader"
PKG_URL="https://github.com/KhronosGroup/Vulkan-Loader/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="toolchain:host vulkan-headers:host"
PKG_DEPENDS_TARGET="toolchain vulkan-headers vulkan-loader:host"
PKG_LONGDESC="Vulkan Installable Client Driver (ICD) Loader."

configure_package() {
  # Displayserver Support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_DEPENDS_TARGET+=" libxcb libX11"
  elif [ "${DISPLAYSERVER}" = "wl" ]; then
    PKG_DEPENDS_TARGET+=" wayland"
  fi
}

pre_configure_host() {
  # hack to workaround missing options to build a standalone asm_offset binary
  # if the glibc version of the host & target system differs build will fail otherwise
  sed -e 's|COMMAND asm_offset GAS|COMMAND ./asm_offset GAS|g' -i ${PKG_BUILD}/loader/CMakeLists.txt

  PKG_CMAKE_OPTS_HOST="-DBUILD_WSI_XCB_SUPPORT=OFF \
                       -DBUILD_WSI_XLIB_SUPPORT=OFF \
                       -DBUILD_WSI_WAYLAND_SUPPORT=OFF \
                       -DBUILD_TESTS=OFF"
}

makeinstall_host() {
  cp ${PKG_BUILD}/.${HOST_NAME}/loader/asm_offset ${TOOLCHAIN}/bin/
}

pre_configure_target() {
  sed -e 's|COMMAND ./asm_offset GAS|COMMAND asm_offset GAS|g' -i ${PKG_BUILD}/loader/CMakeLists.txt

  PKG_CMAKE_OPTS_TARGET="-DBUILD_TESTS=OFF"

  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DBUILD_WSI_XCB_SUPPORT=ON \
                             -DBUILD_WSI_XLIB_SUPPORT=ON \
                             -DBUILD_WSI_WAYLAND_SUPPORT=OFF"
  elif [ "${DISPLAYSERVER}" = "wl" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DBUILD_WSI_XCB_SUPPORT=OFF \
                             -DBUILD_WSI_XLIB_SUPPORT=OFF \
                             -DBUILD_WSI_WAYLAND_SUPPORT=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DBUILD_WSI_XCB_SUPPORT=OFF \
                             -DBUILD_WSI_XLIB_SUPPORT=OFF \
                             -DBUILD_WSI_WAYLAND_SUPPORT=OFF"
  fi
}
