#!/bin/bash
case "$SHED_BUILD_MODE" in
    toolchain)
        ./configure --prefix=/tools || exit 1
        ;;
    *)
        ./configure --prefix=/usr \
                    --localstatedir=/var/lib/locate || exit 1
        ;;
esac
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1
if [ "$SHED_BUILD_MODE" != 'toolchain' ]; then
    mkdir -v "${SHED_FAKE_ROOT}/bin" &&
    mv -v "${SHED_FAKE_ROOT}/usr/bin/find" "${SHED_FAKE_ROOT}/bin" &&
    sed -i 's|find:=${BINDIR}|find:=/bin|' "${SHED_FAKE_ROOT}/usr/bin/updatedb" || exit 1
fi
