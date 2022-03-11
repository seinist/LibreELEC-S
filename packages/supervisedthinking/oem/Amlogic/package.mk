# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="Amlogic"
PKG_VERSION="1.0.5"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://bit.ly/3vL5rH3"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Metapackage for various LibreELEC-RR OEM packages"
PKG_TOOLCHAIN="manual"

################################################################################
# Setup packages included in Amlogic images
################################################################################

# Applications
OEM_APPLICATIONS_AMLOGIC=""

# Libretro cores 
OEM_EMULATORS_LIBRETRO_AMLOGIC=" \
  retroarch \
  2048 \
  a5200 \
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
  superbroswar \
  tyrquake \
  vice-libretro \
  virtualjaguar \
  yabasanshiro \
  yabause"

# Libretro cores for A311D & S922X
OEM_EMULATORS_LIBRETRO_AMLOGIC_AMLG12B=" \
  mame2016"

# Standalone emulators
OEM_EMULATORS_STANDALONE_AMLOGIC=" \
  emulationstation \
  amiberry \
  dosbox-staging \
  hatari \
  openbor \
  ppsspp"

# Frontends
OEM_FRONTENDS_EXTRA_AMLOGIC=" \
  pegasus-frontend"

# Linux drivers
OEM_LINUX_KERNEL_DRIVERS_AMLOGIC=" \
  xpadneo"

# Non free packages
OEM_NON_FREE_PACKAGES_AMLOGIC=" \
  xow"

# Streaming clients
OEM_STREAMING_CLIENTS_AMLOGIC=" \
  moonlight-qt" 

# Tools
OEM_TOOLS_AMLOGIC=" \
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
      PKG_DEPENDS_TARGET+=" ${OEM_APPLICATIONS_AMLOGIC}"
    fi

    # Add Emulationstation frontend & standalone emulator packages
    if [ "${OEM_EMULATORS}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_EMULATORS_STANDALONE_AMLOGIC}"
    fi

    # Add additional frontend packages
    if [ "${OEM_FRONTENDS_EXTRA}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_FRONTENDS_EXTRA_AMLOGIC}"
    fi

    # Add Retroarch frontend & libretro core packages 
    if [ "${OEM_LIBRETRO}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_EMULATORS_LIBRETRO_AMLOGIC}"
      # Add device specific libretro core packages 
      if [ "${DEVICE}" = "AMLG12B" ]; then
        PKG_DEPENDS_TARGET+=" ${OEM_EMULATORS_LIBRETRO_AMLOGIC_AMLG12B}"
      fi
    fi

    # Add Linux driver packages
    if [ "${OEM_LINUX_KERNEL_DRIVER_SUPPORT}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_LINUX_KERNEL_DRIVERS_AMLOGIC}"
    fi

    # Add non free packages
    if [ "${NON_FREE_PKG_SUPPORT}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_NON_FREE_PACKAGES_AMLOGIC}"
    fi

    # Add streaming packages
    if [ "${OEM_STREAMING_CLIENTS}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_STREAMING_CLIENTS_AMLOGIC}"
    fi

    # Add tool packages
    if [ "${OEM_TOOLS}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_TOOLS_AMLOGIC}"
    fi
  fi
}

makeinstall_target() {
  # Create directories
  mkdir -p ${INSTALL}

  # Install OEM config files & scripts
  cp -PRv ${PKG_DIR}/config/* ${INSTALL}
}
