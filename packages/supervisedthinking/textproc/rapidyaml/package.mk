# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="rapidyaml"
PKG_VERSION="6993a7c56f4d064997a4df63fc16380ef6381d68" #v0.2.3
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/biojppm/rapidyaml"
PKG_URL="https://github.com/biojppm/rapidyaml.git"
PKG_DEPENDS_TARGET="toolchain swig"
PKG_LONGDESC="Rapid YAML - a library to parse and emit YAML, and do it fast."
GET_HANDLER_SUPPORT="git"
PKG_GIT_CLONE_BRANCH="master"
PKG_GIT_CLONE_SINGLE="yes"

PKG_CMAKE_OPTS_TARGET="-DRYML_DEFAULT_CALLBACKS=ON \
                       -DRYML_BUILD_API=Off \
                       -DRYML_DBG=Off"
