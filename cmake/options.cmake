#------------------------------------------------------------------------------#
# Copyright (c) 2017 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

if (NOT CINCH_PACKAGES_INCLUDED)

    set( CINCH_PACKAGES_INCLUDED True )

    #--------------------------------------------------------------------------#
    # Global options 
    #--------------------------------------------------------------------------#

    option(ENABLE_COVERAGE_BUILD "Do a coverage build" OFF)
    if(ENABLE_COVERAGE_BUILD)
        message(STATUS "Enabling coverage build")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --coverage -O0")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage -O0")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --coverage")
        set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} --coverage")
    endif()
    option(BUILD_SHARED_LIBS "Build shared libs" ON)
    if (NOT DEFINED LIBDIR)
        include(GNUInstallDirs)
        set(LIBDIR "${CMAKE_INSTALL_LIBDIR}")
    endif(NOT DEFINED LIBDIR)

    #--------------------------------------------------------------------------#
    # Add support for Boost preprocessor.
    #--------------------------------------------------------------------------#

    option(ENABLE_BOOST_PREPROCESSOR "Enable Boost.Preprocessor subset" OFF)

    if(ENABLE_BOOST_PREPROCESSOR)
        include_directories(${CINCH_SOURCE_DIR}/boost/preprocessor/include)
    endif()

    #--------------------------------------------------------------------------#
    # Add support for GFlags
    #--------------------------------------------------------------------------#

    option(ENABLE_GFLAGS "Enable command-line flag support" OFF)

    if(ENABLE_GFLAGS)
        find_package(GFlags)

        if(GFlags_FOUND)
            # We found a system or local installation
            include_directories(${GFlags_INCLUDE_DIRS})
        else()
            # Build it ourselves
            add_subdirectory(${CINCH_SOURCE_DIR}/gflags
                ${CMAKE_BINARY_DIR}/cinch/gflags)
            include_directories(${CMAKE_BINARY_DIR}/cinch/gflags/include)
            set(GFLAGS_LIBRARIES gflags)
        endif()

        # Add this to the compile definitions
        add_definitions(-DENABLE_GFLAGS)
    endif()

    #--------------------------------------------------------------------------#
    # Add clog logging
    #--------------------------------------------------------------------------#

    include_directories(${CINCH_SOURCE_DIR}/logging)

    # Add an option to set the strip level
    set(CLOG_STRIP_LEVEL "0" CACHE STRING "Set the clog strip level")
    add_definitions(-DCLOG_STRIP_LEVEL=${CLOG_STRIP_LEVEL})

    # Allow color output
    option(CLOG_COLOR_OUTPUT "Enable colorized clog logging" ON)
    if(CLOG_COLOR_OUTPUT)
        add_definitions(-DCLOG_COLOR_OUTPUT)
    endif()

    # Enable tag groups
    option(CLOG_ENABLE_TAGS "Enable tag groups" OFF)
    if(CLOG_ENABLE_TAGS)
        set(CLOG_TAG_BITS "16" CACHE STRING
            "Select the number of bits to use for tag groups.")
        add_definitions(-DCLOG_ENABLE_TAGS)
        add_definitions(-DCLOG_TAG_BITS=${CLOG_TAG_BITS})
    endif()

    # Externally scoped messages
    option(CLOG_ENABLE_EXTERNAL
        "Enable messages that are defined at external scope" OFF)
    if(CLOG_ENABLE_EXTERNAL)
        add_definitions(-DCLOG_ENABLE_EXTERNAL)
    endif()

    # MPI
    if(MPI_${MPI_LANGUAGE}_FOUND)
        option(CLOG_ENABLE_MPI "Enable clog MPI functions" OFF)
        if(CLOG_ENABLE_MPI)
            add_definitions(-DCLOG_ENABLE_MPI)
        endif()
    endif()

    # Enable debugging
    option(CLOG_DEBUG "Enable clog debugging" ON)
    if(CLOG_DEBUG)
        add_definitions(-DCLOG_DEBUG)
    endif()

    #--------------------------------------------------------------------------#
    # Add support for ctest, GTest, and pFUnit
    #--------------------------------------------------------------------------#

    option(ENABLE_UNIT_TESTS "Enable unit testing" OFF)
    option(ENABLE_COLOR_UNIT_TESTS "Enable colorized unit testing output" OFF)
    option(ENABLE_JENKINS_OUTPUT
        "Generate jenkins xml output for every test" OFF)

    if(ENABLE_UNIT_TESTS)

        enable_testing()

        #----------------------------------------------------------------------#
        # Google Test
        #----------------------------------------------------------------------#

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
          include_directories(${CINCH_SOURCE_DIR}/gtest/googlemock/include)
          include_directories(${CINCH_SOURCE_DIR}/gtest/googletest)
          include_directories(${CINCH_SOURCE_DIR}/gtest/googletest/include)
          set(GTEST_LIBRARIES gtest)
        endif()

        include_directories(${CINCH_SOURCE_DIR}/auxiliary)

        #----------------------------------------------------------------------#
        # pFUnit
        #----------------------------------------------------------------------#

        get_property(LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)

        list(FIND LANGUAGES "Fortran" FORTRAN_ENABLED)

        if(FORTRAN_ENABLED EQUAL -1)
            set(FORTRAN_ENABLED FALSE)
        endif(FORTRAN_ENABLED EQUAL -1)

        if(FORTRAN_ENABLED)
            find_package(PythonInterp QUIET)
            find_package(pFUnit QUIET)

            if(PFUNIT_FOUND)
                include_directories(${PFUNIT_INCLUDE_DIR})
            else()
                include(${CINCH_SOURCE_DIR}/cmake/PFUnitLists.txt)
            endif()
        endif()

        #----------------------------------------------------------------------#
        # Add default execution polices
        #----------------------------------------------------------------------#

        cinch_add_test_execution_policy(SERIAL
            ${CINCH_SOURCE_DIR}/auxiliary/test-standard.cc
            DEFINES "-DSERIAL"
        )

        cinch_add_test_execution_policy(SERIAL_DEVEL
            ${CINCH_SOURCE_DIR}/auxiliary/test-standard.cc
            DEFINES "-DCINCH_DEVEL_TEST -DSERIAL"
        )

        if(FORTRAN_ENABLED)
            cinch_add_test_execution_policy(FORTRAN
                ${PFUNIT_DRIVER}
                LIBRARIES ${PFUNIT_LIBRARY})
        endif(FORTRAN_ENABLED)

        # Need to collect extra runtime libraries into a standard variable
        # that users can add to their unit test defines if needed.
        set(CINCH_RUNTIME_INCLUDES)
        set(CINCH_RUNTIME_FLAGS)
        set(CINCH_RUNTIME_LIBRARIES)

        # MPI Runtime
        if(MPI_${MPI_LANGUAGE}_FOUND)
            cinch_add_test_execution_policy(MPI
                ${CINCH_SOURCE_DIR}/auxiliary/test-mpi.cc
                FLAGS ${MPI_${MPI_LANGUAGE}_COMPILE_FLAGS}
                INCLUDES ${MPI_${MPI_LANGUAGE}_INCLUDE_PATH}
                LIBRARIES ${MPI_${MPI_LANGUAGE}_LIBRARIES}
                EXEC ${MPIEXEC}
                EXEC_THREADS ${MPIEXEC_NUMPROC_FLAG}
            )

            cinch_add_test_execution_policy(MPI_DEVEL
                ${CINCH_SOURCE_DIR}/auxiliary/test-mpi.cc
                FLAGS ${MPI_${MPI_LANGUAGE}_COMPILE_FLAGS}
                INCLUDES ${MPI_${MPI_LANGUAGE}_INCLUDE_PATH}
                DEFINES "-DCINCH_DEVEL_TEST"
                LIBRARIES ${MPI_${MPI_LANGUAGE}_LIBRARIES}
                EXEC ${MPIEXEC}
                EXEC_THREADS ${MPIEXEC_NUMPROC_FLAG}
            )

            set(CINCH_RUNTIME_FLAGS ${CINCH_RUNTIME_FLAGS}
                ${MPI_${MPI_LANGUAGE}_COMPILE_FLAGS}
            )
            set(CINCH_RUNTIME_INCLUDES ${CINCH_RUNTIME_INCLUDES}
                ${MPI_${MPI_LANGUAGE}_INCLUDE_PATH}
            )
            set(CINCH_RUNTIME_LIBRARIES ${CINCH_RUNTIME_LIBRARIES}
                ${MPI_${MPI_LANGUAGE}_LIBRARIES}
            )
        endif()

        # Legion Runtime
        if(MPI_${MPI_LANGUAGE}_FOUND AND Legion_FOUND)
            add_definitions(-DLEGION_CMAKE)
            cinch_add_test_execution_policy(LEGION
                ${CINCH_SOURCE_DIR}/auxiliary/test-legion.cc
                FLAGS ${Legion_CXX_FLAGS}
                    ${MPI_${MPI_LANGUAGE}_COMPILE_FLAGS}
                INCLUDES ${Legion_INCLUDE_DIRS}
                    ${MPI_${MPI_LANGUAGE}_INCLUDE_PATH}
                LIBRARIES ${Legion_LIBRARIES} ${Legion_LIB_FLAGS}
                    ${MPI_${MPI_LANGUAGE}_LIBRARIES}
                EXEC ${MPIEXEC}
                EXEC_THREADS ${MPIEXEC_NUMPROC_FLAG}) 

            cinch_add_test_execution_policy(LEGION_DEVEL
                ${CMAKE_SOURCE_DIR}/cinch/auxiliary/test-legion.cc
                FLAGS ${Legion_CXX_FLAGS}
                    ${MPI_${MPI_LANGUAGE}_COMPILE_FLAGS}
                INCLUDES ${Legion_INCLUDE_DIRS}
                    ${MPI_${MPI_LANGUAGE}_INCLUDE_PATH}
                DEFINES "-DCINCH_DEVEL_TEST"
                LIBRARIES ${Legion_LIBRARIES} ${Legion_LIB_FLAGS}
                    ${MPI_${MPI_LANGUAGE}_LIBRARIES}
                EXEC ${MPIEXEC}
                EXEC_THREADS ${MPIEXEC_NUMPROC_FLAG})

            set(CINCH_RUNTIME_FLAGS ${CINCH_RUNTIME_FLAGS}
                ${MPI_${MPI_LANGUAGE}_COMPILE_FLAGS} ${Legion_CXX_FLAGS}
            )
            set(CINCH_RUNTIME_INCLUDES ${CINCH_RUNTIME_INCLUDES}
                ${MPI_${MPI_LANGUAGE}_INCLUDE_PATH} ${Legion_INCLUDE_DIRS}
            )
            set(CINCH_RUNTIME_LIBRARIES ${CINCH_RUNTIME_LIBRARIES}
                ${MPI_${MPI_LANGUAGE}_LIBRARIES} 
                ${Legion_LIBRARIES} ${Legion_LIB_FLAGS}
            )

        elseif(Legion_FOUND)
            add_definitions(-DLEGION_CMAKE)
            cinch_add_test_execution_policy(LEGION
               ${CINCH_SOURCE_DIR}/auxiliary/test-legion.cc
               FLAGS ${Legion_CXX_FLAGS}
               INCLUDES ${Legion_INCLUDE_DIRS}
               LIBRARIES ${Legion_LIBRARIES} ${Legion_LIB_FLAGS})

            cinch_add_test_execution_policy(LEGION_DEVEL
               ${CMAKE_SOURCE_DIR}/cinch/auxiliary/test-legion.cc
               FLAGS ${Legion_CXX_FLAGS}
               DEFINES "-DCINCH_DEVEL_TEST"
               INCLUDES ${Legion_INCLUDE_DIRS}
               LIBRARIES ${Legion_LIBRARIES} ${Legion_LIB_FLAGS})

            set(CINCH_RUNTIME_FLAGS ${CINCH_RUNTIME_FLAGS} ${Legion_CXX_FLAGS})
            set(CINCH_RUNTIME_INCLUDES ${CINCH_RUNTIME_INCLUDES}
                ${Legion_INCLUDE_DIRS})
            set(CINCH_RUNTIME_LIBRARIES ${CINCH_RUNTIME_LIBRARIES}
                ${Legion_LIBRARIES} ${Legion_LIB_FLAGS}
            )

        endif()

    endif(ENABLE_UNIT_TESTS)

endif () # CINCH_PACKAGES_INCLUDED


#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 filetype=cmake expandtab :
#------------------------------------------------------------------------------#
