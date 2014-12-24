#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

project(cinch)

cmake_minimum_required(VERSION 2.8.12)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

include(insource)
include(documentation)
include(version)

option(STATIC_VERSION
    "Set a static version (don't use 'git describe')" OFF)

if(STATIC_VERSION)
    set(${PROJECT_NAME}_VERSION ${STATIC_VERSION})
else()
    cinch_make_version()
endif(STATIC_VERSION)

option(ENABLE_DOCUMENTATION "Enable documentation build" OFF)

if(ENABLE_DOCUMENTATION)
    cinch_add_doc(${PROJECT_NAME}-ug ${CMAKE_SOURCE_DIR}/doc/ugconfig.py
        ${CMAKE_SOURCE_DIR}
        ${PROJECT_NAME}-ug-${${PROJECT_NAME}_VERSION}.pdf)
endif(ENABLE_DOCUMENTATION)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
