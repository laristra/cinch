#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_install_headers)

    set(options)
    set(one_value_args DESTINATION)
    set(multi_value_args FILES)

    cmake_parse_arguments(args "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    foreach ( file ${args_FILES} )
      get_filename_component( dir ${file} DIRECTORY )
      install( FILES ${file} DESTINATION ${args_DESTINATION}/${dir} )
    endforeach()

endfunction()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
