#!/bin/bash

NDK=/home/peirenlei/myapplication/android/android-ndk-r9d
SYSROOT=$NDK/platforms/android-19/arch-arm/
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.6/prebuilt/linux-x86_64

CFLAGS="-O3 -Wall -mthumb -pipe -fpic -fasm \
  -finline-limit=300 -ffast-math \
  -fstrict-aliasing -Werror=strict-aliasing \
  -fmodulo-sched -fmodulo-sched-allow-regmoves \
  -Wno-psabi -Wa,--noexecstack \
  -D__ARM_ARCH_5__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5TE__ \
  -DANDROID -DNDEBUG"

#--extra-cflags="-Os -fpic $ADDI_CFLAGS" \

function build_one
{
./configure \
    --prefix=$PREFIX \
    --enable-shared \
    --disable-static \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --target-os=linux \
    --arch=arm \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="$CFLAGS $EXTRA_CFLAGS" \
    --extra-ldflags="$EXTRA_LDFLAGS" \
    --extra-libs=-lgcc
    $ADDITIONAL_CONFIGURE_FLAG

echo "build for $CPU"

make clean
make -j4
make install

echo "build finished >>> $PREFIX"

}

CPU=arm
PREFIX=$(pwd)/android/$CPU 
EXTRA_CFLAGS="-marm"
EXTRA_LDFLAGS=""
build_one

CPU=neno
PREFIX=$(pwd)/android/$CPU 
EXTRA_CFLAGS="-march=armv7-a -mfpu=neon -mfloat-abi=softfp -mvectorize-with-neon-quad"
EXTRA_LDFLAGS="-Wl,--fix-cortex-a8"
build_one


CPU=armv7
PREFIX=$(pwd)/android/$CPU
EXTRA_CFLAGS="-march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=softfp"
EXTRA_LDFLAGS="-Wl,--fix-cortex-a8"
build_one

#CPU=vfp
#PREFIX=$(pwd)/android/$CPU
#EXTRA_CFLAGS="-march=armv6 -mfpu=vfp -mfloat-abi=softfp"
#EXTRA_LDFLAGS=""
#build_one

CPU=armv6
PREFIX=$(pwd)/android/$CPU
EXTRA_CFLAGS="-march=armv6"
EXTRA_LDFLAGS=""
build_one