# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="amiberry"
PKG_VERSION="9c76e03b8ad4fae001e4ff23ba3b6444faf30950" # v5.2
PKG_ARCH="arm"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/midwan/amiberry"
PKG_URL="https://github.com/midwan/amiberry.git"
PKG_DEPENDS_TARGET="toolchain linux glibc bzip2 zlib sdl2 sdl2_image sdl2_ttf capsimg freetype libxml2 flac-system libogg-system mpg123-system libpng libmpeg2 retroarch-joypad-autoconfig"
PKG_LONGDESC="Optimized Amiga emulator for the Raspberry Pi and other ARM boards."
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="all"

pre_configure_target() {
  cd ${PKG_BUILD}
  export SDL_CONFIG=${SYSROOT_PREFIX}/usr/bin/sdl2-config

  # fix build of neon_helper.s
  AS="${CC}"

  case ${PROJECT} in
    Amlogic)
      AMIBERRY_PLATFORM="${DEVICE}"
      ;;
    Rockchip)
      AMIBERRY_PLATFORM="${DEVICE}"
      ;;
    RPi)
      if [ "${DEVICE}" = "RPi4" ]; then
        AMIBERRY_PLATFORM="rpi4-sdl2"
      else
        AMIBERRY_PLATFORM="rpi2-sdl2"
      fi
      ;;
  esac

  PKG_MAKE_OPTS_TARGET+=" PLATFORM=${AMIBERRY_PLATFORM}"
}

makeinstall_target() {
  # Create directories
  mkdir -p ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/config/amiberry/whdboot/game-data
  mkdir -p ${INSTALL}/usr/config/amiberry/controller
  mkdir -p ${INSTALL}/usr/share/amiberry/whdboot/save-data/

  # Copy ressources
  cp -a ${PKG_DIR}/config/*           ${INSTALL}/usr/config/amiberry/
  cp -a data                          ${INSTALL}/usr/config/amiberry/
  cp -a savestates                    ${INSTALL}/usr/config/amiberry/
  cp -a screenshots                   ${INSTALL}/usr/config/amiberry/
  ln -s /storage/roms/bios/Kickstarts ${INSTALL}/usr/config/amiberry/kickstarts

  # WHDLoad
  cp -a whdboot/save-data             ${INSTALL}/usr/config/amiberry/whdboot/
  cp -a whdboot/game-data             ${INSTALL}/usr/config/amiberry/whdboot/
  cp -a whdboot/save-data/Kickstarts/ ${INSTALL}/usr/config/amiberry/whdboot/save-data/
  cp -a whdboot/WHDLoad               ${INSTALL}/usr/config/amiberry/whdboot/
  cp -a whdboot/boot-data.zip         ${INSTALL}/usr/config/amiberry/whdboot/

  # Create links to Retroarch controller files
  ln -s /usr/share/retroarch/autoconfig/udev/8Bitdo_Pro_SF30_BT_B.cfg "${INSTALL}/usr/config/amiberry/controller/8Bitdo SF30 Pro.cfg"
  ln -s "/usr/share/retroarch/autoconfig/udev/Pro Controller.cfg"     "${INSTALL}/usr/config/amiberry/controller/Pro Controller.cfg"

  # Copy binary, scripts & link libcapsimg
  cp -av amiberry                      ${INSTALL}/usr/bin
  cp -a ${PKG_DIR}/scripts/*           ${INSTALL}/usr/bin
  ln -sf /usr/lib/libcapsimage.so.5.1  ${INSTALL}/usr/config/amiberry/capsimg.so
}
