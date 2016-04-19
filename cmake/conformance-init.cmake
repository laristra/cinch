#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_init_conformance_tests)
    file(WRITE ${CMAKE_BINARY_DIR}/conformance-report.txt
"#------------------------------------------------------------------------------#\n"
        "# CSSE Conformance Test Report\n"
"#------------------------------------------------------------------------------#\n\n"
    )
endfunction(cinch_init_conformance_tests)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
