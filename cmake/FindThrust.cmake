#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Find the header file
#------------------------------------------------------------------------------#

find_path(Thrust_INCLUDE_DIR thrust/version.h)

#------------------------------------------------------------------------------#
# Set standard args stuff
#------------------------------------------------------------------------------#

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(Thrust REQUIRED_VARS Thrust_INCLUDE_DIR)

set(Thrust_INCLUDE_DIRS ${Thrust_INCLUDE_DIR})

mark_as_advanced(Thrust_INCLUDE_DIR)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
