#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#
# cinch_add_subproject
#

function(cinch_add_subproject directory)

    message(STATUS "Adding subproject in ${directory}")

    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/${directory})
    include_directories(${CMAKE_CURRENT_BINARY_DIR}/${directory})
    
    add_subdirectory( ${directory} )

endfunction(cinch_add_subproject)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
