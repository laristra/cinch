#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Find cinch Command-Line Interface Program
#------------------------------------------------------------------------------#

find_program(CINCH_EXECUTABLE
    NAMES cinch
    DOC "Cinch Command-Line Tool"
)

if(CINCH_EXECUTABLE)
    execute_process(COMMAND ${CINCH_EXECUTABLE} "--version" OUTPUT_VARIABLE
        CINCH_VERSION OUTPUT_QUIET ERROR_QUIET)
endif(CINCH_EXECUTABLE)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(cinch REQUIRED_VARS CINCH_EXECUTABLE
    VERSION_VAR CINCH_VERSION)
mark_as_advanced(CINCH_EXECUTABLE)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
