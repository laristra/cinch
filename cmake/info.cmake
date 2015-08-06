#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_make_info target headers sources)

message(STATUS "DEBUG Info ${target}")
    set(output "${CMAKE_BINARY_DIR}/.${target}.buildinfo")

    file(WRITE "${output}" "#---------------------------------------"
             "---------------------------------------#\n")
    file(APPEND "${output}"
        "# CMake configuration information for target ${target}\n")
    file(APPEND "${output}"
        "# of top-level project ${CMAKE_PROJECT_NAME}\n#\n")
    file(APPEND "${output}" "# This information is stored in:\n"
        "# ${output}\n")
    file(APPEND "${output}" "#---------------------------------------"
        "---------------------------------------#\n")

    file(APPEND "${output}" "\n")

    # Write C++ header list
    file(APPEND "${output}" "# C++ Headers\n")
    foreach(hdr ${headers})
        file(APPEND "${output}" "${hdr}\n")
    endforeach(hdr)

    file(APPEND "${output}" "\n")

    # Write C++ source list
    file(APPEND "${output}" "# C++ Sources\n")
    foreach(src ${sources})
        file(APPEND "${output}" "${src}\n")
    endforeach(src)

    file(APPEND "${output}" "\n")

    add_custom_target(info.${target} cat ${output}) 
    if (NOT TARGET info)
        add_custom_target(info)
    endif (NOT TARGET info)
    add_dependencies(info info.${target})

endfunction(cinch_make_info)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
