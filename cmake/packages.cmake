#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

macro(cinch_load_extras)

  include(boost)
  include(coverage)
  include(style)
  include(doxygen)
  include(legion)
  include(mpi)
  include(openmp)
  # load clog after mpi
  include(logging)
  # load unit after legion and mpi
  include(unit)
  include(devel)
  include(logging)

endmacro()
