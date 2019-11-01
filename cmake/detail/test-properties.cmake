#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

    #--------------------------------------------------------------------------#
    # Set the output directory.
    #--------------------------------------------------------------------------#

    set_target_properties(${name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY
        ${_OUTPUT_DIR})

    #--------------------------------------------------------------------------#
    # Add flags.
    #--------------------------------------------------------------------------#

    if(test_policy_flags)
        target_compile_options(${name} PRIVATE ${test_policy_flags})
    endif()

    #--------------------------------------------------------------------------#
    # Add include directories.
    #--------------------------------------------------------------------------#

    target_include_directories(${name} PRIVATE ${CINCH_SOURCE_DIR}/auxiliary)
    target_include_directories(${name} PRIVATE ${_OUTPUT_DIR})

    if(test_policy_includes)
        target_include_directories(${name} PRIVATE ${test_policy_includes})
    endif()

    #--------------------------------------------------------------------------#
    # Add defines.
    #--------------------------------------------------------------------------#

    if(test_policy_defines)
      target_compile_definitions(${name} PRIVATE ${test_policy_defines})
    endif()

    if(test_DEFINES)
      target_compile_definitions(${name} PRIVATE ${test_DEFINES})
    endif()

    target_compile_definitions(${name} PRIVATE DEVEL_TARGET_NAME=${name})

    #--------------------------------------------------------------------------#
    # Add library dependencies.
    #--------------------------------------------------------------------------#

    if(ENABLE_BOOST)
        find_package(Boost COMPONENTS program_options REQUIRED QUIET)
        target_include_directories(${name} PRIVATE ${Boost_INCLUDE_DIRS})
        target_compile_definitions(${name} PRIVATE
            ENABLE_BOOST)
        target_link_libraries(${name} ${Boost_LIBRARIES})
    endif()

    if (ENABLE_KOKKOS)
      target_compile_definitions(${name} PRIVATE
            ENABLE_KOKKOS)
      target_link_libraries(${name} ${Kokkos_LIBRARIES})
    endif()

    if(test_policy_libraries)
        target_link_libraries(${name} ${test_policy_libraries})
    endif()

    if(test_LIBRARIES)
        target_link_libraries(${name} ${test_LIBRARIES})
    endif()

    if (HPX_FOUND AND test_POLICY STREQUAL "HPX")
        hpx_setup_target(${name} NOPREFIX NOTLLKEYWORD)
    endif()
#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
