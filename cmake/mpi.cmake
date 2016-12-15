#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Add option to enable MPI
#------------------------------------------------------------------------------#

option(ENABLE_MPI "Enable MPI" OFF)
option(ENABLE_MPI_CXX_BINDINGS "Enable MPI C++ Bindings" OFF)

if(ENABLE_MPI)

#------------------------------------------------------------------------------#
# Find MPI
#------------------------------------------------------------------------------#

find_package(MPI REQUIRED)

#------------------------------------------------------------------------------#
# Skip C++ linkage of MPI
#------------------------------------------------------------------------------#

if(ENABLE_MPI_CXX_BINDINGS)
    set(MPI_LANGUAGE CXX)
    set(MPI_CPPFLAGS)
else()
    set(MPI_LANGUAGE C)
    add_definitions(-DOMPI_SKIP_MPICXX)
    add_definitions(-DMPICH_SKIP_MPICXX)
    set(MPI_CPPFLAGS -DOMPI_SKIP_MPICXX -DMPICH_SKIP_MPICXX)
endif(ENABLE_MPI_CXX_BINDINGS)

if(MPI_${MPI_LANGUAGE}_FOUND)
    include_directories(${MPI_${MPI_LANGUAGE}_INCLUDE_PATH})
    add_definitions(-DHAVE_MPI)
endif(MPI_${MPI_LANGUAGE}_FOUND)

endif(ENABLE_MPI)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
