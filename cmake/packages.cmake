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
  include(coverage)
  include(doxygen)
  include(sphinx)

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

  # load clog after mpi
  include(logging)

  # load unit after legion and mpi
  include(unit)

  # load caliper
  include(caliper)

  # development tests
  include(devel)

  # environment modules
  include(capture)

endmacro()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=2 shiftwidth=2 expandtab :
#------------------------------------------------------------------------------#
