#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_add_doxygen)

    #--------------------------------------------------------------------------#
    # Add option to enable doxygen
    #--------------------------------------------------------------------------#

    option(ENABLE_DOXYGEN "Enable Doxygen documentation" OFF)
    option(ENABLE_DOXYGEN_WARN "Enable Doxygen warnings" OFF)

    if(ENABLE_DOXYGEN)

        #----------------------------------------------------------------------#
        # Find Doxygen
        #----------------------------------------------------------------------#

        find_package(Doxygen REQUIRED)

        #----------------------------------------------------------------------#
        # Create the output directory if it doesn't exist. This is where
        # the documentation target will be written.
        #
        # NOTE: This differs depending on whether or not the project is
        # a top-level project or not.  Subprojects are put under their
        # respective project names.
        #----------------------------------------------------------------------#

        if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
           set(CINCH_CONFIG_INFOTAG)
        else()
            set(CINCH_CONFIG_INFOTAG "${PROJECT_NAME}.")
        endif()

        if(CINCH_CONFIG_INFOTAG)
            if(NOT EXISTS ${CMAKE_BINARY_DIR}/doc/${PROJECT_NAME})
                file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/doc/${PROJECT_NAME})
            endif(NOT EXISTS ${CMAKE_BINARY_DIR}/doc/${PROJECT_NAME})

            set(_directory ${CMAKE_BINARY_DIR}/doc/${PROJECT_NAME})

            #------------------------------------------------------------------#
            # This variable is used in the doxygen configuration file.  It
            # will be used in the configure_file call below.
            #------------------------------------------------------------------#

            set(${PROJECT_NAME}_DOXYGEN_TARGET ${PROJECT_NAME}/doxygen)

            #------------------------------------------------------------------#
            # Install under the main project name in its own directory
            #------------------------------------------------------------------#

            set(_install ${CMAKE_PROJECT_NAME}/${PROJECT_NAME})

            #------------------------------------------------------------------#
            # Add dependency for sub doxygen targets
            #------------------------------------------------------------------#
            
            if ( TARGET doxygen )
                add_dependencies(doxygen ${CINCH_CONFIG_INFOTAG}doxygen)
            endif()

            if ( TARGET install-doxygen )
                add_dependencies(install-doxygen
                    ${CINCH_CONFIG_INFOTAG}install-doxygen)
            endif()

        else()

            #------------------------------------------------------------------#
            # Output target is in 'doc'
            #------------------------------------------------------------------#

            set(_directory ${CMAKE_BINARY_DIR}/doc)

            #------------------------------------------------------------------#
            # This variable is used in the doxygen configuration file.  It
            # will be used in the configure_file call below.
            #------------------------------------------------------------------#

            set(${PROJECT_NAME}_DOXYGEN_TARGET doxygen)

            #------------------------------------------------------------------#
            # Install in its own directory
            #------------------------------------------------------------------#

            set(_install ${CMAKE_PROJECT_NAME})
        endif(CINCH_CONFIG_INFOTAG)

        #----------------------------------------------------------------------#
        # Create directory for intermediate files
        #----------------------------------------------------------------------#

        if(NOT EXISTS ${_directory}/.doxygen)
            file(MAKE_DIRECTORY ${_directory}/.doxygen)
        endif(NOT EXISTS ${_directory}/.doxygen)

        #----------------------------------------------------------------------#
        # Generate doxygen configuration file
        #----------------------------------------------------------------------#

        if(ENABLE_DOXYGEN_WARN)
            set(DOXYGEN_WARN YES)
        else()
            set(DOXYGEN_WARN NO)
        endif(ENABLE_DOXYGEN_WARN)

        configure_file(${CMAKE_CURRENT_SOURCE_DIR}/doc/doxygen.conf.in
            ${_directory}/.doxygen/doxygen.conf)

        #----------------------------------------------------------------------#
        # Add the doxygen target
        #----------------------------------------------------------------------#

        add_custom_target(${CINCH_CONFIG_INFOTAG}doxygen
            ${DOXYGEN} ${_directory}/.doxygen/doxygen.conf
            DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/doc/doxygen.conf.in)

        #----------------------------------------------------------------------#
        # Add install target
        #----------------------------------------------------------------------#

        add_custom_target(${CINCH_CONFIG_INFOTAG}install-doxygen
            COMMAND ${CMAKE_COMMAND} -E copy_directory ${_directory}/doxygen
                $ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/share/${_install})

    endif(ENABLE_DOXYGEN)

endfunction(cinch_add_doxygen)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
