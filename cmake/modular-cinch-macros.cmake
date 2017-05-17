#------------------------------------------------------------------------------#
# Copyright (c) 2017 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#[=============================================================================[
modular-cinch-macros
--------------------

Provides a set of useful macros to the user to make creating cmake 
projects easier.

.. command:: mcinch_add_unit

  The ``mcinch_add_unit`` function creates a custom unit test with
  various different runtime policies::

   mcinch_add_unit( <name> [<option>...] )

  General options are:

  ``SOURCES <sources>...``
    The sources necessary to build the test executable
  ``DEFINES <defines>...``
    The defines used to build the executable
  ``DEPENDS <dependancies>...``
    The dependancies of the test target
  ``INPUTS <inputs>...``
    The input files used to run the test
  ``LIBRARIES <libraries>...``
    The libraries needed to link to the executable
  ``POLICY <policies>...``
    The runtime policies to use when executing the test 
  ``THREADS <threads>...``
    The number of threads to run the test with
#]=============================================================================]

function(mcinch_add_unit name)

    #--------------------------------------------------------------------------#
    # Setup argument options.
    #--------------------------------------------------------------------------#

    set(options)
    set(one_value_args WORKING_DIRECTORY)
    set(multi_value_args SOURCES INPUTS
        POLICY THREADS)
    cmake_parse_arguments(unit "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    # add a slash on the end of working dir if its not empty
    if (unit_WORKING_DIRECTORY)
      set(_OUTPUT_DIR  "${unit_WORKING_DIRECTORY}/" )
    else()
      set( _OUTPUT_DIR )
    endif()

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
           
    # Don't create the unit test if its policy is not defined
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
    set(_TARGET_MAIN ${name}_${_RUNTIME_MAIN})
    configure_file(${unit_policy_runtime}
      ${_OUTPUT_DIR}${_TARGET_MAIN} COPYONLY)


    #--------------------------------------------------------------------------#
    # Make sure that the user specified sources.
    #--------------------------------------------------------------------------#

    if(NOT unit_SOURCES)
        message(FATAL_ERROR
            "You must specify unit test source files using SOURCES")
    endif(NOT unit_SOURCES)

    #--------------------------------------------------------------------------#
    # Add the executable
    #--------------------------------------------------------------------------#

    if("${unit_POLICY}" STREQUAL "FORTRAN")
        set(_FORTRAN_SOURCES)
        set(_FORTRAN_SPECIALS)

        # Run pFUnit preprocessor on .pf files
        foreach(source ${unit_SOURCES})
            get_filename_component(_EXT ${source} EXT)
            get_filename_component(_PATH ${source} ABSOLUTE)

            if("${_EXT}" STREQUAL ".pf")
                get_filename_component(_BASE ${source} NAME_WE)
                add_custom_command(OUTPUT ${_OUTPUT_DIR}${_BASE}.F90
                    COMMAND ${PYTHON_EXECUTABLE} ${PFUNIT_PARSER} ${_PATH}
                    ${_OUTPUT_DIR}${_BASE}.F90
                    DEPENDS ${source}
                    COMMENT "Generating ${_OUTPUT_DIR}${_BASE}.F90 using pfunit")
                list(APPEND _FORTRAN_SOURCES ${_OUTPUT_DIR}${_BASE}.F90)
            elseif("${_EXT}" STREQUAL ".inc")
                get_filename_component(_OUTPUT_NAME ${source} NAME)
                add_custom_command(OUTPUT ${_OUTPUT_DIR}${_OUTPUT_NAME}
                    COMMAND ${CMAKE_COMMAND} -E copy ${_PATH}
                    ${_OUTPUT_DIR}${_OUTPUT_NAME}
                    DEPENDS ${source}
                    COMMENT "Copying ${source} for ${name}")
                add_custom_target(${name}_inc_file DEPENDS
                    ${_OUTPUT_DIR}${_OUTPUT_NAME})
                list(APPEND _FORTRAN_SPECIALS
                    ${name}_inc_file)
            else()
                list(APPEND _FORTRAN_SOURCES ${source})
            endif()
        endforeach()

        add_executable(${name} ${_FORTRAN_SOURCES}
            ${unit_policy_runtime})

        if ( _OUTPUT_DIR ) 
          target_include_directories(${name} PRIVATE ${_OUTPUT_DIR})
        else()
          target_include_directories(${name} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
        endif()

        add_dependencies(${name} pfunit)
        add_dependencies(${name} ${_FORTRAN_SPECIALS})

        set(_PFUNIT_DEFINES)
        list(APPEND _PFUNIT_DEFINES ${CMAKE_Fortran_COMPILER_ID})
        list(APPEND _PFUNIT_DEFINES BUILD_ROBUST)

        set_target_properties(${name}
            PROPERTIES COMPILE_DEFINITIONS "${_PFUNIT_DEFINES}")
    else()
        add_executable(${name} ${unit_SOURCES} ${_OUTPUT_DIR}${_TARGET_MAIN})
        target_link_libraries( ${name} ${GTEST_LIBRARIES} )
    endif()

    if(NOT "${unit_policy_flags}" STREQUAL "None")
        target_compile_options(${name}
            PRIVATE ${unit_policy_flags})
    endif()

    #--------------------------------------------------------------------------#
    # Check for defines.
    #--------------------------------------------------------------------------#

    if(NOT "${unit_policy_defines}" STREQUAL "None")
      target_compile_definitions(${name} PRIVATE ${unit_policy_defines})
    endif()

    #--------------------------------------------------------------------------#
    # Check for input files. 
    #--------------------------------------------------------------------------#
    
    if (unit_INPUTS)
        set(_OUTPUT_FILES)
        foreach(input ${unit_INPUTS})
            get_filename_component(_OUTPUT_NAME ${input} NAME)
            get_filename_component(_PATH ${input} ABSOLUTE)
            add_custom_command(OUTPUT ${_OUTPUT_DIR}${_OUTPUT_NAME}
                COMMAND ${CMAKE_COMMAND} -E copy 
                ${_PATH}
                ${_OUTPUT_DIR}${_OUTPUT_NAME}
                DEPENDS ${input}
                COMMENT "Copying ${input} for ${name}")
            list(APPEND _OUTPUT_FILES ${_OUTPUT_DIR}${_OUTPUT_NAME})
        endforeach()
        add_custom_target(${name}_inputs
            DEPENDS ${_OUTPUT_FILES})
        add_dependencies(${name} ${name}_inputs)
    endif()

    #--------------------------------------------------------------------------#
    # Check for library dependencies.
    #--------------------------------------------------------------------------#

    if(ENABLE_BOOST_PROGRAM_OPTIONS)
        target_link_libraries(${name} ${Boost_LIBRARIES})
    endif()

    if(NOT "${unit_policy_libraries}" STREQUAL "None")
      target_link_libraries( ${name} ${unit_policy_libraries} )
    endif()

    if(NOT "${unit_policy_includes}" STREQUAL "None")
        target_include_directories(${name}
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
                    ${_OUTPUT_DIR}${name}_${instance}.xml)
                set(UNIT_FLAGS ${UNIT_FLAGS}
                    --gtest_output=xml:${_OUTPUT})
            endif()

            add_test(
                NAME
                    "${_TEST_PREFIX}${name}_${instance}"
                COMMAND
                    ${unit_policy_exec}
                    ${unit_policy_exec_threads} ${instance}
                    ${_OUTPUT_DIR}${name}
                    ${UNIT_FLAGS} 
                WORKING_DIRECTORY ${_OUTPUT_DIR})
        endforeach(instance)

    else()

        if(ENABLE_JENKINS_OUTPUT AND _IS_GTEST)
            set(_OUTPUT
                ${_OUTPUT_DIR}${name}.xml)
            set(UNIT_FLAGS ${UNIT_FLAGS}
                --gtest_output=xml:${_OUTPUT})
        endif()

        if(NOT "${unit_policy_exec}" STREQUAL "None")
            add_test(
                NAME
                    "${_TEST_PREFIX}${name}"
                COMMAND
                    ${unit_policy_exec}
                    ${unit_policy_exec_threads}
                    ${unit_target_execution_threads}
                    ${_OUTPUT_DIR}${name}
                    ${UNIT_FLAGS}
                WORKING_DIRECTORY ${_OUTPUT_DIR})
        else()
            add_test(
                NAME
                    "${_TEST_PREFIX}${name}"
                COMMAND
                    ${_OUTPUT_DIR}${name}
                    ${UNIT_FLAGS}
                WORKING_DIRECTORY ${_OUTPUT_DIR})
        endif(NOT "${unit_policy_exec}" STREQUAL "None")

    endif(${thread_instances} GREATER 1)


endfunction(mcinch_add_unit)

#[=============================================================================[
.. command:: mcinch_install_headers

  The ``mcinch_install_headers`` function installs a list of files,
  preserving the relative paths.  Normal use of ``install`` does
  not.  The command is used as follows::

   mcinch_install_headers( [<option>...] )

  General options are:

  ``FILES <files>...``
    The files to install
  ``DESTINATION <destination>``
    The location to install the files to
#]=============================================================================]

function(mcinch_install_headers)

    set(options)
    set(one_value_args DESTINATION)
    set(multi_value_args FILES)

    cmake_parse_arguments(args "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    foreach ( file ${args_FILES} )
      get_filename_component( dir ${file} DIRECTORY )
      install( FILES ${file} DESTINATION ${args_DESTINATION}/${dir} )
    endforeach()

endfunction()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
