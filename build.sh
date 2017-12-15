#!/bin/bash
./configure --prefix=/usr \
            --localstatedir=/var/lib/locate
make -j $SHED_NUMJOBS
make DESTDIR=${SHED_FAKEROOT} install
mkdir -v ${SHED_FAKEROOT}/bin
mv -v ${SHED_FAKEROOT}/usr/bin/find ${SHED_FAKEROOT}/bin
sed -i 's|find:=${BINDIR}|find:=/bin|' ${SHED_FAKEROOT}/usr/bin/updatedb
