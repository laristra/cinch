#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_add_doc target config directory output)

    #--------------------------------------------------------------------------#
    # Find the NGC command-line tool
    #--------------------------------------------------------------------------#

    find_package(NGC)

    if(NOT NGC_FOUND)
        message(FATAL_ERROR
            "The NGC command-line tool is needed to enable this option")
    endif(NOT NGC_FOUND)

    #--------------------------------------------------------------------------#
    # Find pandoc
    #--------------------------------------------------------------------------#

    find_package(Pandoc)

    if(NOT NGC_FOUND)
        message(FATAL_ERROR
            "Pandoc is needed to enable this option")
    endif(NOT NGC_FOUND)

    #--------------------------------------------------------------------------#
    # Create the target directory if it doesn't exist.  This is where the
    # documentation intermediate files and target will be written.
    #--------------------------------------------------------------------------#

	if(NOT EXISTS ${CMAKE_BINARY_DIR}/doc)
        file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/doc)
	endif(NOT EXISTS ${CMAKE_BINARY_DIR}/doc)

    #--------------------------------------------------------------------------#
    # Glob files in search directory to add as dependency information
    # for the target.
    #--------------------------------------------------------------------------#

    file(GLOB_RECURSE _DOCFILES ${directory} *.md)

    #--------------------------------------------------------------------------#
    # Add a target to generate the aggregate markdown file for the
    # document.
    #--------------------------------------------------------------------------#

	add_custom_target(${target}_markdown
		${NGC} doc -c ${config} -o ${CMAKE_BINARY_DIR}/doc/${target}.md
			${directory}
		DEPENDS ${_DOCFILES})

    #--------------------------------------------------------------------------#
    # Add the output target to be created by calling pandoc on the
    # aggregate markdown file created in the previous step.
    #--------------------------------------------------------------------------#

	add_custom_target(${target} ALL
		${PANDOC} ${CMAKE_BINARY_DIR}/doc/${target}.md
			-o ${CMAKE_BINARY_DIR}/doc/${output})

    #--------------------------------------------------------------------------#
    # Make the target depend on the aggregate markdown file
    #--------------------------------------------------------------------------#

	add_dependencies(${target} ${target}_markdown)

endfunction(cinch_add_doc)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
