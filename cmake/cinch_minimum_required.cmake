#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_minimum_required version)

    file(READ ${CINCH_SOURCE_DIR}/.version CINCH_VERSION)
    string(STRIP "${CINCH_VERSION}" CINCH_VERSION)


    if(CINCH_VERSION VERSION_LESS ${version})
        message(FATAL_ERROR "This project requries Cinch version ${version}"
            " (found version ${CINCH_VERSION})"
        )
    else()
        message(STATUS "Cinch version ${CINCH_VERSION} (${CINCH_SOURCE_DIR})")
    endif()

endfunction(cinch_minimum_required)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
