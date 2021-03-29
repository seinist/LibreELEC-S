# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mediacenter"
PKG_VERSION=""
PKG_LICENSE="GPL"
PKG_SITE="https://libreelec.tv"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain ${MEDIACENTER}"
PKG_SECTION="virtual"
PKG_LONGDESC="Mediacenter: Metapackage"

# Add existing Kodi binary addons to depends
rr_add_binary_addon() {
  [ -f ${ROOT}/${PACKAGES}/mediacenter/kodi-binary-addons/$1/package.mk ] && PKG_DEPENDS_TARGET="${PKG_DEPENDS_TARGET} ${1}" || true
}

if [ "${MEDIACENTER}" = "kodi" ]; then
  PKG_DEPENDS_TARGET+=" ${MEDIACENTER}-theme-${SKIN_DEFAULT}"

  for i in ${SKINS}; do
    PKG_DEPENDS_TARGET+=" ${MEDIACENTER}-theme-${i}"
  done

# python-based tool for kodi management
  PKG_DEPENDS_TARGET+=" texturecache.py"

# some python stuff needed for various addons
  PKG_DEPENDS_TARGET="${PKG_DEPENDS_TARGET} Pillow \
                                          simplejson \
                                          pycryptodome"

# settings addon
  if [ -n "${DISTRO_PKG_SETTINGS}" ]; then
    PKG_DEPENDS_TARGET+=" ${DISTRO_PKG_SETTINGS}"
  fi

# other packages
  PKG_DEPENDS_TARGET+=" xmlstarlet"

  if [ "${JOYSTICK_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" peripheral.joystick"
  fi

  get_graphicdrivers
  if listcontains "${GRAPHIC_DRIVERS}" "(crocus|i915|iris)"; then
    PKG_DEPENDS_TARGET+=" intel-vaapi-driver media-driver"
  fi

  if listcontains "${GRAPHIC_DRIVERS}" "nvidia-ng"; then
    PKG_DEPENDS_TARGET+=" nvidia-vaapi-driver"
  fi

  # Enable additional Kodi binary addons
  RR_BINARY_ADDONS_ARCHIVE="yes"
  RR_BINARY_ADDONS_PVR="yes"
  RR_BINARY_ADDONS_INPUTSTREAM="yes"
  RR_BINARY_ADDONS_OTHER="yes"
  RR_BINARY_ADDONS_STREAMING="yes"

  # Various archive tools
  if [ "${RR_BINARY_ADDONS_ARCHIVE}" = "yes" ]; then
    rr_add_binary_addon "vfs.libarchive"
    rr_add_binary_addon "vfs.rar"
  fi

  # Various InputStream addons
  if [ "${RR_BINARY_ADDONS_INPUTSTREAM}" = "yes" ]; then
    rr_add_binary_addon "inputstream.adaptive"
    rr_add_binary_addon "inputstream.ffmpegdirect"
    rr_add_binary_addon "inputstream.rtmp"
  fi

  # Various other binary addons
  if [ "${RR_BINARY_ADDONS_OTHER}" = "yes" ]; then
    rr_add_binary_addon "imagedecoder.heif"
    rr_add_binary_addon "imagedecoder.mpo"
    rr_add_binary_addon "imagedecoder.raw"
  fi

  # Various PVR clients
  if [ "${RR_BINARY_ADDONS_PVR}" = "yes" ]; then
    rr_add_binary_addon "pvr.argustv"
    rr_add_binary_addon "pvr.demo"
    rr_add_binary_addon "pvr.dvblink"
    rr_add_binary_addon "pvr.dvbviewer"
    rr_add_binary_addon "pvr.filmon"
    rr_add_binary_addon "pvr.freebox"
    rr_add_binary_addon "pvr.hdhomerun"
    rr_add_binary_addon "pvr.hts"
    rr_add_binary_addon "pvr.iptvsimple"
    rr_add_binary_addon "pvr.mediaportal.tvserver"
    rr_add_binary_addon "pvr.mythtv"
    rr_add_binary_addon "pvr.nextpvr"
    rr_add_binary_addon "pvr.njoy"
    rr_add_binary_addon "pvr.octonet"
    rr_add_binary_addon "pvr.pctv"
    rr_add_binary_addon "pvr.sledovanitv.cz"
    rr_add_binary_addon "pvr.stalker"
    rr_add_binary_addon "pvr.teleboy"
    rr_add_binary_addon "pvr.vbox"
    rr_add_binary_addon "pvr.vdr.vnsi"
    rr_add_binary_addon "pvr.vuplus"
    rr_add_binary_addon "pvr.wmc"
  fi

  # Various Streaming clients
  if [ "${RR_BINARY_ADDONS_STREAMING}" = "yes" ]; then
    rr_add_binary_addon "pvr.waipu"
    rr_add_binary_addon "pvr.zattoo"
  fi
fi
