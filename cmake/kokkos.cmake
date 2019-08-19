#------------------------------------------------------------------------------#
# Add Kokkos options.
#------------------------------------------------------------------------------#

option(ENABLE_KOKKOS "Enable Kokkos" OFF)

if(ENABLE_KOKKOS)

  if(NOT CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND
    NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 8)
    message(FATAL_ERROR "Clang version 8 or greater required for Kokkos")
  endif()

  find_package(Kokkos REQUIRED)

  set(Kokkos_INCLUDE_DIR "${Kokkos_DIR}/../../../include")
  include_directories(${Kokkos_INCLUDE_DIR})
  link_directories(${Kokkos_LIBRARY_DIRS})

  list(APPEND CINCH_RUNTIME_LIBRARIES kokkos kokkoscore)
  include(${Kokkos_DIR}/KokkosTargets.cmake)


  get_target_property(Kokkos_COMPILE_OPTIONS Kokkos::kokkoscore INTERFACE_COMPILE_OPTIONS)


  get_target_property(Kokkos_LINK_LIBRARIES Kokkos::kokkoscore INTERFACE_LINK_LIBRARIES)

list(FIND Kokkos_DEVICES CUDA kokkos_cuda)
list(GET Kokkos_ARCH 0 kokkos_architecture)
if ("${kokkos_architecture}" STREQUAL "NONE")
 list(GET Kokkos_ARCH 1 kokkos_architecture) 
endif()

if (kokkos_cuda)
  add_definitions(" -x cuda")
  if ("${kokkos_architecture}" STREQUAL "VOLTA70")
    add_definitions("--cuda-gpu-arch=sm_70")
  elseif("${kokkos_architecture}" STREQUAL "KEPLER35")
    add_definitions("--cuda-gpu-arch=sm_35")
  endif()   
endif()


  list(APPEND CINCH_RUNTIME_LIBRARIES ${Kokkos_LINK_LIBRARIES})

endif()

