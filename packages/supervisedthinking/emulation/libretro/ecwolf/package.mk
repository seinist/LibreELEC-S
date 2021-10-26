# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="ecwolf"
PKG_VERSION="30c4192b63a2ab5d797616052c186413e8768e73"
PKG_SHA256="96937dc6fbea76e704934e593c530b230109ccb58a25bac4ac803354a030fd36"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/ecwolf"
PKG_URL="https://github.com/libretro/ecwolf/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="Libretro port of ECWolf"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="ecwolf_libretro.so"
PKG_LIBPATH="src/libretro/${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET=" -C src/libretro GIT_VERSION=${PKG_VERSION:0:7}"

pre_make_target() {
  cd $PKG_BUILD
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
