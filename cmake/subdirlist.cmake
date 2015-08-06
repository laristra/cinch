#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

macro(cinch_subdirlist result directory recursive)

    if(${recursive})
        file(GLOB_RECURSE children RELATIVE ${directory} ${directory}/*)
    else()         
        file(GLOB children RELATIVE ${directory} ${directory}/*)
    endif(${recursive})

    set(dir_list "")

    foreach(child ${children})
        if(NOT IS_DIRECTORY ${directory}/${child})
            get_filename_component(dir ${child} PATH) 
        else()
            set(dir ${child})
        endif(NOT IS_DIRECTORY ${directory}/${child})

        set(dir_list ${dir_list} ${dir})
    endforeach()

    list(REMOVE_DUPLICATES dir_list)    

    set(${result} ${dir_list})
endmacro(cinch_subdirlist)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
