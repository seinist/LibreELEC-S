# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="rpcs3"
PKG_VERSION="e68ffdbc81df87529f4e72afc20f5a3ea2c5cd4f" # 0.0.22-13640
PKG_ARCH="x86_64"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://rpcs3.net"
PKG_URL="https://github.com/RPCS3/rpcs3.git"
PKG_DEPENDS_HOST="toolchain:host"
PKG_DEPENDS_TARGET="toolchain linux glibc systemd pulseaudio mesa xorg-server openal-soft-system libevdev curl ffmpeg libpng zlib glew-cmake libSM sdl2 enet-system qt5 unclutter-xfixes rpcs3:host"
PKG_LONGDESC="RPCS3 is an experimental open-source Sony PlayStation 3 emulator and debugger."
GET_HANDLER_SUPPORT="git"
PKG_GIT_CLONE_BRANCH="master"
PKG_GIT_CLONE_SINGLE="yes"

configure_package() {
  # Vulkan Support
  if [ "${VULKAN_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${VULKAN}"
  fi
}

pre_configure_host() {
  PKG_CMAKE_SCRIPT="${PKG_BUILD}/llvm/CMakeLists.txt"
  PKG_CMAKE_OPTS_HOST="-D LLVM_TARGETS_TO_BUILD="X86" \
                       -D LLVM_BUILD_RUNTIME=OFF \
                       -D LLVM_BUILD_TOOLS=OFF \
                       -D LLVM_INCLUDE_BENCHMARKS=OFF \
                       -D LLVM_INCLUDE_DOCS=OFF \
                       -D LLVM_INCLUDE_EXAMPLES=OFF \
                       -D LLVM_INCLUDE_TESTS=OFF \
                       -D LLVM_INCLUDE_TOOLS=OFF \
                       -D LLVM_INCLUDE_UTILS=OFF \
                       -D LLVM_CCACHE_BUILD=ON \
                       -Wno-dev"
}

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET=(-D USE_NATIVE_INSTRUCTIONS=OFF \
                         -D BUILD_LLVM_SUBMODULE=ON \
                         -D CMAKE_C_FLAGS="${CFLAGS}" \
                         -D CMAKE_CXX_FLAGS="${CXXFLAGS}" \
                         -D LLVM_TARGET_ARCH="${TARGET_ARCH}" \
                         -D LLVM_TABLEGEN=${PKG_BUILD}/.${HOST_NAME}/bin/llvm-tblgen \
                         -D USE_DISCORD_RPC=OFF \
                         -D CMAKE_SKIP_RPATH=ON \
                         -D USE_SYSTEM_FFMPEG=ON \
                         -D USE_SYSTEM_LIBPNG=ON \
                         -D USE_SYSTEM_ZLIB=ON \
                         -D USE_SYSTEM_CURL=ON \
                         -Wno-dev)
}

configure_target() {
  echo "Executing (target): cmake ${CMAKE_GENERATOR_NINJA} ${TARGET_CMAKE_OPTS} "${PKG_CMAKE_OPTS_TARGET[@]}" $(dirname ${PKG_CMAKE_SCRIPT})" | tr -s " "
  cmake ${CMAKE_GENERATOR_NINJA} ${TARGET_CMAKE_OPTS} "${PKG_CMAKE_OPTS_TARGET[@]}" $(dirname ${PKG_CMAKE_SCRIPT})
}

make_host() {
  ninja ${NINJA_OPTS} llvm-tblgen
}

makeinstall_host() {
 :
}

pre_make_target() {
  # fix cross compiling
  find ${PKG_BUILD} -name flags.make  -exec sed -i "s:isystem :I:g" \{} \;
  find ${PKG_BUILD} -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
}

post_makeinstall_target() {
  # Copy scripts
  mkdir -p ${INSTALL}/usr/bin/
   cp ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin/

  # Copy config & resources
  mkdir -p ${INSTALL}/usr/config/rpcs3
   cp -PR ${PKG_DIR}/config/*                           ${INSTALL}/usr/config/rpcs3/
   cp -PR ${INSTALL}/usr/share/rpcs3/{GuiConfigs,Icons} ${INSTALL}/usr/config/rpcs3/ 
  
  # Clean up
  safe_remove ${INSTALL}/usr/share
}
