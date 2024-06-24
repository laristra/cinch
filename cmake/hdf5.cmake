#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Add HDF5 support.
#------------------------------------------------------------------------------#

option(ENABLE_HDF5 "Enable HDF5" OFF)

if(ENABLE_HDF5)

    find_package(HDF5 REQUIRED)

    if(NOT HDF5_FOUND)
        message(FATAL_ERROR "HDF5 is required for this build configuration")
    endif(NOT HDF5_FOUND)

    set(CMAKE_PREFIX_PATH  ${CMAKE_PREFIX_PATH} ${HDF5_LIBRARY_DIRS})

    include_directories(${HDF5_INCLUDE_DIRS})

    list(APPEND CINCH_RUNTIME_LIBRARIES ${HDF5_LIBRARIES} ${HDF5_CXX_LIBRARIES})

    if(EXISTS "${HDF5_INCLUDE_DIRS}/../lib/libhdf5_cpp_debug.so")
     list(APPEND CINCH_RUNTIME_LIBRARIES ${HDF5_INCLUDE_DIRS}/../lib/libhdf5_cpp_debug.so )
    endif()

    if(EXISTS "${HDF5_INCLUDE_DIRS}/../lib/libhdf5_cpp.so")
     list(APPEND CINCH_RUNTIME_LIBRARIES ${HDF5_INCLUDE_DIRS}/../lib/libhdf5_cpp.so )
    endif()

    message(STATUS "HDF5 found: ${HDF5_FOUND}")

endif(ENABLE_HDF5)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
