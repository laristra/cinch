#
#  KOKKOS_ROOT         - Search path for Kokkos installation
#  KOKKOS_INCLUDE_DIRS - where to find kokkos.h, etc
#  KOKKOS_LIBRARIES    - List of libraries when using kokkos.
#  KOKKOS_FOUND        - True if kokkos found.
#

set(KOKKOS_ROOT "/usr" CACHE PATH "Root directory of Kokkos installation")

find_path(KOKKOS_INCLUDE_DIR Kokkos_Core.hpp
   PATHS ${KOKKOS_ROOT}/include)
find_library(KOKKOS_CORE_LIBRARY NAMES kokkos
	PATHS ${KOKKOS_ROOT}/lib ${KOKKOS_ROOT}/lib64)

set(KOKKOS_LIBRARIES "${KOKKOS_CORE_LIBRARY}")
set(KOKKOS_INCLUDE_DIRS "${KOKKOS_INCLUDE_DIR}")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(KOKKOS DEFAULT_MSG KOKKOS_CORE_LIBRARY KOKKOS_INCLUDE_DIR)

mark_as_advanced(KOKKOS_INCLUDE_DIR KOKKOS_CORE_LIBRARY)
