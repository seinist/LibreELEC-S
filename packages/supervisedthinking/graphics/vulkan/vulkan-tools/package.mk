# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="vulkan-tools"
PKG_VERSION="1.2.199"
PKG_SHA256="cda034e5990aa92848bfd98045ae77000a789e37b2080a97d4cd7fbb3a089580"
PKG_LICENSE="Apache 2.0"
PKG_SITE="https://github.com/KhronosGroup/Vulkan-Tools"
PKG_URL="https://github.com/KhronosGroup/Vulkan-tools/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain cmake:host vulkan-loader"
PKG_LONGDESC="This project provides Khronos official Vulkan Tools and Utilities."

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET="-DBUILD_ICD=Off \
                         -DINSTALL_ICD=Off"

  # Conditionally disable Wayland/X11 support - doesn't accept CMake opts 
  # https://github.com/KhronosGroup/Vulkan-Tools/issues/475
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    sed -e "s/Build Wayland WSI support\" ON/Build Wayland WSI support\" OFF/" -i ${PKG_BUILD}/cube/CMakeLists.txt
    sed -e "s/Build Wayland WSI support\" ON/Build Wayland WSI support\" OFF/" -i ${PKG_BUILD}/vulkaninfo/CMakeLists.txt
  elif [ "${DISPLAYSERVER}" = "weston" ]; then
    sed -e "s/Build XCB WSI support\" ON/Build XCB WSI support\" OFF/" -i   ${PKG_BUILD}/cube/CMakeLists.txt
    sed -e "s/Build Xlib WSI support\" ON/Build Xlib WSI support\" OFF/" -i ${PKG_BUILD}/cube/CMakeLists.txt
    sed -e "s/Build XCB WSI support\" ON/Build XCB WSI support\" OFF/" -i   ${PKG_BUILD}/vulkaninfo/CMakeLists.txt
    sed -e "s/Build Xlib WSI support\" ON/Build Xlib WSI support\" OFF/" -i ${PKG_BUILD}/vulkaninfo/CMakeLists.txt
  else
    PKG_CMAKE_OPTS_TARGET+=" -DBUILD_CUBE=OFF"
    sed -e "s/Build XCB WSI support\" ON/Build XCB WSI support\" OFF/" -i         ${PKG_BUILD}/vulkaninfo/CMakeLists.txt
    sed -e "s/Build Xlib WSI support\" ON/Build Xlib WSI support\" OFF/" -i       ${PKG_BUILD}/vulkaninfo/CMakeLists.txt
    sed -e "s/Build Wayland WSI support\" ON/Build Wayland WSI support\" OFF/" -i ${PKG_BUILD}/vulkaninfo/CMakeLists.txt
  fi
}

pre_make_target() {
  # Fix cross compiling
  find ${PKG_BUILD} -name flags.make -exec sed -i  "s:isystem :I:g" \{} \;
  find ${PKG_BUILD} -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
}
