# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="yaml-cpp"
PKG_VERSION="0.7.0"
PKG_SHA256="43e6a9fcb146ad871515f0d0873947e5d497a1c9c60c58cb102a97b47208b7c3"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/jbeder/yaml-cpp"
PKG_URL="https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain glibc gcc"
PKG_LONGDESC="yaml-cpp is a YAML parser and emitter in C++ matching the YAML 1.2 spec."

PKG_CMAKE_OPTS_TARGET="-DYAML_BUILD_SHARED_LIBS=ON \
                       -DYAML_CPP_BUILD_TESTS=Off"

post_makeinstall_target() {
  # clean up
  safe_remove ${INSTALL}/usr/share
}
