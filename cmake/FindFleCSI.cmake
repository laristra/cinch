#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# - Find flecsi
# Find the native FleCSI headers and libraries.
#
#  FleCSI_INCLUDE_DIRS - where to find flecsi.h, etc.
#  FleCSI_LIBRARIES    - List of libraries when using flecsi.
#  FleCSI_FOUND        - True if flecsi found.

# Look for the header file.
FIND_PATH(FleCSI_INCLUDE_DIR NAMES flecsi.h)

# Look for the library.
FIND_LIBRARY(FleCSI_LIBRARY NAMES flecsi libflecsi)

# handle the QUIETLY and REQUIRED arguments and set FleCSI_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(FleCSI FleCSI_LIBRARY FleCSI_INCLUDE_DIR)

# Copy the results to the output variables.
SET(FleCSI_LIBRARIES ${FleCSI_LIBRARY})
SET(FleCSI_INCLUDE_DIRS ${FleCSI_INCLUDE_DIR})

MARK_AS_ADVANCED(FleCSI_INCLUDE_DIR FleCSI_LIBRARY)
