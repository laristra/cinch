#------------------------------------------------------------------------------#
# Add Kokkos options.
#------------------------------------------------------------------------------#

option(ENABLE_KOKKOS "Enable Kokkos" OFF)

if(ENABLE_KOKKOS)

  find_package(Kokkos REQUIRED)

  if (Kokkos_ENABLE_CUDA AND NOT CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND
    NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 8)
    message(FATAL_ERROR "Clang version 8 or greater required for Kokkos")
  endif()

  list(APPEND CINCH_RUNTIME_LIBRARIES ${Kokkos_LIBRARIES})

endif()

