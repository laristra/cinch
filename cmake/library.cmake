#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#
# cinch_add_library
#

function(cinch_add_library target directory)

    #--------------------------------------------------------------------------#
    #
    #--------------------------------------------------------------------------#

    list(APPEND CINCH_LIBRARY_TARGETS target)
    list(APPEND CINCH_LIBRARY_DIRS directory)

endfunction(cinch_add_doc)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
