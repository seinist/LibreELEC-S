# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="spectre-meltdown-checker"
PKG_VERSION="0.45"
PKG_SHA256="acc9be079b177be94f428ae790b2c60767afa177e28eef9d21dd09986251e467"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/speed47/spectre-meltdown-checker"
PKG_URL="https://github.com/speed47/spectre-meltdown-checker/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET=""
PKG_LONGDESC="A shell script to tell if your system is vulnerable against the several speculative execution CVEs that were made public in 2018."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
 mkdir -p ${INSTALL}/usr/bin
   chmod +x ${PKG_BUILD}/spectre-meltdown-checker.sh
   cp -v spectre-meltdown-checker.sh ${INSTALL}/usr/bin/spectre-meltdown-checker
}
