#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#
# cinch_add_subproject
#

function(cinch_add_subproject subproject libraries)

    #--------------------------------------------------------------------------#
    #
    #--------------------------------------------------------------------------#

    message(STATUS "Adding subproject ${subproject}")

    list(APPEND CINCH_SUBPROJECTS "${subproject}:${libraries}")
    set(CINCH_SUBPROJECTS ${CINCH_SUBPROJECTS} PARENT_SCOPE)

endfunction(cinch_add_subproject)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
