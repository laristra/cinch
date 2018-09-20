#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Add Legion support.
#------------------------------------------------------------------------------#

option(ENABLE_LEGION "Enable Legion" OFF)

if(ENABLE_LEGION)

    find_package(Legion REQUIRED)

    if(NOT Legion_FOUND)
        message(FATAL_ERROR "Legion is required for this build configuration")
    endif(NOT Legion_FOUND)

    set(CMAKE_PREFIX_PATH  ${CMAKE_PREFIX_PATH} ${LEGION_INSTALL_DIRS})

    include_directories(${Legion_INCLUDE_DIRS})

    # old flags: remove once support for older Legion versions is not required
    add_definitions(-DLEGION_CMAKE)

    # new flags: required by newer Legion versions
    add_definitions(-DLEGION_USE_CMAKE)
    add_definitions(-DREALM_USE_CMAKE)

    list(APPEND CINCH_RUNTIME_LIBRARIES ${Legion_LIBRARIES})

    message(STATUS "Legion found: ${Legion_FOUND}")

endif(ENABLE_LEGION)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
