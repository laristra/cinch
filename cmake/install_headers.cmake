#------------------------------------------------------------------------------#
# Copyright (c) 2017 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#[=============================================================================[
.. command:: cinch_install_headers

  The ``cinch_install_headers`` function installs a list of files,
  preserving the relative paths.  Normal use of ``install`` does
  not.  The command is used as follows::

   cinch_install_headers( [<option>...] )

  General options are:

  ``FILES <files>...``
    The files to install
  ``DESTINATION <destination>``
    The location to install the files to
#]=============================================================================]

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

