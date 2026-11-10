cmake_minimum_required(VERSION 3.19)
project(hdf5_static_consumer LANGUAGES C)

find_package(HDF5 REQUIRED CONFIG COMPONENTS C static)

add_executable(hdf5_static_consumer h5_cmprss.c)
target_link_libraries(hdf5_static_consumer PRIVATE hdf5-static)
