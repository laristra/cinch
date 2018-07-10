#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# This function creates a sequential version number using a call to
# 'git describe master'

set(VERSION_CREATION "git describe" CACHE STRING "Set a static version")

if(NOT "${VERSION_CREATION}" STREQUAL "git describe")
    set(${PROJECT_NAME}_VERSION ${VERSION_CREATION})
else()

    #--------------------------------------------------------------------------#
    # Make sure that git is available
    #--------------------------------------------------------------------------#

    find_package(Git)

    if(NOT GIT_FOUND)
        message(WARNING "Git not found, using dummy version dummy-0.0.0")
        set(_version "dummy-0.0.0")
    else()

        #----------------------------------------------------------------------#
        # Call 'git describe'
        #----------------------------------------------------------------------#

    execute_process(COMMAND ${GIT_EXECUTABLE} describe HEAD
        OUTPUT_VARIABLE _version
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)

    endif()

    #--------------------------------------------------------------------------#
    # If 'git describe' failed somehow, create a dummy
    #--------------------------------------------------------------------------#

    if(NOT _version)
        message(WARNING "Git describe failed, using dummy version dummy-0.0.0")
        set(_version "dummy-0.0.0")
    endif()

    #--------------------------------------------------------------------------#
    # Set the parent scope version variable
    #--------------------------------------------------------------------------#

    set(${PROJECT_NAME}_VERSION ${_version})

endif()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
