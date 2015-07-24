#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_add_unit target)

    set(options)
    set(one_value_args)
    set(multi_value_args SOURCES)
    cmake_parse_arguments(unit "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    if(NOT unit_SOURCES)
        message(FATAL_ERROR
            "You must specify unit test source files using SOURCES")
    endif(NOT unit_SOURCES)

    add_executable(${target} ${unit_SOURCES})
    target_link_libraries(${target} ${GTEST_BOTH_LIBRARIES})
    set_target_properties(${target}
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/test)
    if(ENABLE_JENKINS_OUTPUT)
        add_test(${target} ${CMAKE_BINARY_DIR}/test/${target}
            --gtest_output=xml:${CMAKE_BINARY_DIR}/test/${target}.xml
            --gtest_color=yes)
    else()
        add_test(${target} ${CMAKE_BINARY_DIR}/test/${target})
    endif()

endfunction(cinch_add_unit)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
