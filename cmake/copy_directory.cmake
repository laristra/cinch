#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

include(subdirlist)
include(subfilelist)

function(cinch_copy_directory src dst)

    # Find the files in the top-level directory
    cinch_subfilelist(file_list ${src})

    # Copy files
    foreach(file ${file_list})
        file(COPY ${src}/${file}
            DESTINATION ${CMAKE_BINARY_DIR}/${dst})
    endforeach(file)

    # Find all of the subdirectories of the tree
    cinch_subdirlist(dir_list ${src} TRUE)

    # Recurse the tree
    foreach(dir ${dir_list})

        # Create subdirectories
        file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/${dst}/${dir})

        # Find all of the files in this subdirectory
        cinch_subfilelist(file_list ${src}/${dir})

        # Copy files
        foreach(file ${file_list})
            file(COPY ${src}/${dir}/${file}
                DESTINATION ${CMAKE_BINARY_DIR}/${dst}/${dir})
        endforeach(file)

    endforeach(dir)

endfunction()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
