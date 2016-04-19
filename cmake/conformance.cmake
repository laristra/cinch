#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_add_conformance_test target)

    if(ENABLE_CONFORMANCE_TESTS)
        #----------------------------------------------------------------------#
        # Setup argument options.
        #----------------------------------------------------------------------#

        set(options)
        set(one_value_args)
        set(multi_value_args SOURCES)
        cmake_parse_arguments(conformance "${options}" "${one_value_args}"
            "${multi_value_args}" ${ARGN})

        #----------------------------------------------------------------------#
        # Setup directory path
        #----------------------------------------------------------------------#

        set(full_path_sources)
        foreach(src ${conformance_SOURCES})
            list(APPEND full_path_sources ${CMAKE_CURRENT_SOURCE_DIR}/${src})
        endforeach(src ${conformance_SOURCES})

        #----------------------------------------------------------------------#
        # Try to compile
        #----------------------------------------------------------------------#

        try_compile(_RESULT ${CMAKE_BINARY_DIR}
            SOURCES ${full_path_sources}
            OUTPUT_VARIABLE _OUTPUT)

        #----------------------------------------------------------------------#
        # Process the results
        #----------------------------------------------------------------------#

        file(APPEND ${CMAKE_BINARY_DIR}/conformance-report.txt
            "#------------------------------------------------"
            "------------------------------#\n"
            "TEST: ${target}\n"
            "SOURCE: ${full_path_sources}\n"
            "#------------------------------------------------"
            "------------------------------#\n"
        )

        if(NOT _RESULT)
            file(APPEND ${CMAKE_BINARY_DIR}/conformance-report.txt
                "FAILED:\n"
            )
            file(APPEND ${CMAKE_BINARY_DIR}/conformance-report.txt
                "${_OUTPUT}\n")
            message(STATUS "${CINCH_BoldRed}"
                "Conformance test ${target} FAILED!!!"
                "${CINCH_ColorReset}"
            )
        else()
            file(APPEND ${CMAKE_BINARY_DIR}/conformance-report.txt
                "SUCCESS!!!\n"
                )
        endif(NOT _RESULT)

        file(APPEND ${CMAKE_BINARY_DIR}/conformance-report.txt "\n")
    endif(ENABLE_CONFORMANCE_TESTS)

endfunction(cinch_add_conformance_test)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
