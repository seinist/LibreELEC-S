# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking @ gmail.com)

PKG_NAME="qt5"
PKG_VERSION="e507d3e5041710bcb739ce0cafb33695ca85a49d" # 5.15.3+kde+r137 (KDE Qt5PatchCollection qtbase release)
PKG_LICENSE="GPL"
PKG_SITE="http://qt-project.org"
PKG_URL="https://invent.kde.org/qt/qt/qt5.git"
PKG_DEPENDS_TARGET="toolchain openssl libjpeg-turbo libpng pcre2-system sqlite zlib freetype sdl2 libxkbcommon gstreamer gst-plugins-base gst-plugins-good gst-libav"
PKG_LONGDESC="A cross-platform application and UI framework"
GET_HANDLER_SUPPORT="git"
PKG_GIT_CLONE_BRANCH="kde/5.15"
PKG_GIT_CLONE_SINGLE="yes"
PKG_BUILD_FLAGS="-gold"

configure_package() {
  # Apply project specific patches
  PKG_PATCH_DIRS="${PROJECT}"

  # Build with OpenGL / OpenGLES support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGL}"
  elif [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGLES}"
  fi

  # Build with XCB support for X11
  if [ ${DISPLAYSERVER} = "x11" ]; then
    PKG_DEPENDS_TARGET+=" xcb-util xcb-util-image xcb-util-keysyms xcb-util-renderutil xcb-util-wm"
  fi

  # Wayland support
  if [ "${DISPLAYSERVER}" = "wl" ]; then
    PKG_DEPENDS_TARGET+=" wayland"
  fi
}

