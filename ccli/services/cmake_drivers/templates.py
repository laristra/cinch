#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from string import Template

cmake_source_template = Template(
"""
#-----------------------------------------------------------------------------~#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#-----------------------------------------------------------------------------~#

set(${PARENT}_HEADERS
    ${CMAKE_CURRENT_SOURCE_DIR}/file1.h
    PARENT_SCOPE
)

#set(${PARENT}_SOURCES
#    ${CMAKE_CURRENT_SOURCE_DIR}/file1.cc
#    PARENT_SCOPE
#)

#if(ENABLE_UNIT_TESTS)
#    cinch_add_unit(casename testfile.cc)
#endif(ENABLE_UNIT_TESTS)

#----------------------------------------------------------------------------~-#
# Formatting options for vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#----------------------------------------------------------------------------~-#
""")

cmake_app_template = Template(
"""
#-----------------------------------------------------------------------------~#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#-----------------------------------------------------------------------------~#

#------------------------------------------------------------------------------#
# Add a rule to build the executable
#------------------------------------------------------------------------------#

add_executable(executable file1.cc)

#------------------------------------------------------------------------------#
# Add link dependencies
#------------------------------------------------------------------------------#

target_link_libraries(executable libraries)

#----------------------------------------------------------------------------~-#
# Formatting options for vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#----------------------------------------------------------------------------~-#
""")
