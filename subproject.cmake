#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(detect_subproject)

    if("${CONFIG_TOPLEVEL}" STREQUAL "")
        message(STATUS "NOT SUBPROJECT")
    else()
        message(STATUS "SUBPROJECT")
    endif()

endfunction(detect_subproject)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
