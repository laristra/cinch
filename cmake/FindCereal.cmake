#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Options
#------------------------------------------------------------------------------#

set(Cereal_ROOT "" CACHE PATH "Root directory of Cereal installation")

#------------------------------------------------------------------------------#
# Find the header file
#------------------------------------------------------------------------------#

find_path(Cereal_INCLUDE_DIRS cereal.hpp
    HINTS ENV Cereal_ROOT
    PATHS ${Cereal_ROOT}
    PATH_SUFFIXES include/cereal)

#------------------------------------------------------------------------------#
# Set standard args stuff
#------------------------------------------------------------------------------#

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(Cereal REQUIRED_VARS Cereal_INCLUDE_DIRS)

mark_as_advanced(Cereal_INCLUDE_DIRS)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
