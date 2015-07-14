#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

include(subdirlist)
include(subfilelist)

function(cinch_make_include_links target src)

    # Find all of the subdirectories of the tree
    cinch_subdirlist(dir_list ${src})

    # Recurse the tree
    foreach(dir ${dir_list})

        # Create subdirectories
        file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/include/${target}/${dir})

        # Find all of the files in this subdirectory
        cinch_subfilelist(file_list ${src}/${dir})

        # Create symbolic links to headers
        foreach(file ${file_list})
            if(${file} MATCHES ".h")
                execute_process(COMMAND
                    ln -s ${src}/${dir}/${file}
                        ${CMAKE_BINARY_DIR}/include/${target}/${dir})
            endif(${file} MATCHES ".h")
        endforeach(file)

    endforeach(dir)

endfunction(cinch_make_include_links)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
