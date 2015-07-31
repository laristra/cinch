#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_add_unit target)

    #--------------------------------------------------------------------------#
    # Setup argument options.
    #--------------------------------------------------------------------------#

    set(options)
    set(one_value_args)
    set(multi_value_args SOURCES LIBRARIES)
    cmake_parse_arguments(unit "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    #--------------------------------------------------------------------------#
    # Make sure that the user specified sources.
    #--------------------------------------------------------------------------#

    if(NOT unit_SOURCES)
        message(FATAL_ERROR
            "You must specify unit test source files using SOURCES")
    endif(NOT unit_SOURCES)

    #--------------------------------------------------------------------------#
    # Check for library dependencies.
    #--------------------------------------------------------------------------#

    if(NOT unit_LIBRARIES)
        set(unit_LIBRARIES "NONE")
    endif(NOT unit_LIBRARIES)

    #--------------------------------------------------------------------------#
    # Add information to unit test targets.
    #--------------------------------------------------------------------------#

    message(STATUS "DEBUG ${CMAKE_PROJECT} adding unit ${target}")
    list(APPEND CINCH_UNIT_TEST_TARGETS
        "${target}:${CMAKE_CURRENT_SOURCE_DIR}:${unit_SOURCES}:${unit_LIBRARIES}")
    set(CINCH_UNIT_TEST_TARGETS ${CINCH_UNIT_TEST_TARGETS}
        CACHE INTERNAL CINCH_UNIT_TEST_TARGETS)

endfunction(cinch_add_unit)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
