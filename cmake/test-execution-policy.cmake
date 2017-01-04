#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_add_test_execution_policy policy runtime)

    #--------------------------------------------------------------------------#
    # Setup argument options.
    #--------------------------------------------------------------------------#

    set(options)
    set(one_value_args)
    set(multi_value_args FLAGS INCLUDES DEFINES LIBRARIES EXEC EXEC_THREADS)
    cmake_parse_arguments(test "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    #--------------------------------------------------------------------------#
    # Check for include arguments
    #--------------------------------------------------------------------------#

    if(NOT test_FLAGS)
        set(test_FLAGS "None")
    else()
        # Quotes are important here so that list is interpreted as a string
        string(REPLACE ";" "|" test_FLAGS "${test_FLAGS}")
        # Replace leading spaces to avoid overquoting
        string(STRIP "${test_FLAGS}" test_FLAGS)
    endif(NOT test_FLAGS)

    #--------------------------------------------------------------------------#
    # Check for include arguments
    #--------------------------------------------------------------------------#

    if(NOT test_INCLUDES)
        set(test_INCLUDES "None")
    else()
        # Quotes are important here so that list is interpreted as a string
        string(REPLACE ";" "|" test_INCLUDES "${test_INCLUDES}")
    endif(NOT test_INCLUDES)

    #--------------------------------------------------------------------------#
    # Check for define arguments
    #--------------------------------------------------------------------------#

    if(NOT test_DEFINES)
        set(test_DEFINES "None")
    else()
        # Quotes are important here so that list is interpreted as a string
        string(REPLACE ";" "|" test_DEFINES "${test_DEFINES}")
    endif(NOT test_DEFINES)

    #--------------------------------------------------------------------------#
    # Check for library arguments
    #--------------------------------------------------------------------------#

    if(NOT test_LIBRARIES)
        set(test_LIBRARIES "None")
    else()
        # Quotes are important here so that list is interpreted as a string
        string(REPLACE ";" "|" test_LIBRARIES "${test_LIBRARIES}")
    endif(NOT test_LIBRARIES)

    #--------------------------------------------------------------------------#
    # Check for execution arguments
    #--------------------------------------------------------------------------#

    if(NOT test_EXEC)
        set(test_EXEC "None")
    endif(NOT test_EXEC)

    if(NOT test_EXEC_THREADS)
        set(test_EXEC_THREADS "None")
    endif(NOT test_EXEC_THREADS)

    #--------------------------------------------------------------------------#
    # Check that the policy runtime is defined
    #--------------------------------------------------------------------------#
    
    if(NOT EXISTS ${runtime})
        message(FATAL_ERROR "Unit runtime file not found")
    endif(NOT EXISTS ${runtime})

    #--------------------------------------------------------------------------#
    # Add policy
    #--------------------------------------------------------------------------#

    set(${policy}_TEST_POLICY_LIST
        "${policy}:${runtime}:${test_FLAGS}:${test_INCLUDES}:${test_DEFINES}:${test_LIBRARIES}:${test_EXEC}:${test_EXEC_THREADS}" PARENT_SCOPE)

endfunction(cinch_add_test_execution_policy)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
