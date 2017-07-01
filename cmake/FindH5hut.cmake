#------------------------------------------------------------------------------#
# Copyright (c) 2017 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# - Find h5hut
# Find the native H5hut headers and libraries.
#
#  H5hut_INCLUDE_DIRS - Where to find h5hut.h, etc.
#  H5hut_LIBRARIES    - List of libraries when using h5hut.
#  H5hut_FOUND        - True if h5hut found.

# Look for the header file.
FIND_PATH(H5hut_INCLUDE_DIR NAMES h5hut.h)

# Look for the library.
FIND_LIBRARY(H5hut_LIBRARY NAMES H5hut libH5hut)

# handle the QUIETLY and REQUIRED arguments and set H5hut_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(H5hut H5hut_INCLUDE_DIR H5hut_LIBRARY)

# Copy the results to the output variables.
SET(H5hut_INCLUDE_DIRS ${H5hut_INCLUDE_DIR})
SET(H5hut_LIBRARIES ${H5hut_LIBRARY})

MARK_AS_ADVANCED(H5hut_INCLUDE_DIR H5hut_LIBRARY)
