# - Find ParMetis
# Find the local installation of ParMetis
#
# ParMetis_INCLUDE_DIRS - where to find parmetis.h
# ParMetis_LIBRARIES - where to find libParMetis
# ParMetis_FOUND - True if ParMetis found

#TODO: If needed, check for the version

#Thanks to LANL EAP for initial version of FindPackage

# Look for the header file
FIND_PATH(ParMetis_INCLUDE_DIR NAMES parmetis.h)

# Look for the library
FIND_LIBRARY(ParMetis_LIBRARY NAMES parmetis)

# handle the QUIETLY and REQUIRED arguments and set ParMetis_FOUND to TRUE if
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(ParMetis DEFAULT_MSG ParMetis_LIBRARY ParMetis_INCLUDE_DIR)

# Copy the results to the output variables.
IF(ParMetis_FOUND)
	SET(ParMetis_LIBRARIES ${ParMetis_LIBRARY})
	SET(PARMETIS_LIBRARIES ${ParMetis_LIBRARY})
	SET(ParMetis_INCLUDE_DIRS ${ParMetis_INCLUDE_DIR})
	SET(PARMETIS_INCLUDE_DIRS ${ParMetis_INCLUDE_DIR})
	SET(PARMETIS_FOUND ${ParMetis_FOUND})
ELSE()
	SET(ParMetis_LIBRARIES)
	SET(PARMETIS_LIBRARIES)
	SET(ParMetis_INCLUDE_DIRS)
	SET(PARMETIS_INCLUDE_DIRS)
ENDIF()

MARK_AS_ADVANCED(ParMetis_INCLUDE_DIR ParMetis_LIBRARY)

if(ParMetis_INCLUDE_DIR AND ParMetis_LIBRARY)
	if(NOT TARGET ParMetis::ParMetis)
		add_library(ParMetis::ParMetis UNKNOWN IMPORTED)
		set_target_properties(ParMetis::ParMetis PROPERTIES
			IMPORTED_LOCATION "${ParMetis_LIBRARY}"
			INTERFACE_INCLUDE_DIRECTORIES "${ParMetis_INCLUDE_DIR}")
	endif()
endif()
