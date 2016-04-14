#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# - Find scotch
# Find the native SCOTCH headers and libraries.
#
#  SCOTCH_INCLUDE_DIRS - where to find scotch.h, etc.
#  SCOTCH_LIBRARIES    - List of libraries when using scotch.
#  SCOTCH_FOUND        - True if scotch found.

find_package(PkgConfig)

pkg_check_modules(PC_SCOTCH scotchmetis)

# Look for the header file.
FIND_PATH(SCOTCH_INCLUDE_DIR NAMES scotch.h HINTS ${PC_SCOTCH_INCLUDE_DIRS} )

# Look for the library.
FIND_LIBRARY(SCOTCH_LIBRARY NAMES scotch libscotch HINTS ${PC_SCOTCH_LIBRARY_DIRS} )
FIND_LIBRARY(SCOTCH_ERR_LIBRARY NAMES scotcherr libscotcherr HINTS ${PC_SCOTCH_LIBRARY_DIRS} )

# handle the QUIETLY and REQUIRED arguments and set SCOTCH_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(SCOTCH DEFAULT_MSG SCOTCH_LIBRARY SCOTCH_ERR_LIBRARY SCOTCH_INCLUDE_DIR)

# Copy the results to the output variables.
SET(SCOTCH_LIBRARIES ${SCOTCH_LIBRARY} ${SCOTCH_ERR_LIBRARY})
SET(SCOTCH_INCLUDE_DIRS ${SCOTCH_INCLUDE_DIR})

MARK_AS_ADVANCED(SCOTCH_INCLUDE_DIR SCOTCH_LIBRARY SCOTCH_ERR_LIBRARY)
