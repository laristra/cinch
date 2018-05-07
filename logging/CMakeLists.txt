#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Require some version of cmake
#------------------------------------------------------------------------------#

cmake_minimum_required(VERSION 2.8)

option(ENABLE_CLOG "Enable Cinch logging" OFF)
if(ENABLE_CLOG)
    add_definitions(-DENABLE_CLOG)

    # Add an option to set the strip level
    set(CLOG_STRIP_LEVEL "0" CACHE STRING "Set the clog strip level")
    add_definitions(-DCLOG_STRIP_LEVEL=${CLOG_STRIP_LEVEL})

    # Allow color output
    option(CLOG_COLOR_OUTPUT "Enable colorized clog logging" ON)
    if(CLOG_COLOR_OUTPUT)
        add_definitions(-DCLOG_COLOR_OUTPUT)
    endif()

    # Enable tag groups
    option(CLOG_ENABLE_TAGS "Enable tag groups" OFF)
    if(CLOG_ENABLE_TAGS)
        set(CLOG_TAG_BITS "64" CACHE STRING
            "Select the number of bits to use for tag groups")
        add_definitions(-DCLOG_ENABLE_TAGS)
        add_definitions(-DCLOG_TAG_BITS=${CLOG_TAG_BITS})
    endif()

    # Externally scoped messages
    option(CLOG_ENABLE_EXTERNAL
        "Enable messages that are defined at external scope" OFF)
    if(CLOG_ENABLE_EXTERNAL)
        add_definitions(-DCLOG_ENABLE_EXTERNAL)
    endif()

    # MPI
    find_package(MPI)

    if(MPI_C_FOUND)
        option(CLOG_ENABLE_MPI "Enable clog MPI functions" OFF)
        if(CLOG_ENABLE_MPI)
            include_directories(${MPI_C_INCLUDE_PATH})
            add_definitions(-DCLOG_ENABLE_MPI)
        endif()

        set(CLOG_TURNSTILE_NWAY "1" CACHE STRING
            "Set the turnstile rotation for MPI messages")
        add_definitions(-DCLOG_TURNSTILE_NWAY=${CLOG_TURNSTILE_NWAY})
    endif()

    # Enable debugging
    option(CLOG_DEBUG "Enable clog debugging" OFF)
    if(CLOG_DEBUG)
        add_definitions(-DCLOG_DEBUG)
    endif()
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")

find_package(Boost COMPONENTS program_options REQUIRED)
include_directories(${Boost_INCLUDE_DIRS})

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_executable(clog_test clog_test.cc)

add_definitions(-DENABLE_CLOG)

target_link_libraries(clog_test ${Boost_LIBRARIES})

if(CLOG_ENABLE_MPI)
    target_link_libraries(clog_test ${MPI_LIBRARIES})
endif()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
