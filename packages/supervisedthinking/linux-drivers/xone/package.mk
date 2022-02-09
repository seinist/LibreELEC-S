# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="xone"
PKG_VERSION="0.2"
PKG_SHA256="679dc5eadb669ee4b502f111b7ea9b7e35e484f923ae3374e25f0c04b72ce969"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/medusalix/xone"
PKG_URL="https://github.com/medusalix/xone/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux libusb systemd"
PKG_LONGDESC="Linux kernel driver for Xbox One and Xbox Series X|S accessories"
PKG_IS_KERNEL_PKG="yes"
PKG_TOOLCHAIN="make"

make_target() {
  kernel_make -C $(kernel_path) M=${PKG_BUILD}/ modules
}

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_module_dir)/kernel/drivers/hid
   cp -rv ${PKG_BUILD}/*.ko ${INSTALL}/$(get_full_module_dir)/kernel/drivers/hid

  # Install modprobe.d config files
  mkdir -p ${INSTALL}/usr/config
    cp -PRv ${PKG_DIR}/config/modprobe.d ${INSTALL}/usr/config
}
