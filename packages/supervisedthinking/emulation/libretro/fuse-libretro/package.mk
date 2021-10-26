# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="fuse-libretro"
PKG_VERSION="5f331e9772d305ba5209db0910b1963b9d0974c0"
PKG_SHA256="cb45e77fa13f32ce50a9b9104d9636ccb93b63b7b107c1d4123ebcbcaedffe50"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/libretro/fuse-libretro"
PKG_URL="https://github.com/libretro/fuse-libretro/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="fuse-libretro is an work in progress port of the Fuse Unix Spectrum Emulator to libretro."
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="fuse_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
