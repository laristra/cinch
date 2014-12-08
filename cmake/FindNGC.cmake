#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Find NGC Command-Line Interface Program
#------------------------------------------------------------------------------#

find_program(NGC_EXECUTABLE ngc)
set(NGC ${NGC_EXECUTABLE})

include(FindPackageHandleStandardArgs)
mark_as_advanced(NGC_EXECUTABLE)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
