#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Add option to enable Legion
#------------------------------------------------------------------------------#

option(ENABLE_LEGION "Enable Legion" OFF)

if(ENABLE_LEGION)

#------------------------------------------------------------------------------#
# Find Legion
#------------------------------------------------------------------------------#

find_package(Legion REQUIRED)

  if(NOT Legion_FOUND)
      message(FATAL_ERROR "Legion is required
                     for this build configuration")
  endif(NOT Legion_FOUND)

  set(CMAKE_PREFIX_PATH  ${CMAKE_PREFIX_PATH}
     ${LEGION_INSTALL_DIRS})
  include_directories(${LEGION_INCLUDE_DIRS})
  add_definitions( -DLEGION_CMAKE )
  message(STATUS "Legion found: ${Legion_FOUND}")


endif(ENABLE_LEGION)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
