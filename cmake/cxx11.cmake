#~----------------------------------------------------------------------------~#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#~----------------------------------------------------------------------------~#

# Determines whether or not the compiler supports C++11
macro(check_for_cxx11_compiler _VAR)

    message(STATUS "Checking for C++11 compiler")

    set(${_VAR})

    if((MSVC AND (MSVC10 OR MSVC11 OR MSVC12)) OR
        (CMAKE_COMPILER_IS_GNUCXX AND
            NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 4.6) OR
        (CMAKE_CXX_COMPILER_ID STREQUAL "Intel" AND
            NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 12.10) OR
        (CMAKE_CXX_COMPILER_ID STREQUAL "PGI" AND
            NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 14.3) OR
        (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND
            NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 3.1) OR
        (CMAKE_CXX_COMPILER_ID STREQUAL "Cray" AND
            NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 8.4))

        set(${_VAR} 1)
        message(STATUS "Checking for C++11 compiler - available")

    else()

        message(STATUS "Checking for C++11 compiler - unavailable")

    endif()

endmacro()

# Sets the appropriate flag to enable C++11 support
macro(enable_cxx11)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "Cray")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -h std=c++11")
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "PGI")
    elseif(CYGWIN AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11")
    else()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    endif()
endmacro()

#~---------------------------------------------------------------------------~-#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#~---------------------------------------------------------------------------~-#
