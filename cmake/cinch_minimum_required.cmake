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

    if(EXISTS ${CINCH_SOURCE_DIR}/.version)
        file(READ ${CINCH_SOURCE_DIR}/.version CINCH_VERSION)
        string(STRIP "${CINCH_VERSION}" CINCH_VERSION)
    else()
        find_package(Git)

        if(NOT Git_FOUND)
            message(FATAL_ERROR "You must have git installed to use cinch!!!")
        endif()

        execute_process(COMMAND ${GIT_EXECUTABLE} describe --abbrev=0
          WORKING_DIRECTORY ${CINCH_SOURCE_DIR} OUTPUT_VARIABLE CINCH_VERSION)
        string(STRIP "${CINCH_VERSION}" CINCH_VERSION)
    endif()

    # remove v prefix from the version so that CMake can compare the version
    # number
    string(REGEX REPLACE "^v" "" CINCH_VERSION ${CINCH_VERSION})

    if(CINCH_VERSION VERSION_LESS ${_cinch_VERSION})
        message(FATAL_ERROR "${PROJECT_NAME} requires Cinch "
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
