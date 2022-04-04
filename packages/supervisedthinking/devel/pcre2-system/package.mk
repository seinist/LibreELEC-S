# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="pcre2-system"
PKG_VERSION="10.39"
PKG_SHA256="af1c1c7b757591b6bb8ebcd3c7aac9e0320c077260e6f9a760fb7c307a9af301"
PKG_LICENSE="BSD"
PKG_SITE="http://www.pcre.org/"
PKG_URL="https://github.com/PhilipHazel/pcre2/archive/pcre2-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5"
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=OFF \
                       -DBUILD_STATIC_LIBS=ON \
                       -DPCRE2_BUILD_PCRE2_8=ON \
                       -DPCRE2_BUILD_PCRE2_16=ON \
                       -DPCRE2_BUILD_PCRE2_32=ON \
                       -DPCRE2_SUPPORT_JIT=ON \
                       -DPCRE2_BUILD_TESTS=OFF \
                       -DPCRE2_SUPPORT_LIBREADLINE=OFF"

post_makeinstall_target() {
  safe_remove ${INSTALL}/usr/bin
}
