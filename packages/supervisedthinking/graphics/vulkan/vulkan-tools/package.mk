# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="vulkan-tools"
PKG_VERSION="1.2.198"
PKG_SHA256="22f602c0ebc922f3238fa5967e9a4c64ff7fe526434fd015fa5e427ab8684e3f"
PKG_LICENSE="Apache 2.0"
PKG_SITE="https://github.com/KhronosGroup/Vulkan-Tools"
PKG_URL="https://github.com/KhronosGroup/Vulkan-tools/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain cmake:host vulkan-loader"
PKG_LONGDESC="This project provides Khronos official Vulkan Tools and Utilities."

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET="-DBUILD_ICD=Off \
                         -DINSTALL_ICD=Off"

  # Disable Wayland WSI support
  sed -e "s/Build Wayland WSI support\" ON/Build Wayland WSI support\" OFF/" -i ${PKG_BUILD}/cube/CMakeLists.txt
  sed -e "s/Build Wayland WSI support\" ON/Build Wayland WSI support\" OFF/" -i ${PKG_BUILD}/vulkaninfo/CMakeLists.txt
}

pre_make_target() {
  # Fix cross compiling
  find ${PKG_BUILD} -name flags.make -exec sed -i  "s:isystem :I:g" \{} \;
  find ${PKG_BUILD} -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
}
