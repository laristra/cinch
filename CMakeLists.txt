#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

project(cinch)

cmake_minimum_required(VERSION 2.8)

#------------------------------------------------------------------------------#
# Cinch cmake search path and includes
#------------------------------------------------------------------------------#

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

include(insource)
include(documentation)
include(version)

#------------------------------------------------------------------------------#
# Add distclean target
#------------------------------------------------------------------------------#

add_custom_target(distclean rm -rf ${CMAKE_BINARY_DIR}/*)

#------------------------------------------------------------------------------#
# Add version options and creation
#------------------------------------------------------------------------------#

set(VERSION_CREATION "git describe" CACHE STRING
    "Set a static version instead of using git describe")

if(VERSION_CREATION)
    set(${PROJECT_NAME}_VERSION ${VERSION_CREATION})
else()
    cinch_make_version()
endif(VERSION_CREATION)

#------------------------------------------------------------------------------#
# Add documentation target
#------------------------------------------------------------------------------#

configure_file(${CMAKE_SOURCE_DIR}/doc/cinchheader.tex.in
    ${CMAKE_BINARY_DIR}/doc/cinchheader.tex)

set(ug_pandoc_options
    "--toc"
    "--toc-depth=2"
    "--include-in-header=${CMAKE_SOURCE_DIR}/tex/addtolength.tex"
    "--include-in-header=${CMAKE_BINARY_DIR}/doc/cinchheader.tex"
    "--include-in-header=${CMAKE_SOURCE_DIR}/doc/cinchtitle.tex"
    "--include-before-body=${CMAKE_SOURCE_DIR}/tex/maketitle.tex"
    "--include-before-body=${CMAKE_SOURCE_DIR}/tex/firstpageempty.tex"
    "--include-before-body=${CMAKE_SOURCE_DIR}/tex/titlebreak.tex"
)

cinch_add_doc(${PROJECT_NAME}-ug ugconfig.py . cinch-ug-${cinch_VERSION}.pdf
    PANDOC_OPTIONS ${ug_pandoc_options})

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
