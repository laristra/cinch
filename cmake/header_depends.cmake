#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(header_depends header)

	message(STATUS "Checking header dependencies for ${header}")

	# FIXME
	# Add compilers as needed (I realize that this sucks). Perhaps CMake
	# will fix their broken dependency analysis someday...
	if(NOT CMAKE_COMPILER_IS_GNUCXX AND
		NOT CMAKE_CXX_COMPILER_ID STREQUAL "Intel" AND
		NOT CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
		message(WARNING "${CMAKE_CXX_COMPILER} may not support -MM!!!")
	endif()

	# Get the compiler defines and includes
	get_directory_property(_defines DIRECTORY ${CMAKE_SOURCE_DIR}
  		COMPILE_DEFINITIONS)
	get_directory_property(_includes DIRECTORY ${CMAKE_SOURCE_DIR}
  		INCLUDE_DIRECTORIES)

	# Create list of compiler definitions for command
	list(REMOVE_DUPLICATES _defines)
	set(_COMPILE_DEFINES)
	foreach(def ${_defines})
	  set(_COMPILE_DEFINES ${_COMPILE_DEFINES} -D${def})
	endforeach()

	# Create list of include directories for command
	list(REMOVE_DUPLICATES _includes)
	set(_INCLUDE_DIRECTORIES)
	foreach(inc ${_includes})
	  set(_INCLUDE_DIRECTORIES ${_INCLUDE_DIRECTORIES} -I${inc})
	endforeach()

	# Strip any spaces from the flags
	string(STRIP ${CMAKE_CXX_FLAGS} _CXX_FLAGS)

	# Create an argument list for the command. Note that this
	# must be a valid CMake list.
	set(_ARGS ${_CXX_FLAGS} -MM ${_COMPILE_DEFINES}
		${_INCLUDE_DIRECTORIES} ${header}
	)

	# Execute the compiler with -MM option to get the
	# dependency inforamtion for the given header file.
	execute_process(COMMAND ${CMAKE_CXX_COMPILER} ${_ARGS}
		OUTPUT_VARIABLE _DEPENDENCIES
		OUTPUT_STRIP_TRAILING_WHITESPACE
	)

	# Create a list from the output and pop the redundant
	# given header output.
	string(REPLACE " " ";" _DEP_LIST ${_DEPENDENCIES})
	list(REMOVE_AT _DEP_LIST 0)

	# Set a return variable at the calling scope.
	set(HEADER_DEPENDENCIES ${_DEP_LIST} PARENT_SCOPE)

endfunction()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
