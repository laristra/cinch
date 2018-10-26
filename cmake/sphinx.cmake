#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_add_sphinx)

    #--------------------------------------------------------------------------#
    # Add option to enable Sphinx
    #--------------------------------------------------------------------------#

    option(ENABLE_SPHINX "Enable Sphinx documentation" OFF)

    if(ENABLE_SPHINX)

        #----------------------------------------------------------------------#
        # Find Sphinx
        #----------------------------------------------------------------------#

        find_package(Sphinx REQUIRED)

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
            # This variable is used in the Sphinx configuration file.  It
            # will be used in the configure_file call below.
            #------------------------------------------------------------------#

            set(${PROJECT_NAME}_SPHINX_TARGET ${PROJECT_NAME}/sphinx)

            #------------------------------------------------------------------#
            # Install under the main project name in its own directory
            #------------------------------------------------------------------#

            set(_install ${CMAKE_PROJECT_NAME}/${PROJECT_NAME})

            #------------------------------------------------------------------#
            # Add dependency for sub Sphinx targets
            #------------------------------------------------------------------#

            if(TARGET sphinx)
                add_dependencies(sphinx ${CINCH_CONFIG_INFOTAG}sphinx)
            endif()

            if(TARGET install-sphinx)
                add_dependencies(install-sphinx
                    ${CINCH_CONFIG_INFOTAG}install-sphinx)
            endif()

        else()

            #------------------------------------------------------------------#
            # Output target is in 'doc'
            #------------------------------------------------------------------#

            set(_directory ${CMAKE_BINARY_DIR}/doc)

            #------------------------------------------------------------------#
            # This variable is used in the Sphinx configuration file.  It
            # will be used in the configure_file call below.
            #------------------------------------------------------------------#

            set(${PROJECT_NAME}_SPHINX_TARGET sphinx)

            #------------------------------------------------------------------#
            # Install in its own directory
            #------------------------------------------------------------------#

            set(_install ${CMAKE_PROJECT_NAME})

        endif()

        #----------------------------------------------------------------------#
        # Create directory for intermediate files
        #----------------------------------------------------------------------#

        if(NOT EXISTS ${_directory}/.sphinx)
            file(MAKE_DIRECTORY ${_directory}/.sphinx)
        endif(NOT EXISTS ${_directory}/.sphinx)

        #----------------------------------------------------------------------#
        # Generate the Sphinx config file
        #----------------------------------------------------------------------#

        configure_file(${CMAKE_CURRENT_SOURCE_DIR}/sphinx/conf.py.in
            ${_directory}/.sphinx/conf.py)

        #----------------------------------------------------------------------#
        # Add the Sphinx target
        #----------------------------------------------------------------------#

        #        add_custom_target(${CINCH_CONFIG_INFOTAG}sphinx
        #    ${SPHINX_EXECUTABLE}
        #    WORKING_DIRECTORY ${_directory}/.sphinx
        #    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/sphinx/config.py.in)

        #----------------------------------------------------------------------#
        # Add install target
        #----------------------------------------------------------------------#

        #        add_custom_target(${CINCH_CONFIG_INFOTAG}install-sphinx
        #    COMMAND ${CMAKE_COMMAND} -E copy_directory ${_directory}/sphinx
        #        $ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/share/${_install})

    endif(ENABLE_SPHINX)

endfunction(cinch_add_sphinx)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
