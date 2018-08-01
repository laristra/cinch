#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# - Find liblapacke
# Find the native LAPACKE headers and libraries.
#
#  LAPACKE_INCLUDE_DIRS - where to find lapacke.h, etc.
#  LAPACKE_LIBRARIES    - List of libraries when using lapacke.
#  LAPACKE_FOUND        - True if lapacke found.
#

find_package(PkgConfig)

pkg_check_modules(PC_LAPACKE lapacke)

find_path(LAPACKE_INCLUDE_DIR lapacke.h HINTS ${PC_LAPACKE_INCLUDE_DIRS} PATH_SUFFIXES lapacke)

find_library(LAPACKE_LIBRARY NAMES lapacke openblas ${PC_LAPACKE_LIBRARIES} HINTS ${PC_LAPACKE_LIBRARY_DIRS} )

find_package(LAPACK)

set(LAPACKE_LIBRARIES ${LAPACKE_LIBRARY} ${LAPACK_LIBRARIES})
set(LAPACKE_INCLUDE_DIRS ${LAPACKE_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set LAPACKE_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(LAPACKE DEFAULT_MSG LAPACKE_LIBRARY LAPACK_LIBRARIES LAPACKE_INCLUDE_DIR )

mark_as_advanced(LAPACKE_INCLUDE_DIR LAPACKE_LIBRARY)
