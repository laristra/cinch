#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_add_unit target)

    #--------------------------------------------------------------------------#
    # Setup argument options.
    #--------------------------------------------------------------------------#

    set(options)
    set(one_value_args)
    set(multi_value_args SOURCES DEFINES DEPENDS INPUTS
        LIBRARIES POLICY THREADS)
    cmake_parse_arguments(unit "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    #------------------------------------------------------------------#
    # Set output directory information
    #------------------------------------------------------------------#

    if("${CMAKE_PROJECT_NAME}" STREQUAL "${PROJECT_NAME}")
        set(_TEST_PREFIX)
    else()
        set(_TEST_PREFIX "${PROJECT_NAME}:")
    endif()
    
    #------------------------------------------------------------------#
    # Check to see if the user has specified a runtime and
    # process it
    #------------------------------------------------------------------#
    
    if(NOT unit_POLICY)
        set(unit_POLICY "SERIAL")
    endif(NOT unit_POLICY)
           
    if(NOT ${unit_POLICY}_TEST_POLICY_LIST)
        return()
    endif()



    # Get policy information
    string(REPLACE ":" ";" unit_policy_list
        "${${unit_POLICY}_TEST_POLICY_LIST}")

    list(GET unit_policy_list 0 unit_policy_name)
    list(GET unit_policy_list 1 unit_policy_runtime)
    list(GET unit_policy_list 2 unit_policy_flags)
    list(GET unit_policy_list 3 unit_policy_includes)
    list(GET unit_policy_list 4 unit_policy_defines)
    list(GET unit_policy_list 5 unit_policy_libraries)
    list(GET unit_policy_list 6 unit_policy_exec)
    list(GET unit_policy_list 7 unit_policy_exec_threads)

    # Convert stored values back into lists
    string(REPLACE "|" ";" unit_policy_runtime
        "${unit_policy_runtime}")
    string(REPLACE "|" ";" unit_policy_flags
        "${unit_policy_flags}")
    string(REPLACE "|" ";" unit_policy_includes
        "${unit_policy_includes}")
    string(REPLACE "|" ";" unit_policy_defines
        "${unit_policy_defines}")
    string(REPLACE "|" ";" unit_policy_libraries
        "${unit_policy_libraries}")


    get_filename_component(_RUNTIME_MAIN ${unit_policy_runtime} NAME)
    set(_TARGET_MAIN ${target}_${_RUNTIME_MAIN})
    configure_file(${unit_policy_runtime}
        ${_TARGET_MAIN} COPYONLY)


    #--------------------------------------------------------------------------#
    # Make sure that the user specified sources.
    #--------------------------------------------------------------------------#

    if(NOT unit_SOURCES)
        message(FATAL_ERROR
            "You must specify unit test source files using SOURCES")
    endif(NOT unit_SOURCES)

    add_executable( ${target} ${unit_SOURCES} ${_TARGET_MAIN})

    #--------------------------------------------------------------------------#
    # Check for defines.
    #--------------------------------------------------------------------------#

    if(unit_DEFINES)
      target_compile_definitions(${target} PRIVATE ${unit_DEFINES})
    endif()

    if(NOT "${unit_policy_defines}" STREQUAL "None")
      target_compile_definitions(${target} PRIVATE ${unit_policy_defines})
    endif()

    #--------------------------------------------------------------------------#
    # Check for explicit dependencies. This flag is necessary for
    # preprocessor header includes.
    #--------------------------------------------------------------------------#

    if(unit_DEPENDS)
      add_dependencies( ${target} ${unit_DEPENDENCIES} )
    endif()

    #--------------------------------------------------------------------------#
    # Check for files. 
    #--------------------------------------------------------------------------#
    
    if (unit_INPUTS)
        set(_OUTPUT_FILES)
        foreach(input ${unit_INPUTS})
            get_filename_component(_OUTPUT_NAME ${input} NAME)
            add_custom_command(OUTPUT ${_OUTPUT_NAME}
                COMMAND ${CMAKE_COMMAND} -E copy 
                ${CMAKE_CURRENT_SOURCE_DIR}/${input}
                ${_OUTPUT_NAME}
                DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${input}
                COMMENT "Copying ${input} for ${target}")
            list(APPEND _OUTPUT_FILES ${_OUTPUT_NAME})
        endforeach()
        add_custom_target(${target}_inputs
            DEPENDS ${_OUTPUT_FILES})
        add_dependencies(${target} ${target}_inputs)
    endif()

    #--------------------------------------------------------------------------#
    # Check for library dependencies.
    #--------------------------------------------------------------------------#

    target_link_libraries( ${target} ${unit_LIBRARIES} ${GTEST_LIBRARIES} )

    if(ENABLE_GFLAGS)
        target_link_libraries(${target} ${GFLAGS_LIBRARIES})
    endif()


    if(NOT "${unit_policy_libraries}" STREQUAL "None")
      target_link_libraries( ${target} ${unit_policy_libraries} )
    endif()

    if(NOT "${unit_policy_includes}" STREQUAL "None")
        target_include_directories(${target}
            PRIVATE ${unit_policy_includes})
    endif()

    #--------------------------------------------------------------------------#
    # Check for threads.
    #
    # If found, replace the semi-colons with pipes to avoid list
    # interpretation.
    #--------------------------------------------------------------------------#

    if(NOT unit_THREADS)
        set(unit_THREADS 1)
    endif(NOT unit_THREADS)

    #------------------------------------------------------------------#
    # Add the test target to CTest
    #------------------------------------------------------------------#

    list(LENGTH unit_THREADS thread_instances)

    string(REGEX MATCH "DEVEL" _IS_DEVEL
        ${unit_POLICY})

    set(_IS_GTEST)
    if(NOT "${unit_POLICY}" STREQUAL "FORTRAN"
        AND NOT _IS_DEVEL)
        set(_IS_GTEST TRUE)
    endif()

    if(_IS_GTEST)
        set(UNIT_FLAGS --gtest_color=no)
        if(ENABLE_COLOR_UNIT_TESTS)
            set(UNIT_FLAGS --gtest_color=yes)
        endif(ENABLE_COLOR_UNIT_TESTS)
    else()
        set(UNIT_FLAGS)
    endif()

    if(${thread_instances} GREATER 1)

        foreach(instance ${unit_THREADS})
            if(ENABLE_JENKINS_OUTPUT AND _IS_GTEST)
                set(_OUTPUT
                    ${target}_${instance}.xml)
                set(UNIT_FLAGS ${UNIT_FLAGS}
                    --gtest_output=xml:${_OUTPUT})
            endif()

            add_test(
                NAME
                    "${_TEST_PREFIX}${target}_${instance}"
                COMMAND
                    ${unit_policy_exec}
                    ${unit_policy_exec_threads} ${instance}
                    ${target}
                    ${UNIT_FLAGS} )
        endforeach(instance)

    else()

        if(ENABLE_JENKINS_OUTPUT AND _IS_GTEST)
            set(_OUTPUT
                ${target}.xml)
            set(UNIT_FLAGS ${UNIT_FLAGS}
                --gtest_output=xml:${_OUTPUT})
        endif()

        if(NOT "${unit_policy_exec}" STREQUAL "None")
            add_test(
                NAME
                    "${_TEST_PREFIX}${target}"
                COMMAND
                    ${unit_policy_exec}
                    ${unit_policy_exec_threads}
                    ${unit_target_execution_threads}
                    ${_OUTPUT_DIR}/${unit_target_name}
                    ${UNIT_FLAGS})
        else()
            add_test(
                NAME
                    "${_TEST_PREFIX}${target}"
                COMMAND
                    ${target}
                    ${UNIT_FLAGS})
        endif(NOT "${unit_policy_exec}" STREQUAL "None")

    endif(${thread_instances} GREATER 1)


endfunction(cinch_add_unit)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
