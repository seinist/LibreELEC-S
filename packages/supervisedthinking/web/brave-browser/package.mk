# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="brave-browser"
PKG_VERSION="1.0.3"
PKG_ARCH="x86_64"
PKG_LICENSE="MPL-2.0"
PKG_SITE="https://brave.com"
PKG_DEPENDS_TARGET="toolchain gtk3-system libXcomposite libXcursor libxshmfence-system libxss nss scrnsaverproto atk cups unclutter-xfixes"
PKG_LONGDESC="Web browser that blocks ads and trackers by default"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  # Create directories
  mkdir -p ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/config/BraveSoftware/Brave-Browser
  mkdir -p ${INSTALL}/usr/share/applications
  mkdir -p ${INSTALL}/usr/local/share/applications
  mkdir -p ${INSTALL}/usr/share/applications/
  mkdir -p ${INSTALL}/opt/brave.com
  
  # Copy scripts, config files & resources
  cp -v ${PKG_DIR}/config/mimeapps.list                  ${INSTALL}/usr/local/share/applications/
  cp -v ${PKG_DIR}/config/brave-default-flags.conf       ${INSTALL}/opt/brave.com
  cp -v ${PKG_DIR}/files/DefaultAddonWebSkinBrave.png    ${INSTALL}/opt/brave.com
  cp -rfv ${PKG_DIR}/scripts/*                           ${INSTALL}/usr/bin/

  # Create symlinks to working directories
  ln -sv /usr/local/share/applications/mimeapps.list             ${INSTALL}/usr/share/applications/
  ln -sv /storage/.cache/brave-browser.pkg/brave-browser.desktop ${INSTALL}/usr/share/applications/
  ln -sv /storage/.cache/brave-browser.pkg                       ${INSTALL}/opt/brave.com/brave
  ln -sv /usr/bin/brave-browser.start                            ${INSTALL}/usr/bin/brave-browser-stable
}
