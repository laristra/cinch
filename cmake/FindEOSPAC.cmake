#------------------------------------------------------------------------------#
# Copyright (c) 2016-2017 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# Find the native EOSPAC headers and libraries.
#
#  EOSPAC_ROOT         - Search path for EOSPAC installation
#  EOSPAC_INCLUDE_DIRS - where to find eos_Interface.h, etc
#  EOSPAC_LIBRARIES    - List of libraries when using EOSPAC.
#  EOSPAC_FOUND        - True if eospac is found.
#

if(NOT ${EOSPAC_ROOT})
	set(EOSPAC_ROOT "/usr" CACHE PATH "Root directory of EOSPAC installation")
endif()

find_path(EOSPAC_INCLUDE_DIR eos_Interface.h
	HINTS ${EOSPAC_ROOT}/include
  PATHS ${EOSPAC_ROOT}/include)
find_library(EOSPAC_LIBRARY NAMES eospac6
	PATHS
    ${EOSPAC_ROOT}/lib
    ${EOSPAC_ROOT}/lib64
    ${EOSPAC_LIBRARY_DIR}
)

set(EOSPAC_LIBRARIES "${EOSPAC_LIBRARY}")
set(EOSPAC_INCLUDE_DIRS "${EOSPAC_INCLUDE_DIR}")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(EOSPAC DEFAULT_MSG EOSPAC_LIBRARY EOSPAC_INCLUDE_DIR)

mark_as_advanced(EOSPAC_INCLUDE_DIR EOSPAC_LIBRARY EOSPAC_LIBRARY_DIR)
