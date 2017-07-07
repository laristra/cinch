#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# - Find flecsi
# Find the native FleCSI headers and libraries.
#
#  FleCSI_INCLUDE_DIRS - Where to find flecsi.h, etc.
#  FleCSI_LIBRARIES    - List of libraries when using flecsi.
#  FleCSI_RUNTIME      - Path to the FleCSI runtime source files.
#  FleCSI_FOUND        - True if flecsi found.

# Look for the header file.
FIND_PATH(FleCSI_INCLUDE_DIR NAMES flecsi.h)

# Look for the library.
FIND_LIBRARY(FleCSI_LIBRARY NAMES flecsi libflecsi)

# Look for the runtime driver
FIND_PATH(FleCSI_RUNTIME
	NAMES
		runtime_driver.cc
	PATH_SUFFIXES
		share/flecsi/runtime
)

# handle the QUIETLY and REQUIRED arguments and set FleCSI_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(FleCSI DEFAULT_MSG FleCSI_INCLUDE_DIR FleCSI_LIBRARY
	FleCSI_RUNTIME)

# Copy the results to the output variables.
SET(FleCSI_INCLUDE_DIRS ${FleCSI_INCLUDE_DIR})
SET(FleCSI_LIBRARIES ${FleCSI_LIBRARY})
SET(FleCSI_RUNTIME ${FleCSI_RUNTIME})

MARK_AS_ADVANCED(FleCSI_INCLUDE_DIR FleCSI_LIBRARY FleCSI_RUNTIME)
