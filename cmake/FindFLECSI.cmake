#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# - Find flecsi
# Find the native FLECSI headers and libraries.
#
#  FLECSI_INCLUDE_DIRS - where to find flecsi.h, etc.
#  FLECSI_LIBRARIES    - List of libraries when using flecsi.
#  FLECSI_FOUND        - True if flecsi found.

# Look for the header file.
FIND_PATH(FLECSI_INCLUDE_DIR NAMES flecsi.h)

# Look for the library.
FIND_LIBRARY(FLECSI_LIBRARY NAMES flecsi libflecsi)

# handle the QUIETLY and REQUIRED arguments and set FLECSI_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(FLECSI FLECSI_LIBRARY FLECSI_INCLUDE_DIR)

# Copy the results to the output variables.
SET(FLECSI_LIBRARIES ${FLECSI_LIBRARY})
SET(FLECSI_INCLUDE_DIRS ${FLECSI_INCLUDE_DIR})

MARK_AS_ADVANCED(FLECSI_INCLUDE_DIR FLECSI_LIBRARY)
