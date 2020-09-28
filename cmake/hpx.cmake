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
  list(APPEND CINCH_RUNTIME_LIBRARIES ${HPX_LIBRARIES})
  set(CMAKE_PREFIX_PATH  ${CMAKE_PREFIX_PATH} ${HPX_INSTALL_DIRS})

  if (NOT ENABLE_BOOST)
    message(ERROR "Boost is required for the HPX runtime")
  endif()

  add_definitions(-DENABLE_HPX)

  if(MSVC)
    add_definitions(-D_SCL_SECURE_NO_WARNINGS)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
    add_definitions(-D_SCL_SECURE_NO_DEPRECATE)
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
    add_definitions(-D_CRT_NONSTDC_NO_WARNINGS)
    add_definitions(-D_HAS_AUTO_PTR_ETC=1)
    add_definitions(-D_SILENCE_TR1_NAMESPACE_DEPRECATION_WARNING)
    add_definitions(-D_SILENCE_CXX17_ALLOCATOR_VOID_DEPRECATION_WARNING)
    add_definitions(-DGTEST_LANG_CXX11=1)
    add_definitions(-Zc:preprocessor -wd5104 -wd5105)
    add_definitions(-wd4244 -wd4251 -wd4275) # from gtest
  endif()

  message(STATUS "HPX found: ${HPX_FOUND}")

endif(ENABLE_HPX)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
