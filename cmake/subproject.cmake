#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#
# cinch_add_subproject
#

function(cinch_add_subproject directory)

    #--------------------------------------------------------------------------#
    #
    #--------------------------------------------------------------------------#

    set(options)
    set(one_value_args)
    set(multi_value_args LIBRARIES)
    cmake_parse_arguments(extra "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    message(STATUS "Adding subproject in ${directory}")

    if(extra_LIBRARIES)
        set(libraries ${extra_LIBRARIES})
    else()
        set(libraries "ALL")
    endif(extra_LIBRARIES)

    list(APPEND CINCH_SUBPROJECTS "${directory}:${libraries}")
    set(CINCH_SUBPROJECTS ${CINCH_SUBPROJECTS} PARENT_SCOPE)

endfunction(cinch_add_subproject)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
