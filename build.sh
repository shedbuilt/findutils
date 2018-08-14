#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
# Patch for glibc 2.28
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h
# Configure
if [ -n "${SHED_PKG_LOCAL_OPTIONS[toolchain]}" ]; then
    ./configure --prefix=/tools || exit 1
else
    ./configure --prefix=/usr \
                --localstatedir=/var/lib/locate || exit 1
fi

# Build and Install
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1

# Rearrange
if [ -z "${SHED_PKG_LOCAL_OPTIONS[toolchain]}" ]; then
    mkdir -v "${SHED_FAKE_ROOT}/bin" &&
    mv -v "${SHED_FAKE_ROOT}/usr/bin/find" "${SHED_FAKE_ROOT}/bin" &&
    sed -i 's|find:=${BINDIR}|find:=/bin|' "${SHED_FAKE_ROOT}/usr/bin/updatedb" || exit 1
fi
