#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# Run the integrated test executable.
execute_process(
    COMMAND
        ${INETEGRATED_TEST}
    RESULT_VARIABLE
        TEST_EXIT
    WORKING_DIRECTORY
        ${WORKING_DIR}
)

if(TEST_EXIT)
    message(FATAL_ERROR "Integrated test execution failed")
endif()

execute_process(
    COMMAND
        ${INTEGRATED_ANALYSIS}
    RESULT_VARIABLE
        ANALYSIS_EXIT
    WORKING_DIRECTORY
        ${WORKING_DIR}
)

# Run the post-test analysis.
if(ANALYSIS_EXIT)
    message(FATAL_ERROR "Integrated test analysis failed")
endif()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
