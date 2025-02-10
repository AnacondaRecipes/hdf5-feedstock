#!/bin/bash

export LIBRARY_PATH="${PREFIX}/lib"

export CC=$(basename ${CC})
export CXX=$(basename ${CXX})
export F95=$(basename ${F95})
export FC=$(basename ${FC})
export GFORTRAN=$(basename ${GFORTRAN})

if [ $(uname -s) = "Linux" ] && [ ! -f "${BUILD_PREFIX}/bin/strings" ]; then
    ln -s "${BUILD}-strings" "${BUILD_PREFIX}/bin/strings"
fi

mkdir build
cd build

cmake_flags=(
    -D CMAKE_BUILD_TYPE=RELEASE
    -D CMAKE_PREFIX_PATH="$PREFIX"
    -D CMAKE_INSTALL_PREFIX="$PREFIX"
    -D HDF5_BUILD_CPP_LIB=ON
    -D HDF5_BUILD_FORTRAN=ON
    -D BUILD_SHARED_LIBS=ON
    -D BUILD_STATIC_LIBS=ON
    -D HDF5_BUILD_HL_LIB=ON
    -D HDF5_BUILD_TOOLS=ON
    -D HDF5_ENABLE_Z_LIB_SUPPORT=ON
    -D HDF5_ENABLE_SZIP_SUPPORT=OFF
    -D HDF5_ENABLE_THREADSAFE=ON
    -D HDF5_ENABLE_ROS3_VFD=ON
    -D H5_DEFAULT_PLUGINDIR="${PREFIX}/lib/hdf5/plugin"
    -D HDF5_DEFAULT_API_VERSION=v18
    -D ALLOW_UNSUPPORTED=ON
    -D ZLIB_DIR="$PREFIX"
)

# Apply extra flags for Linux only
if [[ $(uname) == "Linux" ]]; then
    cmake_flags+=(-D CMAKE_C_FLAGS="-pthread -Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib -lz")
fi


cmake -G "Unix Makefiles" "${cmake_flags[@]}" "$SRC_DIR"

# Build C libraries and tools.
cmake --build .
cmake --install .

rm -rf $PREFIX/share/hdf5_examples

# Restore compatibility with hdf5 built with autotools
# Create symlinks for libhdf5hl* from existing libhdf5_hl*
for file in $PREFIX/lib/libhdf5_hl*; do
    # Extract base filename
    base_name=$(basename "$file")

    # Replace "libhdf5_hl" with "libhdf5hl" in the filename
    new_name="${base_name/libhdf5_hl/libhdf5hl}"

    # Create symlink only if the destination does not exist
    if [[ ! -e "$PREFIX/lib/$new_name" ]]; then
        ln -s "$file" "$PREFIX/lib/$new_name"
    fi
done
