#!/bin/bash

export LIBRARY_PATH="${PREFIX}/lib"

export CC=$(basename ${CC})
export CXX=$(basename ${CXX})
export F95=$(basename ${F95})
export FC=$(basename ${FC})
export GFORTRAN=$(basename ${GFORTRAN})

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
            --enable-build-mode=production \
            --enable-unsupported \
            --enable-using-memchecker \
            --enable-clear-file-buffers \
            --with-ssl

make -j "${CPU_COUNT}" ${VERBOSE_AT}
make check
make install

rm -rf $PREFIX/share/hdf5_examples
