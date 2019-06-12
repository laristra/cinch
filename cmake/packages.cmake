#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

macro(cinch_load_extras)

  set(options MPI LEGION HPX)
  set(oneValueArgs)
  set(multiValueArgs)
  cmake_parse_arguments(opt_in "${options}" "${oneValueArgs}"
    "${multiValueArgs}" ${ARGN} )

  include(boost)
  include(kokkos)
  include(coverage)
  include(format)

  include(hdf5)

  if(opt_in_LEGION)
    include(legion)
  endif()

  if(opt_in_MPI)
    include(mpi)
  endif()

  if(opt_in_HPX)
    include(hpx)
  endif()

  include(openmp)

  # load cinch files
  include(cinch)

  # load caliper
  include(caliper)

  # load graphviz
  include(graphviz)

endmacro()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=2 shiftwidth=2 expandtab :
#------------------------------------------------------------------------------#
