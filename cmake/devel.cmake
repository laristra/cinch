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

    target_link_libraries(${name} PRIVATE ${CMAKE_THREAD_LIBS_INIT})

    #--------------------------------------------------------------------------#
    # Kokkos
    #--------------------------------------------------------------------------#

    if (ENABLE_KOKKOS)
        target_link_libraries(${name} PUBLIC ${Kokkos_LIBRARIES})
    endif()

    #--------------------------------------------------------------------------#
    # Set test properties.
    #--------------------------------------------------------------------------#

    include(detail/test-properties)

    target_compile_definitions(${name} PRIVATE CINCH_DEVEL_TARGET)

    #--------------------------------------------------------------------------#
    # Process test inputs.
    #--------------------------------------------------------------------------#

    include(detail/test-inputs)

    #--------------------------------------------------------------------------#
    # Set the folder property for VS and XCode
    #--------------------------------------------------------------------------#

    get_filename_component(_leafdir ${CMAKE_CURRENT_SOURCE_DIR} NAME)
    string(SUBSTRING ${_leafdir} 0 1 _first)
    string(TOUPPER ${_first} _first)
    string(REGEX REPLACE "^.(.*)" "${_first}\\1" _leafdir "${_leafdir}")
    string(CONCAT _folder "Tests/" ${_leafdir})
    string(CONCAT _folder ${_folder} "/Devel")
    set_target_properties(${name} PROPERTIES FOLDER "${_folder}")

endfunction(cinch_add_devel_target)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
