#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Require some version of cmake
#------------------------------------------------------------------------------#

# We are using target_include_directories, which is a cmake-3.0 feature
set(CINCH_REQUIRED_CMAKE_VERSION 3.0)

cmake_minimum_required(VERSION ${CINCH_REQUIRED_CMAKE_VERSION})


#------------------------------------------------------------------------------#
# Set to release if no build type has been specified
#------------------------------------------------------------------------------#

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING
        "CMake build type <Debug|Release|RelWithDebInfo|MinSizeRel>" FORCE)
endif(NOT CMAKE_BUILD_TYPE)

if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug" OR
    "${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
    add_definitions(-DDEBUG)
endif("${CMAKE_BUILD_TYPE}" STREQUAL "Debug" OR
    "${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")

#------------------------------------------------------------------------------#
# Print useful information
#------------------------------------------------------------------------------#

if(CMAKE_INSTALL_PREFIX)
    message(STATUS "Install prefix set to ${CMAKE_INSTALL_PREFIX}")
endif(CMAKE_INSTALL_PREFIX)

if(CMAKE_CXX_FLAGS)
    message(STATUS "C++ compiler flags set to ${CMAKE_CXX_FLAGS}")
endif(CMAKE_CXX_FLAGS)

if(CMAKE_C_FLAGS)
    message(STATUS "C compiler flags set to ${CMAKE_C_FLAGS}")
endif(CMAKE_C_FLAGS)

if(CMAKE_FORTRAN_FLAGS)
    message(STATUS "Fortran compiler flags set to ${CMAKE_FORTRAN_FLAGS}")
endif(CMAKE_FORTRAN_FLAGS)


#------------------------------------------------------------------------------#
# Create a version for the project
#------------------------------------------------------------------------------#

include(version)

set(VERSION_CREATION "git describe" CACHE STRING "Set a static version")

if(NOT "${VERSION_CREATION}" STREQUAL "git describe")
    set(${PROJECT_NAME}_VERSION ${VERSION_CREATION})
else()
    cinch_make_version()
endif(NOT "${VERSION_CREATION}" STREQUAL "git describe")

message(STATUS "Creating build for version "
    "${PROJECT_NAME}-${${PROJECT_NAME}_VERSION}")

#------------------------------------------------------------------------------#
# Keep users from creating insource builds.
#------------------------------------------------------------------------------#

include(insource)

cinch_prevent_insource_builds()

#------------------------------------------------------------------------------#
# Load to allow users to specify the cinch version
#------------------------------------------------------------------------------#

include(cinch_minimum_required)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 filetype=cmake expandtab :
#------------------------------------------------------------------------------#
