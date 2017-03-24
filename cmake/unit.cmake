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
    set(multi_value_args SOURCES DEFINES DEPENDS INPUTS
        LIBRARIES POLICY THREADS)
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
    # Check for defines.
    #--------------------------------------------------------------------------#

    if(NOT unit_DEFINES)
        set(unit_DEFINES "None")
    else()
        string(REPLACE ";" "|" unit_DEFINES "${unit_DEFINES}")
    endif(NOT unit_DEFINES)

    #--------------------------------------------------------------------------#
    # Check for explicit dependencies. This flag is necessary for
    # preprocessor header includes.
    #--------------------------------------------------------------------------#

    if(NOT unit_DEPENDS)
        set(unit_DEPENDS "None")
    else()
        string(REPLACE ";" "|" unit_DEPENDS "${unit_DEPENDS}")
    endif(NOT unit_DEPENDS)

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
    # Capture include directories
    #--------------------------------------------------------------------------#
    
    get_property(unit_INCLUDE_DIRS
                  DIRECTORY ${PROJECT_SOURCE_DIR}
                  PROPERTY INCLUDE_DIRECTORIES)
    if(NOT unit_INCLUDE_DIRS)
        set(unit_INCLUDE_DIRS "None")
    else()
        string(REPLACE ";" "|" unit_INCLUDE_DIRS "${unit_INCLUDE_DIRS}")
    endif()

    #--------------------------------------------------------------------------#
    # Capture compile definitions
    #--------------------------------------------------------------------------#
    
    get_property(unit_COMPILE_DEFS
                  DIRECTORY ${PROJECT_SOURCE_DIR}
                  PROPERTY COMPILE_DEFINITIONS)
    if(NOT unit_COMPILE_DEFS)
        set(unit_COMPILE_DEFS "None")
    else()
        string(REPLACE ";" "|" unit_COMPILE_DEFS "${unit_COMPILE_DEFS}")
    endif()

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
        "${target}:${CMAKE_CURRENT_SOURCE_DIR}:${unit_SOURCES}:${unit_DEFINES}:${unit_DEPENDS}:${unit_INPUTS}:${unit_INCLUDE_DIRS}:${unit_LIBRARIES}:${unit_COMPILE_DEFS}:${unit_POLICY}:${unit_THREADS}:${PROJECT_NAME}")
    set(CINCH_UNIT_TEST_TARGETS ${CINCH_UNIT_TEST_TARGETS}
        CACHE INTERNAL CINCH_UNIT_TEST_TARGETS)

endfunction(cinch_add_unit)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
