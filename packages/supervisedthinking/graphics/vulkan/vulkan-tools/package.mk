# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)
# Copyright (C) 2021-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="vulkan-tools"
PKG_VERSION="1.2.203"
PKG_SHA256="70b50a14c26dc12c71de5b4847055e318d7af77e7ce13250b1b0a4d40a50bbfd"
PKG_LICENSE="Apache-2.0"
PKG_SITE="https://github.com/KhronosGroup/Vulkan-Tools"
PKG_URL="https://github.com/KhronosGroup/Vulkan-tools/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain vulkan-loader glslang:host"
PKG_LONGDESC="This project provides Khronos official Vulkan Tools and Utilities."

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET="-DBUILD_VULKANINFO=ON \
                         -DBUILD_ICD=OFF \
                         -DINSTALL_ICD=OFF \
                         -DBUILD_WSI_DIRECTFB_SUPPORT=OFF \
                         -Wno-dev"

  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DBUILD_CUBE=ON \
                             -DBUILD_WSI_XCB_SUPPORT=ON \
                             -DBUILD_WSI_XLIB_SUPPORT=ON \
                             -DBUILD_WSI_WAYLAND_SUPPORT=OFF \
                             -DCUBE_WSI_SELECTION=XCB"
  elif [ "${DISPLAYSERVER}" = "weston" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DBUILD_CUBE=ON \
                             -DBUILD_WSI_XCB_SUPPORT=OFF \
                             -DBUILD_WSI_XLIB_SUPPORT=OFF \
                             -DBUILD_WSI_WAYLAND_SUPPORT=ON
                             -DCUBE_WSI_SELECTION=WAYLAND"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DBUILD_CUBE=ON \
                             -DBUILD_WSI_XCB_SUPPORT=OFF \
                             -DBUILD_WSI_XLIB_SUPPORT=OFF \
                             -DBUILD_WSI_WAYLAND_SUPPORT=OFF \
                             -DCUBE_WSI_SELECTION=DISPLAY"
  fi
}

pre_make_target() {
  # Fix cross compiling
  find ${PKG_BUILD} -name flags.make -exec sed -i  "s:isystem :I:g" \{} \;
  find ${PKG_BUILD} -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
}
