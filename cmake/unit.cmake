#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_add_unit target sources)

    add_executable(${target} ${sources})
    target_link_libraries(${target} gtest gtest_main)
    add_test(${target} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${target})

endfunction(cinch_add_unit)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
