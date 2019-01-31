#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Add Graphviz support.
#------------------------------------------------------------------------------#

option(ENABLE_GRAPHVIZ "Enable Graphviz" OFF)

if(ENABLE_GRAPHVIZ)
    find_package(Graphviz REQUIRED)

    if(NOT Graphviz_FOUND)
        message(FATAL_ERROR "Graphviz is required for this build configuration")
    endif()

    message(STATUS "Found Graphviz: ${GRAPHVIZ_INCLUDE_DIRS}")

    include_directories(${GRAPHVIZ_INCLUDE_DIRS})
    add_definitions(-DENABLE_GRAPHVIZ)
    list(APPEND CINCH_RUNTIME_LIBRARIES ${GRAPHVIZ_LIBRARIES})
endif(ENABLE_GRAPHVIZ)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
