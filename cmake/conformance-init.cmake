#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Set the default language standard for conformance tests
#------------------------------------------------------------------------------#

set(CXX_CONFORMANCE_STANDARD "c++14"
    CACHE STRING "Set C++ standard (c++14,c++17, etc...)")

#------------------------------------------------------------------------------#
# Conformance test initialization
#
# Mostly this justs sets up the output file...
#------------------------------------------------------------------------------#

function(cinch_initialize_conformance_tests)

    if(ENABLE_CONFORMANCE_TESTS)

        file(WRITE ${CMAKE_BINARY_DIR}/conformance-report.txt
    "#-------------------------------------------------------"
    "-----------------------#\n"
            "# CSSE Conformance Test Report\n"
    "#-------------------------------------------------------"
    "-----------------------#\n\n"
        )

        file(APPEND ${CMAKE_BINARY_DIR}/conformance-report.txt
            "Compiler: ${CMAKE_CXX_COMPILER}\n"
            "Compiler Version: ${CMAKE_CXX_COMPILER_VERSION}\n"
            "Compiler Flags:${CMAKE_CXX_FLAGS}\n"
        )

        file(APPEND ${CMAKE_BINARY_DIR}/conformance-report.txt "\n")

    endif(ENABLE_CONFORMANCE_TESTS)
endfunction(cinch_initialize_conformance_tests)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
