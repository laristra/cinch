#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Add option to enable capture
#------------------------------------------------------------------------------#

option(ENABLE_CAPTURE_ENV_MOD
  "Capture the currently-loaded environment modules" OFF)

if(ENABLE_CAPTURE_ENV_MOD)

    execute_process(
        COMMAND bash ${CINCH_SOURCE_DIR}/cmake/capture_env_mods
            ${CMAKE_PROJECT_NAME}
            "${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}-devel-module"
    )

    install(
        FILES ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}-devel-module
        DESTINATION bin
    )

endif()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
