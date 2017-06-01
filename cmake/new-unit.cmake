#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

include(test)

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
    # Call the generic test macro and pass user inputs.
    #--------------------------------------------------------------------------#

    mcinch_add_test(target unit_SOURCES unit_DEFINES unit_DEPENDS
        unit_INPUT unit_LIBRARIES unit_POLICY unit_THREADS "None")

endfunction(cinch_add_unit)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
