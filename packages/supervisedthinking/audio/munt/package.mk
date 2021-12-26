# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="munt"
PKG_VERSION="2.5.3"
PKG_SHA256="062d110bbdd7253d01ef291f57e89efc3ee35fd087587458381f054bac49a8f5"
PKG_LICENSE="LGPL-2.0-or-later"
PKG_SITE="https://github.com/munt/munt"
PKG_URL="https://github.com/munt/munt/archive/refs/tags/libmt32emu_${PKG_VERSION//./_}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A software synthesiser emulating pre-GM MIDI devices such as the Roland MT-32."

PKG_CMAKE_OPTS_TARGET="-D munt_WITH_MT32EMU_QT=0 \
                       -D munt_WITH_MT32EMU_SMF2WAV=0 \
                       -D libmt32emu_SHARED=1"
