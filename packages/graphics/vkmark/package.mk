# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="vkmark"
PKG_VERSION="cf45f2faee236fd1118be2fcd27e4f2a91fc2e40"
PKG_SHA256="e59e1e557a579244de8e97adb1afbc4d6766577bbd6dbf4dc292716f87eeb981"
PKG_LICENSE="LGPL-2.1-or-later"
PKG_SITE="https://github.com/vkmark/vkmark"
PKG_URL="https://github.com/vkmark/vkmark/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain glm assimp vulkan-loader"
PKG_LONGDESC="Vulkan benchmark"

case ${DISPLAYSERVER} in
  wl)
    PKG_DEPENDS_TARGET+=" wayland wayland-protocols"
    PKG_MESON_OPTS_TARGET="-Dwayland=true"
    ;;
  x11)
    PKG_DEPENDS_TARGET+=" libxcb xcb-util-wm"
    PKG_MESON_OPTS_TARGET="-Dxcb=true"
    ;;
  *)
    PKG_DEPENDS_TARGET+=" systemd libdrm"
    PKG_MESON_OPTS_TARGET="-Dkms=true"
    ;;
esac
