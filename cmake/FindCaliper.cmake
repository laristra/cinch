#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# Find the native Caliper headers and libraries.
#
#  Caliper_INCLUDE_DIRS - where to find flecsi.h, etc.
#  Caliper_LIBRARIES    - List of libraries when using flecsi.
#  Caliper_FOUND        - True if flecsi found.

find_package(PkgConfig)

pkg_check_modules(PC_Caliper caliper)

# Look for the header file.
FIND_PATH(Caliper_INCLUDE_DIRS
	NAMES Annotation.h
	HINTS ${PC_Caliper_INCLUDE_DIRS}
	PATH_SUFFIXES caliper
)

# Look for the library.
FIND_LIBRARY(Caliper_LIBRARIES
	NAMES caliper libcaliper
	HINTS ${PC_Caliper_LIBRARIES}
)

# handle the QUIETLY and REQUIRED arguments and set Caliper_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Caliper DEFAULT_MSG Caliper_LIBRARIES
	Caliper_INCLUDE_DIRS)

# Copy the results to the output variables.
SET(Caliper_LIBRARIES ${Caliper_LIBRARIES})
SET(Caliper_INCLUDE_DIRS ${Caliper_INCLUDE_DIRS})

MARK_AS_ADVANCED(Caliper_INCLUDE_DIRS Caliper_LIBRARIES)
