#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

macro(mcinch_add_test target _SOURCES _DEFINES _DEPENDS
    _INPUTS _LIBRARIES _POLICY _THREADS _POST)

    #--------------------------------------------------------------------------#
    # Setup argument options.
    #--------------------------------------------------------------------------#

#    set(options)
#    set(one_value_args)
#    set(multi_value_args SOURCES DEFINES DEPENDS INPUTS
#        LIBRARIES POLICY THREADS)
#    cmake_parse_arguments(unit "${options}" "${one_value_args}"
#        "${multi_value_args}" ${ARGN})

    #--------------------------------------------------------------------------#
    # Make sure that the user specified sources.
    #--------------------------------------------------------------------------#

    if(NOT _SOURCES)
        message(FATAL_ERROR
            "You must specify test source files using SOURCES")
    else()
        string(REPLACE ";" "|" _SOURCES "${_SOURCES}")
    endif()

    #--------------------------------------------------------------------------#
    # Check for defines.
    #--------------------------------------------------------------------------#

    if(NOT _DEFINES)
        set(_DEFINES "None")
    else()
        string(REPLACE ";" "|" _DEFINES "${_DEFINES}")
    endif()

    #--------------------------------------------------------------------------#
    # Check for explicit dependencies. This flag is necessary for
    # preprocessor header includes.
    #--------------------------------------------------------------------------#

    if(NOT _DEPENDS)
        set(_DEPENDS "None")
    else()
        string(REPLACE ";" "|" _DEPENDS "${_DEPENDS}")
    endif()

    #--------------------------------------------------------------------------#
    # Check for files. 
    #--------------------------------------------------------------------------#

    if(NOT _INPUTS)
        set(_INPUTS "None")
    else()
        string(REPLACE ";" "|" _INPUTS "${_INPUTS}")
    endif()

    #--------------------------------------------------------------------------#
    # Check for library dependencies.
    #--------------------------------------------------------------------------#

    if(NOT _LIBRARIES)
        set(_LIBRARIES "None")
    else()
        string(REPLACE ";" "|" _LIBRARIES "${_LIBRARIES}")
    endif()

    #--------------------------------------------------------------------------#
    # Capture include directories
    #--------------------------------------------------------------------------#
    
    get_property(_INCLUDE_DIRS
                  DIRECTORY ${PROJECT_SOURCE_DIR}
                  PROPERTY INCLUDE_DIRECTORIES)
    if(NOT _INCLUDE_DIRS)
        set(_INCLUDE_DIRS "None")
    else()
        string(REPLACE ";" "|" _INCLUDE_DIRS "${_INCLUDE_DIRS}")
    endif()

    #--------------------------------------------------------------------------#
    # Capture compile definitions
    #--------------------------------------------------------------------------#
    
    get_property(_COMPILE_DEFS
                  DIRECTORY ${PROJECT_SOURCE_DIR}
                  PROPERTY COMPILE_DEFINITIONS)
    if(NOT _COMPILE_DEFS)
        set(_COMPILE_DEFS "None")
    else()
        string(REPLACE ";" "|" _COMPILE_DEFS "${_COMPILE_DEFS}")
    endif()

    #--------------------------------------------------------------------------#
    # Check for policy.
    #--------------------------------------------------------------------------#

    if(NOT _POLICY)
        set(_POLICY "SERIAL")
    endif()

    #--------------------------------------------------------------------------#
    # Check for threads.
    #
    # If found, replace the semi-colons with pipes to avoid list
    # interpretation.
    #--------------------------------------------------------------------------#

    if(NOT _THREADS)
        set(_THREADS 1)
    else()
        string(REPLACE ";" "|" _THREADS "${_THREADS}")
    endif()

    #--------------------------------------------------------------------------#
    # Check for post processing executable.
    #--------------------------------------------------------------------------#

    if(NOT _POST)
        set(_POST "None")
    endif()

    #--------------------------------------------------------------------------#
    # Add information to unit test targets.
    #--------------------------------------------------------------------------#

    list(APPEND CINCH_UNIT_TEST_TARGETS
        "${target}:${CMAKE_CURRENT_SOURCE_DIR}:${_SOURCES}:${_DEFINES}:${_DEPENDS}:${_INPUTS}:${_INCLUDE_DIRS}:${_LIBRARIES}:${_COMPILE_DEFS}:${_POLICY}:${_THREADS}:${_POST}:${PROJECT_NAME}")
    set(CINCH_UNIT_TEST_TARGETS ${CINCH_UNIT_TEST_TARGETS}
        CACHE INTERNAL CINCH_UNIT_TEST_TARGETS)

endfunction(cinch_add_unit)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
