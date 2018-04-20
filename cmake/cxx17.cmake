#~----------------------------------------------------------------------------~#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#~----------------------------------------------------------------------------~#

# Determines whether or not the compiler supports C++17
macro(check_for_cxx17_compiler _VAR)

    message(STATUS "Checking for C++17 compiler")

    set(${_VAR})

    if((MSVC AND MSVC17) OR
        (CMAKE_COMPILER_IS_GNUCXX AND
            NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 7) OR
        (CMAKE_CXX_COMPILER_ID STREQUAL "Intel" AND
            NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 18) OR
        (CMAKE_CXX_COMPILER_ID STREQUAL "PGI" AND
            NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 17.7) OR
        (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND
            NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 3.6)

        set(${_VAR} 1)
        message(STATUS "Checking for C++17 compiler - available")

    else()

        message(STATUS "Checking for C++17 compiler - unavailable")

    endif()

endmacro()

# Sets the appropriate flag to enable C++17 support
macro(enable_cxx17)
    if(CYGWIN AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++17")
    else()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
    endif()
endmacro()

#~---------------------------------------------------------------------------~-#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#~---------------------------------------------------------------------------~-#
