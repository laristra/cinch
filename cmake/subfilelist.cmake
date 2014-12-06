#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

macro(cinch_subfilelist result directory)

    file(GLOB children RELATIVE ${directory} ${directory}/*)

    set(dirlist "")

    foreach(child ${children})
        if(NOT IS_DIRECTORY ${directory}/${child})
            list(APPEND dirlist ${child})
        endif()
    endforeach()

    set(${result} ${dirlist})
endmacro(cinch_subfilelist)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
