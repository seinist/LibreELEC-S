# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="waffle"
PKG_VERSION="1.7.0"
PKG_SHA256="4ca66313de4b13c67976dc52bdde9b8cf6518be749cee57bea851be768f48ff8"
PKG_LICENSE="BSD"
PKG_SITE="http://www.waffle-gl.org/"
PKG_URL="https://gitlab.freedesktop.org/mesa/waffle/-/archive/v${PKG_VERSION}/waffle-v${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain systemd mesa"
PKG_LONGDESC="A C library for selecting an OpenGL API and window system at runtime."

PKG_MESON_OPTS_TARGET="-D build-examples=false"
