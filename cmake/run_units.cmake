#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# This script runs gtest unit tests, writing output to a separate
# xml file for each unit test.

list(APPEND CMAKE_MODULE_PATH ${CINCH_MODULE_DIR})

include(subfilelist)

cinch_subfilelist(_UNITS ${CMAKE_BINARY_DIR}/test)

foreach(unit ${_UNITS})
    execute_process(COMMAND
        ${CMAKE_BINARY_DIR}/test/${unit}
            --gtest_output=xml:${CMAKE_BINARY_DIR}/test/${unit}.xml
            --gtest_color=yes)
        message("")
endforeach(unit ${_UNITS})

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
