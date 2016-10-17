#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Try pkg-config
#------------------------------------------------------------------------------#

#find_package(PkgConfig)
#pkg_check_modules(PC_LEGION legion)

#------------------------------------------------------------------------------#
# Options
#------------------------------------------------------------------------------#

set(LEGION_ROOT "" CACHE PATH "Root directory of Legion installation")

#------------------------------------------------------------------------------#
# Find the header file
#------------------------------------------------------------------------------#

find_path(LEGION_INCLUDE_DIR legion/legion.h
    HINTS ENV LEGION_ROOT
    PATHS ${LEGION_ROOT}
    PATH_SUFFIXES include)

set(LEGION_INCLUDE_DIRS
    ${LEGION_INCLUDE_DIR}
    ${LEGION_INCLUDE_DIR}/legion
    ${LEGION_INCLUDE_DIR}/realm
    ${LEGION_INCLUDE_DIR}/mappers)

#------------------------------------------------------------------------------#
# Find the legion and realm libraries
#------------------------------------------------------------------------------#

find_library(LEGION_LIBRARY
    NAMES legion
    PATHS ${LEGION_ROOT}
    PATH_SUFFIXES lib lib64)

find_library(REALM_LIBRARY
    NAMES realm
    PATHS ${LEGION_ROOT}
    PATH_SUFFIXES lib lib64)

if(LEGION_LIBRARY AND REALM_LIBRARY)
    list(APPEND LEGION_LIBRARIES ${LEGION_LIBRARY} ${REALM_LIBRARY})
endif()

#------------------------------------------------------------------------------#
# Set standard args stuff
#------------------------------------------------------------------------------#

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(LEGION
    REQUIRED_VARS
        LEGION_INCLUDE_DIRS
        LEGION_LIBRARIES)

mark_as_advanced(LEGION_INCLUDE_DIR LEGION_INCLUDE_DIRS)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
