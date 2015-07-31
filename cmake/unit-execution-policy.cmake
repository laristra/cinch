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
    set(multi_value_args LIBRARIES)
    cmake_parse_arguments(unit "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    #--------------------------------------------------------------------------#
    # Check that the policy runtime is defined
    #--------------------------------------------------------------------------#
    
    if(NOT EXISTS ${runtime})
        message(FATAL_ERROR "Unit runtime file not found")
    endif(NOT EXISTS ${runtime})

    #--------------------------------------------------------------------------#
    # Add policy to list
    #--------------------------------------------------------------------------#

    list(APPEND CINCH_UNIT_EXECUTION_POLICIES
        "${policy}:${runtime}:${unit_LIBRARIES}")
    set(CINCH_UNIT_EXECUTION_POLICIES ${CINCH_UNIT_EXECUTION_POLICIES}
        PARENT_SCOPE)

endfunction(cinch_add_unit)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
