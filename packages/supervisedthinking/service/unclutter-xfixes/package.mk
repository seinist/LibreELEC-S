# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="unclutter-xfixes"
PKG_VERSION="1.6"
PKG_SHA256="6f7f248f16b7d4ec7cb144b6bc5a66bd49078130513a184f4dc16c498d457db9"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/Airblader/unclutter-xfixes"
PKG_URL="https://github.com/Airblader/unclutter-xfixes/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXi libXfixes libev-system"
PKG_LONGDESC="This is a rewrite of the popular tool unclutter, but using the x11-xfixes extension."

post_install() {
  enable_service unclutter.service
}
