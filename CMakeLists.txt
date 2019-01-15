#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

project(cinch)

cmake_minimum_required(VERSION 3.0)

#------------------------------------------------------------------------------#
# Cinch cmake search path and includes
#------------------------------------------------------------------------------#

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

include(insource)
include(version)

#------------------------------------------------------------------------------#
# Add spotless target
#------------------------------------------------------------------------------#

add_custom_target(spotless rm -rf ${CMAKE_BINARY_DIR}/*)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