pre_configure_target() {
  PKG_CONFIGURE_OPTS_TARGET="-prefix /usr
                             -sysroot ${SYSROOT_PREFIX}
                             -hostprefix ${TOOLCHAIN}
                             -device linux-libreelec-g++
                             -device-option CROSS_COMPILE=${TARGET_PREFIX}
                             -fontconfig
                             -opensource -confirm-license
                             -release
                             -shared
                             -make libs
                             -nomake examples -no-compile-examples
                             -nomake tests
                             -ccache
                             -gstreamer 1.0
                             -force-pkg-config
                             -silent
                             -no-use-gold-linker
                             -no-ltcg
                             -no-rpath
                             -openssl-linked
                             -system-libjpeg
                             -system-libpng
                             -system-pcre
                             -system-sqlite
                             -system-zlib
                             -no-accessibility
                             -no-cups
                             -no-evdev
                             -no-glib
                             -no-harfbuzz
                             -no-iconv
                             -no-icu
                             -no-libproxy
                             -no-mtdev
                             -no-sql-mysql
                             -no-strip
                             -no-tiff
                             -no-tslib
                             -no-feature-linuxfb
                             -no-feature-vulkan
                             -no-feature-openal
                             -no-feature-qml-debug
                             -no-feature-printer
                             -no-feature-vnc
                             -skip qt3d
                             -skip qtactiveqt
                             -skip qtandroidextras
                             -skip qtcanvas3d
                             -skip qtcharts
                             -skip qtconnectivity
                             -skip qtdatavis3d
                             -skip qtdoc
                             -skip qtdocgallery
                             -skip qtfeedback
                             -skip qtlocation
                             -skip qtlottie
                             -skip qtmacextras
                             -skip qtnetworkauth
                             -skip qtpurchasing
                             -skip qtqa
                             -skip qtquickcontrols
                             -skip qtquicktimeline
                             -skip qtpim
                             -skip qtremoteobjects
                             -skip qtrepotools
                             -skip qtscript
                             -skip qtscxml
                             -skip qtsensors
                             -skip qtserialport
                             -skip qtserialbus
                             -skip qtspeech
                             -skip qtsystems
                             -skip qttranslations
                             -skip qtvirtualkeyboard
                             -skip qtwebchannel
                             -skip qtwebengine
                             -skip qtwebglplugin
                             -skip qtwebview
                             -skip qtwinextras
                             -skip qtx11extras"

  # Build with OpenGL or OpenGLES support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_CONFIGURE_OPTS_TARGET+=" -opengl -no-eglfs"
  elif [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_CONFIGURE_OPTS_TARGET+=" -opengl es2"
  fi

  # Wayland support
  if [ ! "${DISPLAYSERVER}" = "wl" ]; then
    PKG_CONFIGURE_OPTS_TARGET+=" -skip qtwayland"
  fi

  # Build only Generic with reduced relocations https://bugreports.qt.io/browse/QTBUG-36129
  if [ ${ARCH} = "x86_64" ]; then
    PKG_CONFIGURE_OPTS_TARGET+=" -reduce-relocations"
  fi
}

configure_target() {
  # Create working dir
  mkdir -p ${PKG_BUILD}/.${TARGET_NAME}
  cd ${PKG_BUILD}/.${TARGET_NAME}

  # Avoid eglfs_brcm detection by bcm_host.h
  if [ "${DEVICE}" = "RPi4" -o "${DEVICE}" = "RPi3" ]; then
    sed -e "s#bcm_host.h#bcm_host2.h#" -i ${PKG_BUILD}/qtbase/src/gui/configure.json
  fi

  # Create mkspecs file
  QMAKE_CONF_DIR="${PKG_BUILD}/qtbase/mkspecs/devices/linux-libreelec-g++"
  QMAKE_CONF="${QMAKE_CONF_DIR}/qmake.conf"
  mkdir -p ${QMAKE_CONF_DIR}

  # Set QMake Platform Flags
  echo "MAKEFILE_GENERATOR       = UNIX"           > ${QMAKE_CONF}
  echo "CONFIG                  += incremental"   >> ${QMAKE_CONF}
  echo "QMAKE_INCREMENTAL_STYLE  = sublib"        >> ${QMAKE_CONF}
  echo "include(../../common/linux.conf)"         >> ${QMAKE_CONF}
  echo "include(../../common/gcc-base-unix.conf)" >> ${QMAKE_CONF}
  echo "include(../../common/g++-unix.conf)"      >> ${QMAKE_CONF}
  echo "load(device_config)"                      >> ${QMAKE_CONF}
  echo "QMAKE_CC                = ${CC}"          >> ${QMAKE_CONF}
  echo "QMAKE_CXX               = ${CXX}"         >> ${QMAKE_CONF}
  echo "QMAKE_LINK              = ${CXX}"         >> ${QMAKE_CONF}
  echo "QMAKE_LINK_SHLIB        = ${CXX}"         >> ${QMAKE_CONF}
  echo "QMAKE_AR                = ${AR} cqs"      >> ${QMAKE_CONF}
  echo "QMAKE_OBJCOPY           = ${OBJCOPY}"     >> ${QMAKE_CONF}
  echo "QMAKE_NM                = ${NM} -P"       >> ${QMAKE_CONF}
  echo "QMAKE_STRIP             = ${STRIP}"       >> ${QMAKE_CONF}
  echo "QMAKE_CFLAGS            = ${CFLAGS}"      >> ${QMAKE_CONF}
  echo "QMAKE_CXXFLAGS          = ${CXXFLAGS}"    >> ${QMAKE_CONF}
  echo "QMAKE_LFLAGS            = ${LDFLAGS}"     >> ${QMAKE_CONF}
  # Set Mesa 3D OpenGL ES based project flags
  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    if [ ${DISPLAYSERVER} = "no" ]; then
      echo "QMAKE_LIBS_EGL += -lEGL"              >> ${QMAKE_CONF}
      echo "EGLFS_DEVICE_INTEGRATION = eglfs_kms" >> ${QMAKE_CONF}
    elif [ ${DISPLAYSERVER} = "wl" ]; then
      echo "DEFINES += QT_EGL_NO_X11"             >> ${QMAKE_CONF}
    fi
  fi
  echo "load(qt_config)"                            >> ${QMAKE_CONF}
  echo '#include "../../linux-g++/qplatformdefs.h"' >> ${QMAKE_CONF_DIR}/qplatformdefs.h

  unset CC CXX LD RANLIB AR AS CPPFLAGS CFLAGS LDFLAGS CXXFLAGS
  export QT_FORCE_PKGCONFIG=yes
  ${PKG_BUILD}/configure ${PKG_CONFIGURE_OPTS_TARGET}
}

post_makeinstall_target() {
  # Remove references to the build directory from installed library dependencies
  find ${PKG_ORIG_SYSROOT_PREFIX}/usr/lib/ -name \*.prl -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

  for PKG_CONFIGS in $(find "${PKG_ORIG_SYSROOT_PREFIX}/usr/lib" -type f -name "Qt*.pc" 2>/dev/null); do
    sed -e "s#prefix=.*#prefix=/usr#g" -i "${PKG_CONFIGS}"
  done

  for PKG_PRI in $(find "${TOOLCHAIN}/mkspecs" -type f -name "*.pri" 2>/dev/null); do
    sed -E "s#${PKG_ORIG_SYSROOT_PREFIX}/usr/lib/lib([^.]+)\.(so|a)# -l\1#g" -i "${PKG_PRI}"
  done

  # Create directories
  mkdir -p ${INSTALL}/usr/lib
  mkdir -p ${INSTALL}/usr/plugins
  mkdir -p ${INSTALL}/usr/qml

  # Sysroot path to Qt5 files
  PKG_QT5_SYSROOT_PATH=${PKG_ORIG_SYSROOT_PREFIX:-${SYSROOT_PREFIX}}/usr/

  # Install Qt5 libs
  for PKG_QT5_LIBS in \
    libQt5Concurrent libQt5Core libQt5DBus libQt5Gamepad libQt5Gui libQt5Multimedia libQt5MultimediaGstTools libQt5MultimediaQuick \
    libQt5MultimediaWidgets libQt5Network libQt5OpenGL libQt5Qml libQt5QmlModels libQt5QmlWorkerScript libQt5Quick libQt5QuickControls2 libQt5QuickParticles \
    libQt5QuickTemplates2 libQt5QuickTest libQt5Sql libQt5Svg libQt5Test libQt5Widgets libQt5WebSockets libQt5Xml
  do
    cp -PR ${PKG_QT5_SYSROOT_PATH}/lib/${PKG_QT5_LIBS}.so* ${INSTALL}/usr/lib
  done

  # Install Qt5 plugins
  for PKG_QT5_PLUGINS in \
    audio gamepads imageformats iconengines mediaservice platforms playlistformats sqldrivers
  do
    cp -PR ${PKG_QT5_SYSROOT_PATH}/plugins/${PKG_QT5_PLUGINS} ${INSTALL}/usr/plugins
  done

  # Install Qt5 QML
  for PKG_QT5_QML in \
    Qt QtGamepad QtGraphicalEffects QtMultimedia QtQuick QtQuick.2 QtTest
  do
    cp -PR ${PKG_QT5_SYSROOT_PATH}/qml/${PKG_QT5_QML} ${INSTALL}/usr/qml
  done

  # Install libs, plugins & qml for Wayland/X11 display server
  if [ ${DISPLAYSERVER} = "x11" ]; then
    cp -PR ${PKG_QT5_SYSROOT_PATH}/lib/libQt5XcbQpa.so*      ${INSTALL}/usr/lib
    cp -PR ${PKG_QT5_SYSROOT_PATH}/plugins/xcbglintegrations ${INSTALL}/usr/plugins
  elif [ ${DISPLAYSERVER} = "wl" ]; then
    cp -PR ${PKG_QT5_SYSROOT_PATH}/lib/libQt5WaylandClient.so*     ${INSTALL}/usr/lib
    cp -PR ${PKG_QT5_SYSROOT_PATH}/lib/libQt5WaylandCompositor.so* ${INSTALL}/usr/lib

    cp -PR ${PKG_QT5_SYSROOT_PATH}/plugins/platforms/libqwayland*              ${INSTALL}/usr/plugins/platforms
    cp -PR ${PKG_QT5_SYSROOT_PATH}/plugins/wayland-decoration-client           ${INSTALL}/usr/plugins
    cp -PR ${PKG_QT5_SYSROOT_PATH}/plugins/wayland-graphics-integration-client ${INSTALL}/usr/plugins
    cp -PR ${PKG_QT5_SYSROOT_PATH}/plugins/wayland-graphics-integration-server ${INSTALL}/usr/plugins
    cp -PR ${PKG_QT5_SYSROOT_PATH}/plugins/wayland-shell-integration           ${INSTALL}/usr/plugins

    cp -PR ${PKG_QT5_SYSROOT_PATH}/qml/QtWayland ${INSTALL}/usr/qml
  fi

  # Install EGLFS libs & plugins if OpenGLES is supported
  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    if [ ${DISPLAYSERVER} = "no" ]; then
      cp -PR ${PKG_QT5_SYSROOT_PATH}/lib/libQt5EglFSDeviceIntegration.so* ${INSTALL}/usr/lib
      cp -PR ${PKG_QT5_SYSROOT_PATH}/plugins/egldeviceintegrations        ${INSTALL}/usr/plugins
    fi
  fi

  # Install EGLFS_KMS lib
  if [ "${OPENGLES}" = "libmali" ] || [ "${OPENGLES}" = "mesa" ]; then
    cp -PR ${PKG_QT5_SYSROOT_PATH}/lib/libQt5EglFsKmsSupport.so* ${INSTALL}/usr/lib
  fi
}

