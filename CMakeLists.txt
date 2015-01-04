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

set(ug_pandoc_options
    "--toc"
    "--chapters"
#    "--include-in-header=${CMAKE_SOURCE_DIR}/tex/addtolength.tex"
    "--include-in-header=${CMAKE_SOURCE_DIR}/doc/cinchheader.tex"
    "--include-in-header=${CMAKE_SOURCE_DIR}/doc/cinchtitle.tex"
    "--include-before-body=${CMAKE_SOURCE_DIR}/tex/maketitle.tex"
#    "--include-before-body=${CMAKE_SOURCE_DIR}/tex/firstpageempty.tex"
#    "--include-before-body=${CMAKE_SOURCE_DIR}/tex/titlebreak.tex"
)
    

cinch_add_doc(${PROJECT_NAME}-ug ugconfig.py .  cinch-ug-${cinch_VERSION}.pdf
    PANDOC_OPTIONS ${ug_pandoc_options})

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
