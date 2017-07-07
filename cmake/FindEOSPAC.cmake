#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# - Find flecsi
# Find the native EOSPAC headers and libraries.
#
#  EOSPAC_INCLUDE_DIRS - where to find flecsi.h, etc.
#  EOSPAC_LIBRARIES    - List of libraries when using flecsi.
#  EOSPAC_FOUND        - True if flecsi found.

# Look for the header file.
FIND_PATH(EOSPAC_INCLUDE_DIR NAMES eos_Interface.h)

# Look for the library.
FIND_LIBRARY(EOSPAC_LIBRARY NAMES eospac6 libeospac6)

# handle the QUIETLY and REQUIRED arguments and set EOSPAC_FOUND to TRUE if
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(EOSPAC DEFAULT_MSG EOSPAC_LIBRARY EOSPAC_INCLUDE_DIR)

# Copy the results to the output variables.
SET(EOSPAC_LIBRARIES ${EOSPAC_LIBRARY})
SET(EOSPAC_INCLUDE_DIRS ${EOSPAC_INCLUDE_DIR})

MARK_AS_ADVANCED(EOSPAC_INCLUDE_DIR EOSPAC_LIBRARY)
