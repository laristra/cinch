#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

macro(cinch_load_extras)

  include(boost)
  include(coverage)
  include(doxygen)
  include(legion)
  include(mpi)
  include(openmp)
  include(unit)
  include(logging)

endmacro()
