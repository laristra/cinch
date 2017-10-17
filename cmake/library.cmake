#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

include(subdirlist)

#
# cinch_add_library
#

function(cinch_add_library_target target directory)

    #--------------------------------------------------------------------------#
    # Add target to list
    #--------------------------------------------------------------------------#

    message(STATUS
        "Adding library target ${target} with source directory ${directory}")

    #--------------------------------------------------------------------------#
    # Add public headers
    #--------------------------------------------------------------------------#

    set( _SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${directory} )

    if(EXISTS ${_SOURCE_DIR}/library.cmake)
        include(${_SOURCE_DIR}/library.cmake)
    endif()

    #--------------------------------------------------------------------------#
    # add some random includes for convinience
    #--------------------------------------------------------------------------#

    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/${directory})
    include_directories(${CMAKE_CURRENT_BINARY_DIR}/${directory})

    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/${directory}/..)
    include_directories(${CMAKE_CURRENT_BINARY_DIR}/${directory}/..)

    #--------------------------------------------------------------------------#
    # Add subdirectories
    #
    # This uses a glob, i.e., all sub-directories will be added at this level.
    # This is not true for levels below this one.  This allows some flexibility
    # while keeping the generic case as simple as possible.
    #
    # First, we attempt to divine whether this is a flat project, or
    # a nested project. If _SUBDIRECTORIES comes back defined, but there
    # is only one subdirectory and it is named "test", then we treat as a flat
    # project. Otherwise we treat it as a nested project.
    #--------------------------------------------------------------------------#

    cinch_subdirlist(_SUBDIRECTORIES ${_SOURCE_DIR} False)

    set(flatSubdirSet "test")

    if((_SUBDIRECTORIES) AND NOT "${_SUBDIRECTORIES}" STREQUAL ${flatSubdirSet})

        message(STATUS "Processing nested library project")

        #----------------------------------------------------------------------#
        # Add subdirectories
        #
        # This uses a glob, i.e., all sub-directories will be added at
        # this level. This is not true for levels below this one. This
        # allows some flexibility while keeping the generic case as simple
        # as possible.
        #----------------------------------------------------------------------#

        #----------------------------------------------------------------------#
        # Add subdirectory files
        #----------------------------------------------------------------------#

        # This loop adds header and source files for each listed sub-directory
        # to the main header and source file lists.  Additionally, it adds the
        # listed sub-directories to the include search path.  Lastly, it creates
        # a catalog for each sub-directory with information on the source and
        # headers files from the directory using the 'info.cmake' script that is
        # located in the top-level 'cmake' directory.

        foreach(_SUBDIR ${_SUBDIRECTORIES})

            if(NOT EXISTS ${_SOURCE_DIR}/${_SUBDIR}/CMakeLists.txt)
               continue()
            endif()

            message(STATUS
                "Adding source subdirectory '${_SUBDIR}' to ${target}")

            unset(${_SUBDIR}_HEADERS)
            unset(${_SUBDIR}_SOURCES)

            add_subdirectory(${directory}/${_SUBDIR})

            foreach(_HEADER ${${_SUBDIR}_HEADERS})
                if(NOT EXISTS ${_SOURCE_DIR}/${_SUBDIR}/${_HEADER})
                    message(FATAL_ERROR "Header '${_HEADER}' from ${_SUBDIR}_HEADERS does not exist.")
                endif()
                list(APPEND HEADERS
                    ${_SUBDIR}/${_HEADER})
            endforeach()

            foreach(_SOURCE ${${_SUBDIR}_SOURCES})
                list(APPEND SOURCES
                    ${_SOURCE_DIR}/${_SUBDIR}/${_SOURCE})
            endforeach()

        endforeach(_SUBDIR)

        add_library(${target} ${SOURCES})

    else()

        message(STATUS "Processing flat library project")

        add_subdirectory(${directory})

        # add headers
        foreach(_HEADER ${${directory}_HEADERS})
            if(NOT EXISTS ${_SOURCE_DIR}/${_HEADER})
                message(FATAL_ERROR
                    "header '${_HEADER}' from ${directory}_HEADERS does not exist.")
            endif()
            list(APPEND HEADERS ${_HEADER})
        endforeach()

        # add sources
        foreach(_SOURCE ${${directory}_SOURCES})

            if(NOT EXISTS ${_SOURCE_DIR}/${_SOURCE})
                message(FATAL_ERROR
                    "Source '${_SOURCE}' from ${directory}_SOURCES does not exist.")
            endif()

            # Identify flecsi language soruce files and add the appropriate
            # language and compiler flags to properties.

            get_filename_component(_EXT ${_SOURCE} EXT)

            if("${_EXT}" STREQUAL ".fcc")
                set_source_files_properties(${_SOURCE}
                    PROPERTIES LANGUAGE CXX
                )
            endif()

            list(APPEND SOURCES ${directory}/${_SOURCE})
        endforeach()

        add_library(${target} ${SOURCES})
    endif()


    foreach(file ${HEADERS})
        get_filename_component(DIR ${file} DIRECTORY)
        install(FILES ${directory}/${file} DESTINATION include/${target}/${DIR})
    endforeach()

    install( TARGETS ${target} DESTINATION ${LIBDIR} )

    foreach(file ${${target}_PUBLIC_HEADERS})
        install(FILES ${directory}/${file} DESTINATION include/${target})
    endforeach()

endfunction(cinch_add_library_target)

#
# Link libraries to a target
#

function(cinch_target_link_libraries target)

    if (NOT ARGN)
        message(
            FATAL_ERROR
            "The list of libaries provided to link to target '${target}' is "
            "empty"
        )
    endif()

    message(STATUS
      "Linking target ${target} with libraries ${ARGN}")

    target_link_libraries( ${target} ${ARGN} )

endfunction()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
