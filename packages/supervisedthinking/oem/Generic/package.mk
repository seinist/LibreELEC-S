# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="Generic"
PKG_VERSION="1.0.4"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://bit.ly/3vL5rH3"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Metapackage for various LibreELEC-RR OEM packages"
PKG_TOOLCHAIN="manual"

################################################################################
# Setup packages included in Generic images
################################################################################

# Applications
OEM_APPLICATIONS_GENERIC=" \
  brave-browser \
  spotify"

# Libretro cores
OEM_EMULATORS_LIBRETRO_GENERIC=" \
  retroarch \
  2048 \
  atari800 \
  beetle-lynx \
  beetle-pce-fast \
  beetle-pcfx \
  beetle-psx \
  beetle-saturn \
  beetle-wswan \
  bluemsx \
  bsnes \
  bsnes-hd \
  bsnes-mercury-accuracy \
  bsnes-mercury-balanced \
  chailove \
  citra-libretro \
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
  kronos \
  mame2003-plus \
  mame2016 \
  mesen \
  mgba \
  mrboom \
  mupen64plus-nx \
  nestopia \
  nside \
  opera \
  parallel-n64 \
  pcsx_rearmed \
  ppsspp-libretro \
  prboom \
  prosystem \
  sameboy \
  scummvm \
  snes9x \
  stella2014 \
  swanstation \
  tyrquake \
  uae \
  vice-libretro \
  virtualjaguar \
  yabasanshiro"

OEM_EMULATORS_LIBRETRO_GENERIC_X11=" \
  boom3 \
  dolphin-libretro
  vitaquake2 \
  vitaquake3"

# Standalone emulators
OEM_EMULATORS_STANDALONE_GENERIC=" \
  emulationstation \
  dosbox-staging \
  hatari \
  openbor \
  ppsspp"

# Standalone emulators X11
OEM_EMULATORS_STANDALONE_GENERIC_X11=" \
  citra \
  dolphin \
  fs-uae \
  mupen64plus \
  pcsx2 \
  rpcs3 \
  vice"

# Frontends
OEM_FRONTENDS_EXTRA_GENERIC=" \
  pegasus-frontend"

# Linux drivers
OEM_LINUX_KERNEL_DRIVERS_GENERIC=" \
  xone \
  xpadneo"

# Non free packages
OEM_NON_FREE_PACKAGES_GENERIC=" \
  xow"

# Streaming clients
OEM_STREAMING_CLIENTS_GENERIC=" \
  moonlight-qt" 

# Tools
OEM_TOOLS_GENERIC=" \
  dhrystone-benchmark \
  dmidecode \
  ds4drv \
  evtest \
  glmark2 \
  htop-system \
  lm-sensors \
  midnight-commander \
  rr-config-tool \
  sdl-jstest \
  skyscraper \
  smartmontools \
  spectre-meltdown-checker \
  vkmark \
  vulkan-tools"

# Tools X11
OEM_TOOLS_GENERIC_X11=" \
  mesa-demos-system \
  tigervnc-system"

################################################################################
# Install OEM packages to LibreELEC-RR
################################################################################

configure_package() {
  if [ "${OEM_SUPPORT}" = "yes" ]; then

    # Add application packages
    if [ "${OEM_APPLICATIONS}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_APPLICATIONS_GENERIC}"
    fi

    # Add Emulationstation frontend & standalone emulator packages
    if [ "${OEM_EMULATORS}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_EMULATORS_STANDALONE_GENERIC}"
      if [ "${DISPLAYSERVER}" = "x11" ]; then
        PKG_DEPENDS_TARGET+=" ${OEM_EMULATORS_STANDALONE_GENERIC_X11}"
      fi
    fi

    # Add additional frontend packages
    if [ "${OEM_FRONTENDS_EXTRA}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_FRONTENDS_EXTRA_GENERIC}"
    fi

    # Add Retroarch frontend & libretro core packages 
    if [ "${OEM_LIBRETRO}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_EMULATORS_LIBRETRO_GENERIC}"
      if [ "${DISPLAYSERVER}" = "x11" ]; then
        PKG_DEPENDS_TARGET+=" ${OEM_EMULATORS_LIBRETRO_GENERIC_X11}"
      fi
    fi

    # Add Linux driver packages
    if [ "${OEM_LINUX_KERNEL_DRIVER_SUPPORT}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_LINUX_KERNEL_DRIVERS_GENERIC}"
    fi

    # Add non free packages
    if [ "${NON_FREE_PKG_SUPPORT}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_NON_FREE_PACKAGES_GENERIC}"
    fi

    # Add streaming packages
    if [ "${OEM_STREAMING_CLIENTS}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_STREAMING_CLIENTS_GENERIC}"
    fi

    # Add tool packages
    if [ "${OEM_TOOLS}" = "yes" ]; then
      PKG_DEPENDS_TARGET+=" ${OEM_TOOLS_GENERIC}"
      if [ "${DISPLAYSERVER}" = "x11" ]; then
        PKG_DEPENDS_TARGET+=" ${OEM_TOOLS_GENERIC_X11}"
      fi
    fi
  fi
}

makeinstall_target() {
  # Create directories
  mkdir -p ${INSTALL}

  # Install OEM config files & scripts
  if [ -d ${PKG_DIR}/config/${DEVICE} ]; then
    cp -PRv ${PKG_DIR}/config/${DEVICE}/* ${INSTALL}
  else
    cp -PRv ${PKG_DIR}/config/* ${INSTALL}
  fi
}
