#!/bin/bash
case "$SHED_BUILDMODE" in
    toolchain)
        ./configure --prefix=/tools || return 1
        ;;
    *)
        ./configure --prefix=/usr \
                    --localstatedir=/var/lib/locate || return 1
        ;;
esac
make -j $SHED_NUMJOBS || return 1
make DESTDIR="$SHED_FAKEROOT" install || return 1

if [ "$SHED_BUILDMODE" != 'toolchain' ]; then
    mkdir -v "${SHED_FAKEROOT}/bin"
    mv -v "${SHED_FAKEROOT}/usr/bin/find" "${SHED_FAKEROOT}/bin"
    sed -i 's|find:=${BINDIR}|find:=/bin|' "${SHED_FAKEROOT}/usr/bin/updatedb"
fi
