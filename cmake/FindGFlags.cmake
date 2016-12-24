#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# - Find GFlags
#
#  GFlags_INCLUDE_DIRS - where to find gflags.h, etc.
#  GFlags_LIBRARIES    - List of libraries when using gflags.
#  GFlags_FOUND        - True if gflags found.

# Look for the header file.
FIND_PATH(GFlags_INCLUDE_DIR NAMES gflags.h)

# Look for the library.
FIND_LIBRARY(GFlags_LIBRARY NAMES gflags libgflags)

# handle the QUIETLY and REQUIRED arguments and set GFlags_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GFlags GFlags_LIBRARY GFlags_INCLUDE_DIR)

# Copy the results to the output variables.
SET(GFlags_LIBRARIES ${GFlags_LIBRARY})
SET(GFlags_INCLUDE_DIRS ${GFlags_INCLUDE_DIR})

MARK_AS_ADVANCED(GFlags_INCLUDE_DIR GFlags_LIBRARY)
