#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Add option to enable MPI
#------------------------------------------------------------------------------#

option(ENABLE_MPI "Enable MPI" OFF)
option(ENABLE_MPI_CXX_BINDINGS "Enable MPI C++ Bindings" OFF)
option(ENABLE_MPI_THREAD_MULITPLE "Enable MPI_THREAD_MULTIPLE" OFF)
mark_as_advanced(ENABLE_MPI_THREAD_MULITPLE)

if(ENABLE_MPI)

#------------------------------------------------------------------------------#
# Find MPI
#------------------------------------------------------------------------------#

find_package(MPI COMPONENTS C CXX REQUIRED)
list(APPEND CINCH_RUNTIME_LIBRARIES MPI::MPI_CXX MPI::MPI_C)

endif(ENABLE_MPI)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
