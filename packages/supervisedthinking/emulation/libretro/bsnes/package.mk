# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="bsnes"
PKG_VERSION="4ea6208ad05de7698c321db6fffea9273efc7dee"
PKG_SHA256="0222c84e6d4cadbb47766df32bbbb23aae57865df03795cc766b644431e69855"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/bsnes"
PKG_URL="https://github.com/libretro/bsnes/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="bsnes is a multi-platform Super Nintendo (Super Famicom) emulator that focuses on performance, features, and ease of use."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+lto -sysroot"

PKG_LIBNAME="bsnes_libretro.so"
PKG_LIBPATH="bsnes/out/${PKG_LIBNAME}"

configure_target(){
  PKG_MAKE_OPTS_TARGET="-C bsnes \
                        -f GNUmakefile \
                        compiler=${CXX} \
                        target=libretro \
                        platform=linux \
                        local=false \
                        binary=library \
                        openmp=false"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
