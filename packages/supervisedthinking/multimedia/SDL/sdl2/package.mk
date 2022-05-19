# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="sdl2"
PKG_VERSION="2.0.16"
PKG_SHA256="bfb53c5395ff2862d07617b23939fca9a752c2f4d2424e617cedd083390b0143"
PKG_LICENSE="SDL"
PKG_SITE="https://www.libsdl.org/"
PKG_URL="https://github.com/libsdl-org/SDL/archive/refs/tags/release-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain alsa-lib systemd dbus"
PKG_LONGDESC="Simple DirectMedia Layer is a cross-platform development library for portable low-level access to a video framebuffer, audio output, mouse, and keyboard."

configure_package() {
  # Apply project specific patches
  PKG_PATCH_DIRS+=" ${PROJECT}"

  # Assembly support for x86_64
  if [ "${TARGET_ARCH}" = "x86_64" ]; then
    PKG_DEPENDS_TARGET+=" nasm:host"
  fi

  # X11 support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_DEPENDS_TARGET+=" libX11 libXrandr"
  fi

  # Wayland support
  if [ "${DISPLAYSERVER}" = "weston" ]; then
    PKG_DEPENDS_TARGET+=" wayland"
  fi

  # OpenGL support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGL}"
  fi

  # OpenGLES support
  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGLES}"
  fi

  # OpenGLES support
  if [ "${VULKAN_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${VULKAN}"
  fi

  # Pulseaudio support
  if [ "${PULSEAUDIO_SUPPORT}" = yes ]; then
    PKG_DEPENDS_TARGET+=" pulseaudio"
  fi
}

pre_configure_target(){
  PKG_CMAKE_OPTS_TARGET="-D3DNOW=OFF \
                         -DALSA=ON \
                         -DALSA_SHARED=ON \
                         -DALTIVEC=OFF \
                         -DARTS=OFF \
                         -DARTS_SHARED=OFF \
                         -DASAN=OFF \
                         -DBACKGROUNDING_SIGNAL=OFF \
                         -DCLOCK_GETTIME=OFF \
                         -DDIRECTFB_SHARED=OFF \
                         -DDIRECTX=OFF \
                         -DDISKAUDIO=OFF \
                         -DDUMMYAUDIO=OFF \
                         -DESD=OFF \
                         -DESD_SHARED=OFF \
                         -DFOREGROUNDING_SIGNAL=OFF \
                         -DFUSIONSOUND=OFF \
                         -DFUSIONSOUND_SHARED=OFF \
                         -DGCC_ATOMICS=ON \
                         -DHIDAPI=OFF \
                         -DJACK=OFF \
                         -DJACK_SHARED=OFF \
                         -DJOYSTICK_VIRTUAL=OFF \
                         -DLIBC=ON \
                         -DLIBSAMPLERATE=OFF \
                         -DLIBSAMPLERATE_SHARED=OFF \
                         -DNAS=OFF \
                         -DNAS_SHARED=OFF \
                         -DOSS=OFF \
                         -DPIPEWIRE=OFF \
                         -DPIPEWIRE_SHARED=OFF \
                         -DPTHREADS=ON \
                         -DPTHREADS_SEM=ON \
                         -DRENDER_D3D=OFF \
                         -DRENDER_METAL=OFF \
                         -DRPATH=OFF \
                         -DSDL_DLOPEN=ON \
                         -DSDL_STATIC_PIC=OFF \
                         -DSDL_TEST=OFF \
                         -DSNDIO=OFF \
                         -DSNDIO_SHARED=OFF \
                         -DSSEMATH=OFF \
                         -DVIDEO_COCOA=OFF \
                         -DVIDEO_DIRECTFB=OFF \
                         -DVIDEO_DUMMY=OFF \
                         -DVIDEO_METAL=OFF \
                         -DVIDEO_OFFSCREEN=OFF \
                         -DVIDEO_VIVANTE=OFF \
                         -DVIDEO_WAYLAND_QT_TOUCH=ON \
                         -DWASAPI=OFF \
                         -DWAYLAND_SHARED=OFF \
                         -DXINPUT=OFF"

  # Pulseaudio Support
  if [ "${PULSEAUDIO_SUPPORT}" = yes ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DPULSEAUDIO=ON \
                             -DPULSEAUDIO_SHARED=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DPULSEAUDIO=OFF \
                             -DPULSEAUDIO_SHARED=OFF"
  fi

  # Displayserver
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DVIDEO_WAYLAND=OFF \
                             -DVIDEO_X11=ON \
                             -DVIDEO_X11_XCURSOR=OFF \
                             -DVIDEO_X11_XINERAMA=OFF \
                             -DVIDEO_X11_XINPUT=OFF \
                             -DVIDEO_X11_XRANDR=ON \
                             -DVIDEO_X11_XSCRNSAVER=OFF \
                             -DVIDEO_X11_XSHAPE=OFF \
                             -DVIDEO_X11_XVM=OFF \
                             -DX11_SHARED=ON"
  elif [ "${DISPLAYSERVER}" = "weston" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DVIDEO_WAYLAND=ON \
                             -DVIDEO_X11=OFF"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DVIDEO_X11=OFF"
  fi

  # KMSDRM Support
  if [ "${OPENGLES}" = "mesa" ] || [ "${OPENGL}" = "mesa" ] || [ "${OPENGLES}" = "libmali" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DKMSDRM_SHARED=ON \
                             -DVIDEO_KMSDRM=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DKMSDRM_SHARED=OFF \
                             -DVIDEO_KMSDRM=OFF"
  fi

  # OpenGL Support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DVIDEO_OPENGL=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DVIDEO_OPENGL=OFF"
  fi

  # OpenGLES Support
  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DVIDEO_OPENGLES=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DVIDEO_OPENGLES=OFF"
  fi

  # RPi Video Support
  if [ "${OPENGLES}" = "bcm2835-driver" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DVIDEO_RPI=ON \
                             -DVIDEO_VULKAN=OFF \
                             -DVIDEO_KMSDRM=OFF"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DVIDEO_RPI=OFF"
  fi

  # Vulkan Support
  if [ "${VULKAN_SUPPORT}" = "yes" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DVIDEO_VULKAN=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DVIDEO_VULKAN=OFF"
  fi

  # MMX Support
  if target_has_feature mmx; then
    PKG_CMAKE_OPTS_TARGET+=" -DMMX=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DMMX=OFF"
  fi

  # NEON Support
  if target_has_feature neon; then
    PKG_CMAKE_OPTS_TARGET+=" -DARMNEON=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DARMNEON=OFF"
  fi

  # SSE Support
  if target_has_feature sse; then
    PKG_CMAKE_OPTS_TARGET+=" -DSSE=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DSSE=OFF"
  fi

  # SSE2 Support
  if target_has_feature sse2; then
    PKG_CMAKE_OPTS_TARGET+=" -DSSE2=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DSSE2=OFF"
  fi
}

post_makeinstall_target() {
  # fix config
  sed -e "s:\(['=\" ]\)/usr:\\1${SYSROOT_PREFIX}/usr:g" -i ${SYSROOT_PREFIX}/usr/bin/sdl2-config

  # clean up
  safe_remove ${INSTALL}/usr/bin
}
