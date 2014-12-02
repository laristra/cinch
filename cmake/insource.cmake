#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# This script prevents users from creating in-source builds

function(prevent_insource_builds)

    if(${CMAKE_CURRENT_SOURCE_DIR} STREQUAL ${CMAKE_CURRENT_BINARY_DIR})
        message(FATAL_ERROR "\nIn-place builds are not supported!!!\n"
"######################################################################\n"
"You must first clean up the current directory by executing:\n"
"  `cmake -P cmake/distclean.cmake`\n"
"!!!Failure to do so will prevent all builds!!!\n"
"Then create a build directory in a suitable location and execute:\n"
"  `cmake ${CMAKE_CURRENT_SOURCE_DIR}`\n"
"For Example:\n"
"  % mkdir build\n"
"  % cd build\n"
"  % cmake ${CMAKE_CURRENT_SOURCE_DIR}\n"
"######################################################################"
        )
    endif()

endfunction(prevent_insource_builds)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
