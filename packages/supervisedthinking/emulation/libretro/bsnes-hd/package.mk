# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="bsnes-hd"
PKG_VERSION="65f24e56c37f46bb752190024bd4058e64ad77d1"
PKG_SHA256="fce28338704fb8251394e432f1d163b1a0530a939742bf9817a448bb8476a4de"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/DerKoun/bsnes-hd"
PKG_URL="https://github.com/DerKoun/bsnes-hd/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="bsnes-hd is a fork of bsnes that adds HD video features."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="bsnes_hd_beta_libretro.so"
PKG_LIBPATH="bsnes/out/${PKG_LIBNAME}"

configure_target(){
  PKG_MAKE_OPTS_TARGET="-C bsnes \
                        -f GNUmakefile \
                        compiler=${CXX} \
                        target=libretro \
                        platform=linux \
                        local=false \
                        binary=library"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
