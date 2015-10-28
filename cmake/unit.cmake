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
    set(multi_value_args SOURCES INPUTS LIBRARIES POLICY THREADS)
    cmake_parse_arguments(unit "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    #--------------------------------------------------------------------------#
    # Make sure that the user specified sources.
    #--------------------------------------------------------------------------#

    if(NOT unit_SOURCES)
        message(FATAL_ERROR
            "You must specify unit test source files using SOURCES")
    else()
        string(REPLACE ";" "|" unit_SOURCES "${unit_SOURCES}")
    endif(NOT unit_SOURCES)

    #--------------------------------------------------------------------------#
    # Check for files. 
    #--------------------------------------------------------------------------#

    if(NOT unit_INPUTS)
        set(unit_INPUTS "None")
    else()
        string(REPLACE ";" "|" unit_INPUTS "${unit_INPUTS}")
    endif(NOT unit_INPUTS)

    #--------------------------------------------------------------------------#
    # Check for library dependencies.
    #--------------------------------------------------------------------------#

    if(NOT unit_LIBRARIES)
        set(unit_LIBRARIES "None")
    else()
        string(REPLACE ";" "|" unit_LIBRARIES "${unit_LIBRARIES}")
    endif(NOT unit_LIBRARIES)

    #--------------------------------------------------------------------------#
    # Check for policy.
    #--------------------------------------------------------------------------#

    if(NOT unit_POLICY)
        set(unit_POLICY "SERIAL")
    endif(NOT unit_POLICY)

    #--------------------------------------------------------------------------#
    # Check for threads.
    #
    # If found, replace the semi-colons with pipes to avoid list
    # interpretation.
    #--------------------------------------------------------------------------#

    if(NOT unit_THREADS)
        set(unit_THREADS 1)
    else()
        string(REPLACE ";" "|" unit_THREADS "${unit_THREADS}")
    endif(NOT unit_THREADS)

    #--------------------------------------------------------------------------#
    # Add information to unit test targets.
    #--------------------------------------------------------------------------#

    list(APPEND CINCH_UNIT_TEST_TARGETS
        "${target}:${CMAKE_CURRENT_SOURCE_DIR}:${unit_SOURCES}:${unit_INPUTS}:${unit_LIBRARIES}:${unit_POLICY}:${unit_THREADS}")
    set(CINCH_UNIT_TEST_TARGETS ${CINCH_UNIT_TEST_TARGETS}
        CACHE INTERNAL CINCH_UNIT_TEST_TARGETS)

endfunction(cinch_add_unit)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
