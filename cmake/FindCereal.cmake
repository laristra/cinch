#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# Try pkg-config
#------------------------------------------------------------------------------#

find_package(PkgConfig)

pkg_check_modules(PC_CEREAL cereal)

#------------------------------------------------------------------------------#
# Options
#------------------------------------------------------------------------------#

set(CEREAL_ROOT "" CACHE PATH "Root directory of CEREAL installation")

#------------------------------------------------------------------------------#
# Find the header file
#------------------------------------------------------------------------------#

find_path(CEREAL_INCLUDE_DIRS cereal.hpp
    HINTS ENV CEREAL_ROOT
    PATHS ${CEREAL_ROOT}
    PATH_SUFFIXES include/cereal)

#------------------------------------------------------------------------------#
# Set standard args stuff
#------------------------------------------------------------------------------#

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(CEREAL REQUIRED_VARS CEREAL_INCLUDE_DIRS)

mark_as_advanced(CEREAL_INCLUDE_DIRS)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
