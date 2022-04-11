# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="Rockchip"
PKG_VERSION="1.0.3"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://bit.ly/3vL5rH3"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Metapackage for various LibreELEC-RR OEM packages"
PKG_TOOLCHAIN="manual"

################################################################################
# Setup packages included in Rockchip images
################################################################################

# Applications
OEM_APPLICATIONS_ROCKCHIP=""

# Libretro cores 
OEM_EMULATORS_LIBRETRO_ROCKCHIP=" \
  retroarch \
  2048 \
  atari800 \
  beetle-lynx \
  beetle-pce-fast \
  beetle-pcfx \
  beetle-wswan \
  bluemsx \
  chailove \
  desmume \
  dosbox-pure \
  ecwolf \
  fbneo \
  fceumm \
  flycast \
  fuse-libretro \
  gambatte \
  genesis-plus-gx \
  genesis-plus-gx-wide \
  mame2003-plus \
  mame2010 \
  mame2016 \
  mesen \
  mgba \
  mrboom \
  mupen64plus-nx \
  nestopia \
  opera \
  pcsx_rearmed \
  prboom \
  prosystem \
  sameboy \
  scummvm \
  snes9x \
  snes9x2010 \
  stella2014 \
  tyrquake \
  vice-libretro \
  virtualjaguar \
  yabasanshiro \
  yabause"

# Standalone emulators
OEM_EMULATORS_STANDALONE_ROCKCHIP=" \
  emulationstation \
  amiberry \
  dosbox-staging \
  hatari \
  openbor \
  ppsspp"

# Extra frontends
OEM_FRONTENDS_EXTRA_ROCKCHIP=" \
  pegasus-frontend"

# Linux drivers
OEM_LINUX_KERNEL_DRIVERS_ROCKCHIP=" \
  xpadneo"

# Non free packages
OEM_NON_FREE_PACKAGES_ROCKCHIP=" \
  xow"

# Streaming clients
OEM_STREAMING_CLIENTS_ROCKCHIP=" \
  moonlight-qt" 

# Tools
OEM_TOOLS_ROCKCHIP=" \
  apitrace \
  dhrystone-benchmark \
  ds4drv \
  evtest \
  glmark2 \
  htop-system \
  lm-sensors \
  midnight-commander \
  rr-config-tool \
  sdl-jstest \
  skyscraper"

################################################################################
# Install OEM packages to LibreELEC-RR
################################################################################

configure_package() {
  if [ "${OEM_SUPPORT}" = "yes" ]; then

    # Add application packages
    if [ "${OEM_APPLICATIONS}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_APPLICATIONS_ROCKCHIP}"
    fi

    # Add Emulationstation frontend & standalone emulator packages
    if [ "${OEM_EMULATORS}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_EMULATORS_STANDALONE_ROCKCHIP}"
    fi

    # Add additional frontend packages
    if [ "${OEM_FRONTENDS_EXTRA}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_FRONTENDS_EXTRA_ROCKCHIP}"
    fi

    # Add Retroarch frontend & libretro core packages 
    if [ "${OEM_LIBRETRO}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_EMULATORS_LIBRETRO_ROCKCHIP}"
    fi

    # Add Linux driver packages
    if [ "${OEM_LINUX_KERNEL_DRIVER_SUPPORT}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_LINUX_KERNEL_DRIVERS_ROCKCHIP}"
    fi

    # Add non free packages
    if [ "${NON_FREE_PKG_SUPPORT}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_NON_FREE_PACKAGES_ROCKCHIP}"
    fi

    # Add streaming packages
    if [ "${OEM_STREAMING_CLIENTS}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_STREAMING_CLIENTS_ROCKCHIP}"
    fi

    # Add tool packages
    if [ "${OEM_TOOLS}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_TOOLS_ROCKCHIP}"
    fi
  fi
}

makeinstall_target() {
  # Create directories
  mkdir -p ${INSTALL}

  # Install OEM config files & scripts
  cp -PRv ${PKG_DIR}/config/* ${INSTALL}
}
