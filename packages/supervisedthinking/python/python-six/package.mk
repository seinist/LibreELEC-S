# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="python-six"
PKG_VERSION="1.16.0"
PKG_SHA256="af6745f78dceb1ad5107dc6c2d3646c8cb57cf4668ba7b5427145a71a690f60e"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/benjaminp/six"
PKG_URL="https://github.com/benjaminp/six/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python3 setuptools"
PKG_LONGDESC="Six is a Python 2 and 3 compatibility library."
PKG_TOOLCHAIN="manual"

pre_make_target() {
  export PYTHONXCPREFIX="${SYSROOT_PREFIX}/usr"
  export LDFLAGS="${LDFLAGS} -L${SYSROOT_PREFIX}/usr/lib -L${SYSROOT_PREFIX}/lib"
  export LDSHARED="${CC} -shared"
}

make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=${INSTALL} --prefix=/usr
}

post_makeinstall_target() {
  find ${INSTALL}/usr/lib/python*/site-packages/  -name "*.py" -exec rm -rf {} ";"
}
