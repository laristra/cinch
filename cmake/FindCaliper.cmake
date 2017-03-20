#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# - Find flecsi
# Find the native Caliper headers and libraries.
#
#  Caliper_INCLUDE_DIRS - where to find flecsi.h, etc.
#  Caliper_LIBRARIES    - List of libraries when using flecsi.
#  Caliper_FOUND        - True if flecsi found.

# Look for the header file.
FIND_PATH(Caliper_INCLUDE_DIR
	NAMES Annotation.h
	PATH_SUFFIXES caliper
)

# Look for the library.
FIND_LIBRARY(Caliper_LIBRARY
	NAMES caliper libcaliper
)

# handle the QUIETLY and REQUIRED arguments and set Caliper_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Caliper Caliper_LIBRARY Caliper_INCLUDE_DIR)

# Copy the results to the output variables.
SET(Caliper_LIBRARIES ${Caliper_LIBRARY})
SET(Caliper_INCLUDE_DIRS ${Caliper_INCLUDE_DIR})

MARK_AS_ADVANCED(Caliper_INCLUDE_DIR Caliper_LIBRARY)
