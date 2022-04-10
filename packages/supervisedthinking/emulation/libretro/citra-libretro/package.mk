# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="citra-libretro"
PKG_VERSION="44e01f99016008eff18bc7a28234d1098382358d"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/citra"
PKG_URL="https://github.com/libretro/citra.git"
PKG_DEPENDS_TARGET="toolchain linux glibc boost-system"
PKG_LONGDESC="A Nintendo 3DS Emulator, running on libretro"
GET_HANDLER_SUPPORT="git"
PKG_BUILD_FLAGS="+lto -sysroot"
PKG_TOOLCHAIN="make"

PKG_LIBNAME="citra_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"

configure_package() {
  # OpenGL Support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGL}"
  fi

  # OpenGLES Support
  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGLES}"
  fi
}

pre_make_target() {
  cd ${PKG_BUILD}
  PKG_MAKE_OPTS_TARGET="GIT_REV=${PKG_VERSION:0:7} \
                        HAVE_FFMPEG_STATIC=1 \
                        FFMPEG_DISABLE_VDPAU=1 \
                        HAVE_FFMPEG_CROSSCOMPILE=1 \
                        FFMPEG_XC_CPU=${TARGET_CPU} \
                        FFMPEG_XC_ARCH=${TARGET_ARCH} \
                        FFMPEG_XC_PREFIX=${TARGET_PREFIX} \
                        FFMPEG_XC_SYSROOT=${SYSROOT_PREFIX} \
                        FFMPEG_XC_NM=${NM} \
                        FFMPEG_XC_AR=${AR} \
                        FFMPEG_XC_AS=${CC} \
                        FFMPEG_XC_CC=${CC} \
                        FFMPEG_XC_LD=${CC}"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
    cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}
