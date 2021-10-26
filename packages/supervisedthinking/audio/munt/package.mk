# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="munt"
PKG_VERSION="2.5.2"
PKG_SHA256="4ec903cc2bb2e6f1006663941a86949302147c990b245d6a6c41e8d3bc358b83"
PKG_LICENSE="LGPL-2.0-or-later"
PKG_SITE="https://github.com/munt/munt"
PKG_URL="https://github.com/munt/munt/archive/refs/tags/libmt32emu_${PKG_VERSION//./_}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A software synthesiser emulating pre-GM MIDI devices such as the Roland MT-32."

PKG_CMAKE_OPTS_TARGET="-D munt_WITH_MT32EMU_QT=0 \
                       -D munt_WITH_MT32EMU_SMF2WAV=0 \
                       -D libmt32emu_SHARED=1"
