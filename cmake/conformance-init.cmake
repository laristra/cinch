#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

option(ENABLE_CONFORMANCE_TESTS "Enable compiler conformance tests" OFF)

if(ENABLE_CONFORMANCE_TESTS)
    set(CXX_CONFORMANCE_STANDARD "c++14"
        CACHE STRING "Set C++ standard (c++14,c++17, etc...)")
endif(ENABLE_CONFORMANCE_TESTS)

if(ENABLE_CONFORMANCE_TESTS)
    file(WRITE ${CMAKE_BINARY_DIR}/conformance-report.txt
"#------------------------------------------------------------------------------#\n"
        "# CSSE Conformance Test Report\n"
"#------------------------------------------------------------------------------#\n\n"
    )
endif(ENABLE_CONFORMANCE_TESTS)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
