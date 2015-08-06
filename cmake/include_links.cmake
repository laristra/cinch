#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

include(subdirlist)
include(subfilelist)

function(cinch_make_include_links target src)

    if(NOT CINCH_HEADER_SUFFIXES)
        message(WARNING "Header suffix not set (CINCH_HEADER_SUFFIXES)"
            ": using .h")
        set(CINCH_HEADER_SUFFIXES "\\.h")
    endif(NOT CINCH_HEADER_SUFFIXES)

    # Find all of the subdirectories of the tree
    cinch_subdirlist(dir_list ${src} True)

    # Recurse the tree
    foreach(dir ${dir_list})

        # Create subdirectories
        file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/include/${target}/${dir})

        # Find all of the files in this subdirectory
        cinch_subfilelist(file_list ${src}/${dir})

        # Create symbolic links to headers
        foreach(file ${file_list})
            if(${file} MATCHES ${CINCH_HEADER_SUFFIXES})
                execute_process(COMMAND
                    ln -s ${src}/${dir}/${file}
                        ${CMAKE_BINARY_DIR}/include/${target}/${dir}/${file})
            endif(${file} MATCHES ${CINCH_HEADER_SUFFIXES})
        endforeach(file)

    endforeach(dir)

    # Create public header links
    foreach(file ${${target}_PUBLIC_HEADERS})
            execute_process(COMMAND
                ln -s ${src}/${file}
                    ${CMAKE_BINARY_DIR}/include/${file})
    endforeach(file)

endfunction(cinch_make_include_links)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
