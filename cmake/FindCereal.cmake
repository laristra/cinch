#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Find the header file
#------------------------------------------------------------------------------#

find_path(Cereal_INCLUDE_DIR cereal/cereal.hpp)

#------------------------------------------------------------------------------#
# Set standard args stuff
#------------------------------------------------------------------------------#

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(Cereal REQUIRED_VARS Cereal_INCLUDE_DIR)

set(Cereal_INCLUDE_DIRS ${Cereal_INCLUDE_DIR})

mark_as_advanced(Cereal_INCLUDE_DIR)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
