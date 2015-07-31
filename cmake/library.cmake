#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#
# cinch_add_library
#

function(cinch_add_library_target target directory)

    #--------------------------------------------------------------------------#
    # Add target to list
    #--------------------------------------------------------------------------#

    message(STATUS
        "Adding library target ${target} with source directory ${directory}")

    list(APPEND CINCH_LIBRARY_TARGETS "${target}:${directory}")
    set(CINCH_LIBRARY_TARGETS ${CINCH_LIBRARY_TARGETS} PARENT_SCOPE)

endfunction(cinch_add_library_target)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
