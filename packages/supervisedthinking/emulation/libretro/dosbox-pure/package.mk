# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="dosbox-pure"
PKG_VERSION="0.20"
PKG_SHA256="024077fadd806daa0081846ea25aeeac247d60e523dec6de53c50664087fd7e4"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/schellingb/dosbox-pure"
PKG_URL="https://github.com/schellingb/dosbox-pure/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc"
PKG_LONGDESC="DOSBox Pure is a fork of DOSBox, an emulator for DOS games, built for RetroArch/Libretro aiming for simplicity and ease of use."
PKG_BUILD_FLAGS="+lto +speed -sysroot"

PKG_LIBNAME="dosbox_pure_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
