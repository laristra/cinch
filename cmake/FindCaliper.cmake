#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# Find the native Caliper headers and libraries.
#
#  Caliper_INCLUDE_DIRS  - where to find flecsi.h, etc.
#  Caliper_MPI_LIBRARIES - List of mpi libraries when using flecsi.
#  Caliper_LIBRARIES     - List of libraries when using flecsi.
#  Caliper_FOUND         - True if flecsi found.

find_package(PkgConfig)

pkg_check_modules(PC_Caliper caliper)

# Look for the header file.
FIND_PATH(Caliper_INCLUDE_DIRS
  NAMES "caliper/Caliper.h"
	HINTS ${PC_Caliper_INCLUDE_DIRS}
)

# Look for the library.
FIND_LIBRARY(Caliper_LIBRARIES
	NAMES caliper libcaliper
	HINTS ${PC_Caliper_LIBRARIES}
)

# Look for the mpi library.
FIND_LIBRARY(Caliper_MPI_LIBRARIES
        NAMES caliper-mpi libcaliper-mpi
        HINTS ${PC_Caliper_MPI_LIBRARIES}
)

# handle the QUIETLY and REQUIRED arguments and set Caliper_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Caliper DEFAULT_MSG 
	Caliper_MPI_LIBRARIES
	Caliper_LIBRARIES
	Caliper_INCLUDE_DIRS)

# Copy the results to the output variables.
SET(Caliper_MPI_LIBRARIES ${Caliper_MPI_LIBRARIES})
SET(Caliper_LIBRARIES ${Caliper_LIBRARIES})
SET(Caliper_INCLUDE_DIRS ${Caliper_INCLUDE_DIRS})

MARK_AS_ADVANCED(Caliper_INCLUDE_DIRS Caliper_LIBRARIES Caliper_MPI_LIBRARIES)
