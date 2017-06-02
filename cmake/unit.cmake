#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Add support for ctest, GTest, and pFUnit
#------------------------------------------------------------------------------#

option(ENABLE_UNIT_TESTS "Enable unit testing" OFF)
option(ENABLE_COLOR_UNIT_TESTS "Enable colorized unit testing output" OFF)
option(ENABLE_JENKINS_OUTPUT
    "Generate jenkins xml output for every test" OFF)

if(ENABLE_UNIT_TESTS)

    enable_testing()

    #--------------------------------------------------------------------------#
    # Google Test
    #--------------------------------------------------------------------------#

    find_package(GTest QUIET)

    if(GTEST_FOUND)
        include_directories(${GTEST_INCLUDE_DIRS})
    elseif(NOT TARGET gtest)
        find_package(Threads)
        add_library(gtest
            ${CINCH_SOURCE_DIR}/gtest/googletest/src/gtest-all.cc)
        target_include_directories(gtest PRIVATE
            ${CINCH_SOURCE_DIR}/gtest/googletest)
        target_link_libraries(gtest ${CMAKE_THREAD_LIBS_INIT})
        set(GTEST_INCLUDE_DIRS 
          ${CINCH_SOURCE_DIR}/gtest/googlemock/include
          ${CINCH_SOURCE_DIR}/gtest/googletest
          ${CINCH_SOURCE_DIR}/gtest/googletest/include)
        target_include_directories(gtest PRIVATE ${GTEST_INCLUDE_DIRS})
        set(GTEST_LIBRARIES gtest)
    endif()

    #--------------------------------------------------------------------------#
    # pFUnit
    #--------------------------------------------------------------------------#

    get_property(LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)

    list(FIND LANGUAGES "Fortran" FORTRAN_ENABLED)

    if(FORTRAN_ENABLED EQUAL -1)
        set(FORTRAN_ENABLED FALSE)
    endif(FORTRAN_ENABLED EQUAL -1)

    if(FORTRAN_ENABLED)
        find_package(PythonInterp QUIET)
        find_package(pFUnit QUIET)

        if(NOT PFUNIT_FOUND)
            include(${CINCH_SOURCE_DIR}/cmake/PFUnitLists.txt)
        endif()
    endif()

endif(ENABLE_UNIT_TESTS)


#[=============================================================================[
.. command:: mcinch_add_unit

  The ``mcinch_add_unit`` function creates a custom unit test with
  various different runtime policies::

   mcinch_add_unit(<name> [<option>...])

  General options are:

  ``SOURCES <sources>...``
    The sources necessary to build the test executable
  ``INPUTS <inputs>...``
    The input files used to run the test
  ``POLICY <policy>``
    The runtime policy to use when executing the test 
  ``THREADS <threads>...``
    The number of threads to run the test with
  ``LIBRARIES <libraries>...``
    List of libraries to link target against
  ``DEFINES <defines>...``
    Defines to set when building target
  ``DRIVER <driver_sources>...``
    Source files to build custom runtime driver.
#]=============================================================================]

