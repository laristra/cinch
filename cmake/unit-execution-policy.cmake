#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_add_unit_execution_policy policy runtime)

    #--------------------------------------------------------------------------#
    # Setup argument options.
    #--------------------------------------------------------------------------#

    set(options)
    set(one_value_args)
    set(multi_value_args LIBRARIES EXEC EXEC_THREADS)
    cmake_parse_arguments(unit "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    #--------------------------------------------------------------------------#
    # Check for execution arguments
    #--------------------------------------------------------------------------#

    if(NOT unit_EXEC)
        set(unit_EXEC "None")
    endif(NOT unit_EXEC)

    if(NOT unit_EXEC_THREADS)
        set(unit_EXEC_THREADS "None")
    endif(NOT unit_EXEC_THREADS)

    #--------------------------------------------------------------------------#
    # Check that the policy runtime is defined
    #--------------------------------------------------------------------------#
    
    if(NOT EXISTS ${runtime})
        message(FATAL_ERROR "Unit runtime file not found")
    endif(NOT EXISTS ${runtime})

    #--------------------------------------------------------------------------#
    # Add policy
    #--------------------------------------------------------------------------#

    set(${policy}_UNIT_POLICY_LIST
        "${policy}:${runtime}:${unit_LIBRARIES}:${unit_EXEC}:${unit_EXEC_THREADS}" PARENT_SCOPE)

endfunction(cinch_add_unit_execution_policy)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
