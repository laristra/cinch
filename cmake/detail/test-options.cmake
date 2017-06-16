#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

    #--------------------------------------------------------------------------#
    # Add testing options.
    #--------------------------------------------------------------------------#

    set(options)
    set(one_value_args POLICY)
    set(multi_value_args SOURCES INPUTS THREADS LIBRARIES DEFINES)

    cmake_parse_arguments(test "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    #--------------------------------------------------------------------------#
    # Set output directory
    #--------------------------------------------------------------------------#

    get_filename_component(_SOURCE_DIR_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
    set(_OUTPUT_DIR "${CMAKE_BINARY_DIR}/${_TARGET_DIR}/${_SOURCE_DIR_NAME}")

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
