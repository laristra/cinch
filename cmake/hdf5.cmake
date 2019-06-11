#------------------------------------------------------------------------------#
# Add Kokkos options.
#------------------------------------------------------------------------------#

option(ENABLE_HDF5 "Enable HDF5" OFF)

if(ENABLE_HDF5)
  find_package(HDF5 REQUIRED)

  include_directories(${HDF5_C_INCLUDE_DIR})

  if(CMAKE_BUILD_TYPE MATCHES DEBUG)
    list(APPEND CINCH_RUNTIME_LIBRARIES ${HDF5_hdf5_LIBRARY_DEBUG})
  else()
    list(APPEND CINCH_RUNTIME_LIBRARIES ${HDF5_hdf5_LIBRARY_RELEASE})
  endif()
endif()
