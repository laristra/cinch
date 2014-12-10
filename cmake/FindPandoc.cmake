#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Find pandoc markdown interpreter
#------------------------------------------------------------------------------#

find_program(PANDOC_EXECUTABLE
    NAMES pandoc
    DOC "pandoc markdown processing tool")

if(PANDOC_EXECUTABLE)
    execute_process(COMMAND ${PANDOC_EXECUTABLE} "--version" OUTPUT_VARIABLE
        PANDOC_VERSION OUTPUT_QUIET ERROR_QUIET)
endif(PANDOC_EXECUTABLE)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(pandoc REQUIRED_VARS PANDOC_EXECUTABLE
    VERSION_VAR PANDOC_VERSION)
mark_as_advanced(PANDOC_EXECUTABLE)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
