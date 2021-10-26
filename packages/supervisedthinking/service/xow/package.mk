# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="xow"
PKG_VERSION="99100fb52953e0218bc140bb04febd8ae51b1506"
PKG_SHA256="2f30af134d600e836a4077ec12d24a9b81bdc670990453ffb23aabe86d892df1"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/medusalix/xow"
PKG_URL="https://github.com/medusalix/xow/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux libusb systemd"
PKG_LONGDESC="Linux driver for the Xbox One wireless dongle"
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="BUILD=RELEASE VERSION=${PKG_VERSION:0:7}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
   cp -rv xow ${INSTALL}/usr/bin

  # Install config files
  cp -PRv ${PKG_DIR}/config/* ${INSTALL}
}
