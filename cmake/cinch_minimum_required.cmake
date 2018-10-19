#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_minimum_required)

    set(options)
    set(one_value_args VERSION)
    set(multi_value_args)

    cmake_parse_arguments(_cinch "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    execute_process(COMMAND utils/version
      WORKING_DIRECTORY ${CINCH_SOURCE_DIR} OUTPUT_VARIABLE CINCH_VERSION)
    string(STRIP "${CINCH_VERSION}" CINCH_VERSION)

    if(CINCH_VERSION VERSION_LESS ${_cinch_VERSION})
        message(FATAL_ERROR "${PROJECT_NAME} requries Cinch "
            "version ${_cinch_VERSION} (found version ${CINCH_VERSION})"
        )
    else()
        message(STATUS "Cinch version ${CINCH_VERSION} (${CINCH_SOURCE_DIR})")
    endif()

endfunction(cinch_minimum_required)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
