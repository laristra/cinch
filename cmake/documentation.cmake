#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_add_doc target config directory output)

    find_package(NGC)
    find_package(Pandoc)

	if(NOT EXISTS ${CMAKE_BINARY_DIR}/doc)
        file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/doc)
	endif(NOT EXISTS ${CMAKE_BINARY_DIR}/doc)

    file(GLOB_RECURSE _DOCFILES ${directory} *.md)

	add_custom_target(${target}_markdown
		${NGC} doc -c ${config} -o ${CMAKE_BINARY_DIR}/doc/${target}.md
			${directory}
		DEPENDS ${_DOCFILES})
	add_custom_target(${target} ALL
		${PANDOC} ${CMAKE_BINARY_DIR}/doc/${target}.md
			-o ${CMAKE_BINARY_DIR}/doc/${output})
	add_dependencies(${target} ${target}_markdown)

endfunction(cinch_add_doc)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
