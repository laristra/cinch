#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_add_doxygen)

    #--------------------------------------------------------------------------#
    # Add option to enable doxygen
    #--------------------------------------------------------------------------#

    option(ENABLE_DOXYGEN "Enable Doxygen documentation" OFF)

    if(ENABLE_DOXYGEN)

        #----------------------------------------------------------------------#
        # Find Doxygen
        #----------------------------------------------------------------------#

        find_package(Doxygen)

        if(NOT DOXYGEN_FOUND)
            message(FATAL_ERROR "Doxygen is required to enable this option")
        endif(NOT DOXYGEN_FOUND)

        #----------------------------------------------------------------------#
        # Create the output directory if it doesn't exist. This is where
        # the documentation target and intermediate files will be written.
        #
        # NOTE: This differs depending on whether or not the project is
        # a top-level project or not.  Subprojects are put under their
        # respective project names.
        #----------------------------------------------------------------------#

        if(CINCH_CONFIG_INFOTAG)
            if(NOT EXISTS ${CMAKE_BINARY_DIR}/doc/${PROJECT_NAME})
                file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/doc/${PROJECT_NAME})
            endif(NOT EXISTS ${CMAKE_BINARY_DIR}/doc/${PROJECT_NAME})

            set(_directory ${CMAKE_BINARY_DIR}/doc/${PROJECT_NAME})

            #------------------------------------------------------------------#
            # This variable is used in the doxygen configuration file.  It
            # will be used in the configure_file call below.
            #------------------------------------------------------------------#

            set(${PROJECT_NAME}_DOXYGEN_TARGET ${PROJECT_NAME})

        else()
            set(_directory ${CMAKE_BINARY_DIR}/doc)
            set(${PROJECT_NAME}_DOXYGEN_TARGET)
        endif(CINCH_CONFIG_INFOTAG)


        #----------------------------------------------------------------------#
        #----------------------------------------------------------------------#

        configure_file(${CMAKE_CURRENT_SOURCE_DIR}/doc/doxygen.conf.in
            ${_directory}/doxygen.conf)

        #----------------------------------------------------------------------#
        #----------------------------------------------------------------------#

        add_custom_target(${CINCH_CONFIG_INFOTAG}doxygen ALL
            ${DOXYGEN} ${_directory}/doxygen.conf
            DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/doc/doxygen.conf.in)

    endif(ENABLE_DOXYGEN)

endfunction(cinch_add_doxygen)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
