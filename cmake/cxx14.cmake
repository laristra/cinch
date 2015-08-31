#~----------------------------------------------------------------------------~#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#~----------------------------------------------------------------------------~#

# Determines whether or not the compiler supports C++14
macro(check_for_cxx14_compiler _VAR)

    message(STATUS "Checking for C++14 compiler")

    set(${_VAR})

    if((MSVC AND MSVC14) OR
        (CMAKE_COMPILER_IS_GNUCXX AND
            NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 4.9) OR
        (CMAKE_CXX_COMPILER_ID STREQUAL "Intel" AND
            NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 16) OR
        (CMAKE_CXX_COMPILER_ID STREQUAL "PGI" AND
            NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 14.3) OR
        (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND
            NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 3.6))

        set(${_VAR} 1)
        message(STATUS "Checking for C++14 compiler - available")

    else()

        message(STATUS "Checking for C++14 compiler - unavailable")

    endif()

endmacro()

# Sets the appropriate flag to enable C++14 support
macro(enable_cxx14)
    if(NOT CMAKE_CXX_COMPILER_ID STREQUAL "PGI")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
    endif(NOT CMAKE_CXX_COMPILER_ID STREQUAL "PGI")
endmacro()

#~---------------------------------------------------------------------------~-#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#~---------------------------------------------------------------------------~-#
