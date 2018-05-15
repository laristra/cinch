#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Add option to enable HPX
#------------------------------------------------------------------------------#

option(ENABLE_HPX "Enable HPX" OFF)

if(ENABLE_HPX)

#------------------------------------------------------------------------------#
# Find HPX
#------------------------------------------------------------------------------#

  find_package(HPX REQUIRED NO_CMAKE_PACKAGE_REGISTRY)

  include_directories(${HPX_INCLUDE_DIRS})
  link_directories(${HPX_LIBRARY_DIR})

  add_definitions(-DENABLE_HPX)
  if(MSVC)
    add_definitions(-D_SCL_SECURE_NO_WARNINGS)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
    add_definitions(-D_SCL_SECURE_NO_DEPRECATE)
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
    add_definitions(-D_CRT_NONSTDC_NO_WARNINGS)
    add_definitions(-D_HAS_AUTO_PTR_ETC=1)
    add_definitions(-D_SILENCE_TR1_NAMESPACE_DEPRECATION_WARNING)
  endif()

  message(STATUS "HPX found: ${HPX_FOUND}")

endif(ENABLE_HPX)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
