#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#
# cinch_add_application_directory
#

function(cinch_add_application_directory directory)

    #--------------------------------------------------------------------------#
    #
    #--------------------------------------------------------------------------#

    message(STATUS "Adding application directory ${directory}")
    add_subdirectory( ${directory} )

endfunction(cinch_add_application_directory)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
