#------------------------------------------------------------------------------#
# Add Kokkos options.
#------------------------------------------------------------------------------#

option(ENABLE_HDF5 "Enable HDF5" OFF)

if(ENABLE_HDF5)
  find_package(HDF5 REQUIRED)

  include_directories(${HDF5_INCLUDE_DIRS})
  list(APPEND CINCH_RUNTIME_LIBRARIES ${HDF5_LIBRARIES})
endif()
