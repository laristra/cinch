#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

include(Findlegion)

#------------------------------------------------------------------------------#
# Add option to enable Legion
#------------------------------------------------------------------------------#

option(ENABLE_LEGION "Enable Legion" OFF)

if(ENABLE_LEGION)

#------------------------------------------------------------------------------#
# Find Legion
#------------------------------------------------------------------------------#

find_package(legion REQUIRED NO_MODULE)

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
  if(NOT legion_FOUND)
      message(FATAL_ERROR "Legion is required
                     for this build configuration")
  endif(NOT legion_FOUND)

  set(CMAKE_PREFIX_PATH  ${CMAKE_PREFIX_PATH}
     ${LEGION_INSTALL_DIRS})
  include_directories(${LEGION_INCLUDE_DIRS})
  set(FLECSI_RUNTIME_LIBRARIES ${LEGION_LIBRARIES})


endif(ENABLE_LEGION)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
