# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="soundtouch"
PKG_VERSION="2.3.1"
PKG_SHA256="42633774f372d8cb0a33333a0ea3b30f357c548626526ac9f6ce018c94042692"
PKG_LICENSE="LGPL-2.1"
PKG_SITE="https://codeberg.org/soundtouch/soundtouch"
PKG_URL="https://codeberg.org/soundtouch/soundtouch/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="SoundTouch Audio Processing Library"
PKG_TOOLCHAIN="configure"

pre_configure_target() {
 cd ${PKG_BUILD}
 ${PKG_BUILD}/bootstrap
}
