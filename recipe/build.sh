#!/bin/bash

#TODO: not sure why this or the LIBRARY_PATH is necessary.
if [ "$(uname)" == "Darwin" ]; then
    export CXX="${CXX} -stdlib=libc++"
fi

export LIBRARY_PATH="${PREFIX}/lib"

./configure --prefix="${PREFIX}" \
            --host="${HOST}" \
            --enable-linux-lfs \
            --with-zlib="${PREFIX}" \
            --with-pthread=yes  \
            --enable-cxx \
            --enable-fortran \
            --enable-fortran2003 \
            --with-default-plugindir="${PREFIX}/lib/hdf5/plugin" \
            --enable-threadsafe \
            --enable-shared \
            --enable-build-mode=production \
            --enable-unsupported \
            --enable-using-memchecker \
            --enable-clear-file-buffers \
            --with-ssl

make -j "${CPU_COUNT}" ${VERBOSE_AT}
make check
make install

rm -rf $PREFIX/share/hdf5_examples