function(cinch_add_unit name)


    if(NOT ENABLE_UNIT_TESTS)
      return()
    endif()

    #--------------------------------------------------------------------------#
    # Setup argument options.
    #--------------------------------------------------------------------------#

    set(options)
    set(one_value_args POLICY)
    set(multi_value_args 
        SOURCES INPUTS THREADS LIBRARIES DEFINES DRIVER
    )
    cmake_parse_arguments(unit "${options}" "${one_value_args}"
        "${multi_value_args}" ${ARGN})

    #--------------------------------------------------------------------------#
    # Set output directory
    #--------------------------------------------------------------------------#

    get_filename_component(_SOURCE_DIR_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
    set(_OUTPUT_DIR "${CMAKE_BINARY_DIR}/test/${_SOURCE_DIR_NAME}")

    #--------------------------------------------------------------------------#
    # Check to see if fortran is enabled
    #--------------------------------------------------------------------------#

    get_property(LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)

    list(FIND LANGUAGES "Fortran" FORTRAN_ENABLED)

    if(FORTRAN_ENABLED EQUAL -1)
        set(FORTRAN_ENABLED FALSE)
    endif(FORTRAN_ENABLED EQUAL -1)

    #--------------------------------------------------------------------------#
    # Make sure that MPI_LANGUAGE is set.  
    # This is not a standard variable set by FindMPI.  But cinch
    # might set it.
    #
    # Right now, the MPI policy only works with C/C++.
    #--------------------------------------------------------------------------#

    if(NOT MPI_LANGUAGE) 
      set(MPI_LANGUAGE C)
    endif()

    #--------------------------------------------------------------------------#
    # Set output directory information
    #--------------------------------------------------------------------------#

    if("${CMAKE_PROJECT_NAME}" STREQUAL "${PROJECT_NAME}")
        set(_TEST_PREFIX)
    else()
        set(_TEST_PREFIX "${PROJECT_NAME}:")
    endif()
    
    #--------------------------------------------------------------------------#
    # Check to see if the user has specified a runtime and
    # process it
    #--------------------------------------------------------------------------#
   
    if(unit_POLICY)
      string(REPLACE "_" ";" unit_policies ${unit_POLICY})
      list(GET unit_policies 0 unit_policy_main)
      string(REGEX MATCH "DEVEL" _IS_DEVEL ${unit_POLICY})
    endif()

    if(NOT unit_policy_main OR unit_policy_main STREQUAL "SERIAL")

      set(unit_policy_runtime ${CINCH_SOURCE_DIR}/auxiliary/test-standard.cc)
      set(unit_policy_defines -DSERIAL)

    elseif(FORTRAN_ENABLED AND unit_policy_main STREQUAL "FORTRAN")

      set(unit_policy_runtime ${PFUNIT_DRIVER})
      set(unit_policy_libraries ${PFUNIT_LIBRARY})
      set(unit_policy_defines ${PFUNIT_DEFINES})

    elseif(MPI_${MPI_LANGUAGE}_FOUND AND unit_policy_main STREQUAL "MPI")

      set(unit_policy_runtime ${CINCH_SOURCE_DIR}/auxiliary/test-mpi.cc)
      set(unit_policy_flags ${MPI_${MPI_LANGUAGE}_COMPILE_FLAGS})
      set(unit_policy_includes ${MPI_${MPI_LANGUAGE}_INCLUDE_PATH})
      set(unit_policy_libraries ${MPI_${MPI_LANGUAGE}_LIBRARIES})
      set(unit_policy_exec ${MPIEXEC})
      set(unit_policy_exec_threads ${MPIEXEC_NUMPROC_FLAG})

    elseif(MPI_${MPI_LANGUAGE}_FOUND AND Legion_FOUND AND 
        unit_policy_main STREQUAL "LEGION")

      set(unit_policy_runtime ${CINCH_SOURCE_DIR}/auxiliary/test-legion.cc)
      set(unit_policy_flags ${Legion_CXX_FLAGS} 
        ${MPI_${MPI_LANGUAGE}_COMPILE_FLAGS})
      set(unit_policy_includes ${Legion_INCLUDE_DIRS} 
        ${MPI_${MPI_LANGUAGE}_INCLUDE_PATH})
      set(unit_policy_libraries ${Legion_LIBRARIES} ${Legion_LIB_FLAGS}
        ${MPI_${MPI_LANGUAGE}_LIBRARIES})
      set(unit_policy_exec ${MPIEXEC})
      set(unit_policy_exec_threads ${MPIEXEC_NUMPROC_FLAG}) 
      set(unit_policy_defines -DENABLE_MPI)

    elseif(Legion_FOUND AND unit_policy_main STREQUAL "LEGION")

      set(unit_policy_runtime ${CINCH_SOURCE_DIR}/auxiliary/test-legion.cc)
      set(unit_policy_flags ${Legion_CXX_FLAGS})
      set(unit_policy_includes ${Legion_INCLUDE_DIRS})
      set(unit_policy_libraries ${Legion_LIBRARIES} ${Legion_LIB_FLAGS})
  
    else()

      return()

    endif()

    # add the devel flag if requested
    if(_IS_DEVEL)
      list(APPEND unit_policy_defines -DCINCH_DEVEL_TEST) 
    endif()

    # if a custom runtime driver was provided, override it
    if (unit_DRIVER) 
        set( unit_policy_runtime ${unit_DRIVER} )
    endif()

    # copy the main driver for the runtime policy
    get_filename_component(_RUNTIME_MAIN ${unit_policy_runtime} NAME)
    set(_TARGET_MAIN ${name}_${_RUNTIME_MAIN})
    configure_file(${unit_policy_runtime}
      ${_OUTPUT_DIR}/${_TARGET_MAIN} COPYONLY)

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

    if(unit_policy_main STREQUAL "FORTRAN")
        set(_FORTRAN_SOURCES)
        set(_FORTRAN_SPECIALS)

        # Run pFUnit preprocessor on .pf files
        foreach(source ${unit_SOURCES})
            get_filename_component(_EXT ${source} EXT)
            get_filename_component(_PATH ${source} ABSOLUTE)

            if("${_EXT}" STREQUAL ".pf")
                get_filename_component(_BASE ${source} NAME_WE)
                add_custom_command(OUTPUT ${_OUTPUT_DIR}/${_BASE}.F90
                    COMMAND ${PYTHON_EXECUTABLE} ${PFUNIT_PARSER} ${_PATH}
                    ${_OUTPUT_DIR}/${_BASE}.F90
                    DEPENDS ${source}
                    COMMENT
                        "Generating ${_OUTPUT_DIR}/${_BASE}.F90 using pfunit")
                list(APPEND _FORTRAN_SOURCES ${_OUTPUT_DIR}/${_BASE}.F90)
            elseif("${_EXT}" STREQUAL ".inc")
                get_filename_component(_OUTPUT_NAME ${source} NAME)
                add_custom_command(OUTPUT ${_OUTPUT_DIR}/${_OUTPUT_NAME}
                    COMMAND ${CMAKE_COMMAND} -E copy ${_PATH}
                    ${_OUTPUT_DIR}/${_OUTPUT_NAME}
                    DEPENDS ${source}
                    COMMENT "Copying ${source} for ${name}")
                add_custom_target(${name}_inc_file DEPENDS
                    ${_OUTPUT_DIR}/${_OUTPUT_NAME})
                list(APPEND _FORTRAN_SPECIALS
                    ${name}_inc_file)
            else()
                list(APPEND _FORTRAN_SOURCES ${source})
            endif()
        endforeach()

        add_executable(${name} ${_FORTRAN_SOURCES} ${unit_policy_runtime})

        add_dependencies(${name} ${_FORTRAN_SPECIALS})

    else()
        add_executable(${name} ${unit_SOURCES} ${_OUTPUT_DIR}/${_TARGET_MAIN})
        target_link_libraries(${name} ${GTEST_LIBRARIES})
        target_include_directories(${name} PRIVATE ${GTEST_INCLUDE_DIRS})
        target_include_directories(${name} PRIVATE
            ${CINCH_SOURCE_DIR}/auxiliary)
    endif()

    target_include_directories(${name} PRIVATE ${_OUTPUT_DIR})
    set_target_properties(${name}
        PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${_OUTPUT_DIR})

    if(unit_policy_flags)
        target_compile_options(${name}
            PRIVATE ${unit_policy_flags})
    endif()

    #--------------------------------------------------------------------------#
    # Check for defines.
    #--------------------------------------------------------------------------#

    if(unit_policy_defines)
      target_compile_definitions(${name} PRIVATE ${unit_policy_defines})
    endif()

    if(unit_DEFINES)
      target_compile_definitions(${name} PRIVATE ${unit_DEFINES})
    endif()

    #--------------------------------------------------------------------------#
    # Check for input files. 
    #--------------------------------------------------------------------------#
    
    if(unit_INPUTS)
        set(_OUTPUT_FILES)
        foreach(input ${unit_INPUTS})
            get_filename_component(_OUTPUT_NAME ${input} NAME)
            get_filename_component(_PATH ${input} ABSOLUTE)
            add_custom_command(OUTPUT ${_OUTPUT_DIR}/${_OUTPUT_NAME}
                COMMAND ${CMAKE_COMMAND} -E copy 
                ${_PATH}
                ${_OUTPUT_DIR}/${_OUTPUT_NAME}
                DEPENDS ${input}
                COMMENT "Copying ${input} for ${name}")
            list(APPEND _OUTPUT_FILES ${_OUTPUT_DIR}/${_OUTPUT_NAME})
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

    if(unit_policy_libraries)
      target_link_libraries(${name} ${unit_policy_libraries})
    endif()

    if(unit_policy_includes)
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

    #--------------------------------------------------------------------------#
    # Add the test target to CTest
    #--------------------------------------------------------------------------#

    list(LENGTH unit_THREADS thread_instances)

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
                    ${_OUTPUT_DIR}/${name}_${instance}.xml)
                set(UNIT_FLAGS ${UNIT_FLAGS}
                    --gtest_output=xml:${_OUTPUT})
            endif()

            add_test(
                NAME
                    "${_TEST_PREFIX}${name}_${instance}"
                COMMAND
                    ${unit_policy_exec}
                    ${unit_policy_exec_threads} ${instance}
                    $<TARGET_FILE:${name}>
                    ${UNIT_FLAGS} 
                WORKING_DIRECTORY ${_OUTPUT_DIR})
        endforeach(instance)

    else()

        if(ENABLE_JENKINS_OUTPUT AND _IS_GTEST)
            set(_OUTPUT
                ${_OUTPUT_DIR}/${name}.xml)
            set(UNIT_FLAGS ${UNIT_FLAGS}
                --gtest_output=xml:${_OUTPUT})
        endif()

        if(unit_policy_exec)
            add_test(
                NAME
                    "${_TEST_PREFIX}${name}"
                COMMAND
                    ${unit_policy_exec}
                    ${unit_policy_exec_threads}
                    ${unit_THREADS}
                    $<TARGET_FILE:${name}>
                    ${UNIT_FLAGS}
                WORKING_DIRECTORY ${_OUTPUT_DIR})
        else()
            add_test(
                NAME
                    "${_TEST_PREFIX}${name}"
                COMMAND
                    $<TARGET_FILE:${name}>
                    ${UNIT_FLAGS}
                WORKING_DIRECTORY ${_OUTPUT_DIR})
        endif()

    endif(${thread_instances} GREATER 1)

    #--------------------------------------------------------------------------#
    # Link to librariest
    #--------------------------------------------------------------------------#

    if(unit_LIBRARIES)
      target_link_libraries(${name} ${unit_LIBRARIES})
    endif()

endfunction(cinch_add_unit)


#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
