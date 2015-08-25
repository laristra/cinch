#~----------------------------------------------------------------------------~#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#~----------------------------------------------------------------------------~#

# Determines whether or not the compiler supports C99
macro(check_for_c99_compiler _VAR)

    message(STATUS "Checking for C99 compiler")

    set(${_VAR})

    if((MSVC AND MSVC12) OR
        (CMAKE_COMPILER_IS_GNUCC AND
            NOT ${CMAKE_C_COMPILER_VERSION} VERSION_LESS 4.6) OR
        (CMAKE_C_COMPILER_ID STREQUAL "Intel" AND
            NOT ${CMAKE_C_COMPILER_VERSION} VERSION_LESS 12.10) OR
        (CMAKE_C_COMPILER_ID STREQUAL "PGI" AND
            NOT ${CMAKE_C_COMPILER_VERSION} VERSION_LESS 14.3) OR
        (CMAKE_C_COMPILER_ID STREQUAL "Clang" AND
            NOT ${CMAKE_C_COMPILER_VERSION} VERSION_LESS 3.1))

        set(${_VAR} 1)
        message(STATUS "Checking for C99 compiler - available")

    else()

        message(STATUS "Checking for C99 compiler - unavailable")

    endif()

endmacro()

# Sets the appropriate flag to enable C++11 support
macro(enable_c99)
    if(NOT CMAKE_C_COMPILER_ID STREQUAL "PGI")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")
    endif(NOT CMAKE_C_COMPILER_ID STREQUAL "PGI")
endmacro()

#~---------------------------------------------------------------------------~-#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#~---------------------------------------------------------------------------~-#
