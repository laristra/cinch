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

  set(Kokkos_LIBRARIES Kokkos::kokkos)
  list(APPEND CINCH_RUNTIME_LIBRARIES ${Kokkos_LIBRARIES})
  # If kokkos enable, add compile flag for test-mpi 
  add_definitions("-DENABLE_KOKKOS")

endif()

