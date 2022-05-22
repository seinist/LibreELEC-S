# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="opus-system"
PKG_VERSION="1.3.1"
PKG_SHA256="4834a8944c33a7ecab5cad9454eeabe4680ca1842cb8f5a2437572dbf636de8f"
PKG_LICENSE="BSD"
PKG_SITE="http://www.opus-codec.org"
PKG_URL="https://github.com/xiph/opus/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Codec designed for interactive speech and audio transmission over the Internet."
PKG_TOOLCHAIN="autotools"

post_unpack() {
  # Fix opus version
  echo PACKAGE_VERSION=\"${PKG_VERSION}\" > ${PKG_BUILD}/package_version
}

pre_configure_target() {
  # ARM NEON support
  if [ "${TARGET_ARCH}" = "arm" ]; then
    if target_has_feature neon; then
      PKG_CONFIGURE_OPTS_TARGET="--disable-fixed-point"
    else
      PKG_CONFIGURE_OPTS_TARGET="--enable-fixed-point"      
    fi
  fi
}
