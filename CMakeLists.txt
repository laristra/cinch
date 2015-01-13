#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

project(cinch)

cmake_minimum_required(VERSION 2.8.12)

#------------------------------------------------------------------------------#
# Cinch cmake search path and includes
#------------------------------------------------------------------------------#

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

include(insource)
include(documentation)
include(version)

#------------------------------------------------------------------------------#
# Add version options and creation
#------------------------------------------------------------------------------#

option(STATIC_VERSION
    "Set a static version (don't use 'git describe')" OFF)

if(STATIC_VERSION)
    set(${PROJECT_NAME}_VERSION ${STATIC_VERSION})
else()
    cinch_make_version()
endif(STATIC_VERSION)

#------------------------------------------------------------------------------#
# Add documentation target
#------------------------------------------------------------------------------#

configure_file(${CMAKE_SOURCE_DIR}/doc/cinchheader.tex.in
    ${CMAKE_BINARY_DIR}/doc/cinchheader.tex)

set(ug_pandoc_options
    "--toc"
    "--include-in-header=${CMAKE_SOURCE_DIR}/tex/addtolength.tex"
    "--include-in-header=${CMAKE_BINARY_DIR}/doc/cinchheader.tex"
    "--include-in-header=${CMAKE_SOURCE_DIR}/doc/cinchtitle.tex"
    "--include-before-body=${CMAKE_SOURCE_DIR}/tex/maketitle.tex"
    "--include-before-body=${CMAKE_SOURCE_DIR}/tex/firstpageempty.tex"
    "--include-before-body=${CMAKE_SOURCE_DIR}/tex/titlebreak.tex"
)

#------------------------------------------------------------------------------#
# Setup for command-line interface
#------------------------------------------------------------------------------#

find_package(PythonInterp REQUIRED)

#set(PYTHON_SCRIPT "import distutils.sysconfig as cg"
#    "print cg.get_python_lib(1,0,prefix='${CMAKE_INSTALL_PREFIX}')")

#execute_process(COMMAND ${PYTHON_EXECUTABLE} -c "${PYTHON_SCRIPT}"
#    OUTPUT_VARIABLE PYTHON_INSTDIR OUTPUT_STRIP_TRAILING_WHITESPACE)

#message(STATUS "${PYTHON_INSTDIR}")

add_custom_target(install-cli
    COMMAND ${PYTHON_EXECUTABLE} setup.py install --user
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/cli
)

cinch_add_doc(${PROJECT_NAME}-ug ugconfig.py .  cinch-ug-${cinch_VERSION}.pdf
    PANDOC_OPTIONS ${ug_pandoc_options})

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
