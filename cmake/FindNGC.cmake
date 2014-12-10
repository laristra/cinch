#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Find NGC Command-Line Interface Program
#------------------------------------------------------------------------------#

find_program(NGC_EXECUTABLE
    NAMES ngc
    DOC "NGC Command-Line Tool"
)

if(NGC_EXECUTABLE)
    execute_process(COMMAND ${NGC_EXECUTABLE} "--version" OUTPUT_VARIABLE
        NGC_VERSION OUTPUT_QUIET ERROR_QUIET)
endif(NGC_EXECUTABLE)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(ngc REQUIRED_VARS NGC_EXECUTABLE
    VERSION_VAR NGC_VERSION)
mark_as_advanced(NGC_EXECUTABLE)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
