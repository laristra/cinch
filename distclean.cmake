#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# This script removes cmake configuration files from a directory tree
# emulating a 'distclean' target, which has been intentionally left out
# of cmake.

file(REMOVE CMakeCache.txt)
file(REMOVE_RECURSE  CMakeFiles)
file(REMOVE cmake_install.cmake)
file(REMOVE Makefile)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=2 shiftwidth=2 expandtab :
#------------------------------------------------------------------------------#
