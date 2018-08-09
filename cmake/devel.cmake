#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Add support development targets.
#------------------------------------------------------------------------------#

option(ENABLE_DEVEL_TARGETS "Enable development targets" OFF)

function(cinch_add_devel_target name)

    if(NOT ENABLE_DEVEL_TARGETS)
        return()
    endif()

    set(_TARGET_DIR devel)

    #--------------------------------------------------------------------------#
    # Add test options
    #--------------------------------------------------------------------------#

    include(detail/test-options)

    #--------------------------------------------------------------------------#
    # Process the test policy.
    #--------------------------------------------------------------------------#

    include(detail/test-policies)

    if(NOT test_policy_runtime)
        return()
    endif()

    #--------------------------------------------------------------------------#
    # Add the executable
    #--------------------------------------------------------------------------#

    add_executable(${name} ${test_SOURCES} ${_OUTPUT_DIR}/${_TARGET_MAIN})

    #--------------------------------------------------------------------------#
    # CLOG has pthread dependency
    #--------------------------------------------------------------------------#

    target_link_libraries(${name} ${CMAKE_THREAD_LIBS_INIT})

    #--------------------------------------------------------------------------#
    # Set test properties.
    #--------------------------------------------------------------------------#

    include(detail/test-properties)

    target_compile_definitions(${name} PRIVATE CINCH_DEVEL_TARGET)

    #--------------------------------------------------------------------------#
    # Process test inputs.
    #--------------------------------------------------------------------------#

    include(detail/test-inputs)

    if(test_FOLDER)
        set_target_properties(${name} PROPERTIES FOLDER "${test_FOLDER}")
    endif()

endfunction(cinch_add_devel_target)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
