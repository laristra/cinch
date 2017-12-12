#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#--------------------------------------------------------------------------#
# Check the test policy. The default is SERIAL.
#--------------------------------------------------------------------------#

    if(NOT test_POLICY OR test_POLICY STREQUAL "SERIAL") 

        set(test_policy_runtime ${CINCH_SOURCE_DIR}/auxiliary/test-standard.cc)
        set(test_policy_defines -DSERIAL)

    elseif(MPI_${MPI_LANGUAGE}_FOUND AND test_POLICY STREQUAL "MPI")

        set(test_policy_runtime ${CINCH_SOURCE_DIR}/auxiliary/test-mpi.cc)
        set(test_policy_flags ${MPI_${MPI_LANGUAGE}_COMPILE_FLAGS})
        set(test_policy_includes ${MPI_${MPI_LANGUAGE}_INCLUDE_PATH})
        set(test_policy_libraries ${MPI_${MPI_LANGUAGE}_LIBRARIES})
        set(test_policy_exec ${MPIEXEC})
        set(test_policy_exec_threads ${MPIEXEC_NUMPROC_FLAG})        

    elseif(MPI_${MPI_LANGUAGE}_FOUND AND Legion_FOUND AND
        test_POLICY STREQUAL "LEGION")

        set(test_policy_runtime ${CINCH_SOURCE_DIR}/auxiliary/test-legion.cc)
        set(test_policy_flags ${Legion_CXX_FLAGS}
            ${MPI_${MPI_LANGUAGE}_COMPILE_FLAGS})
        set(test_policy_includes ${Legion_INCLUDE_DIRS}
            ${MPI_${MPI_LANGUAGE}_INCLUDE_PATH})
        set(test_policy_libraries ${Legion_LIBRARIES} ${Legion_LIB_FLAGS}
            ${MPI_${MPI_LANGUAGE}_LIBRARIES})
        set(test_policy_exec ${MPIEXEC})
        set(test_policy_exec_threads ${MPIEXEC_NUMPROC_FLAG})
        set(test_policy_defines -DCINCH_ENABLE_MPI)

    else()

        return()

    endif()

    #--------------------------------------------------------------------------#
    # copy the main driver for the runtime policy
    #--------------------------------------------------------------------------#

    get_filename_component(_RUNTIME_MAIN ${test_policy_runtime} NAME)
    set(_TARGET_MAIN ${name}_${_RUNTIME_MAIN})
    configure_file(${test_policy_runtime}
      ${_OUTPUT_DIR}/${_TARGET_MAIN} COPYONLY)

    #--------------------------------------------------------------------------#
    # Make sure that the user specified sources.
    #--------------------------------------------------------------------------#

    if(NOT test_SOURCES)
        message(FATAL_ERROR
            "You must specify test source files using SOURCES")
    endif(NOT test_SOURCES)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
