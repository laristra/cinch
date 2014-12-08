#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Find pandoc markdown interpreter
#------------------------------------------------------------------------------#

find_program(PANDOC_EXECUTABLE pandoc)
set(PANDOC ${PANDOC_EXECUTABLE})

include(FindPackageHandleStandardArgs)
mark_as_advanced(PANDOC_EXECUTABLE)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
