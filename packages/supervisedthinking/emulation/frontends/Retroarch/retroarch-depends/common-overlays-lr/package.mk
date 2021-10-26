# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="common-overlays-lr"
PKG_VERSION="dde1f3b201b33f411219fe804bc574230be7e2b7"
PKG_SHA256="177f6d48faa878ac3282d52bc64fbbf6ad59d9bc42029777fe2a3ff88b8b6ae3"
PKG_LICENSE="CC-BY-4.0 License"
PKG_SITE="https://github.com/libretro/common-overlays"
PKG_URL="https://github.com/libretro/common-overlays/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET=""
PKG_LONGDESC="Collection of overlay files for use with libretro frontends, such as RetroArch."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/retroarch/overlay
  cp -r ${PKG_BUILD}/borders ${INSTALL}/usr/share/retroarch/overlay
}
