#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# - Find scotch
# Find the native SCOTCH headers and libraries.
#
#  SCOTCH_INCLUDE_DIRS - where to find scotch.h, etc.
#  SCOTCH_LIBRARIES    - List of libraries when using scotch.
#  SCOTCH_FOUND        - True if scotch found.

#=============================================================
# _SCOTCH_GET_VERSION
# Internal function to parse the version number in scotch.h
#   _OUT_major = Major version number
#   _OUT_minor = Minor version number
#   _OUT_micro = Micro version number
#   _scotchversion_hdr = Header file to parse
#=============================================================
function(_SCOTCH_GET_VERSION _OUT_major _OUT_minor _OUT_micro _scotchversion_hdr)
    file(STRINGS ${_scotchversion_hdr} _contents REGEX "#define SCOTCH_[A-Z]+[ \t]+")
    if(_contents)
        string(REGEX REPLACE ".*#define SCOTCH_VERSION[ \t]+([0-9]+).*" "\\1" ${_OUT_major} "${_contents}")
	string(REGEX REPLACE ".*#define SCOTCH_RELEASE[ \t]+([0-9]+).*" "\\1" ${_OUT_minor} "${_contents}")
	string(REGEX REPLACE ".*#define SCOTCH_PATCHLEVEL[ \t]+([0-9]+).*" "\\1" ${_OUT_micro} "${_contents}")

        if(NOT ${_OUT_major} MATCHES "[0-9]+")
            message(FATAL_ERROR "Version parsing failed for SCOTCH_VERSION!")
        endif()
        if(NOT ${_OUT_minor} MATCHES "[0-9]+")
            message(FATAL_ERROR "Version parsing failed for SCOTCH_RELEASE!")
        endif()
        if(NOT ${_OUT_micro} MATCHES "[0-9]+")
            message(FATAL_ERROR "Version parsing failed for SCOTCH_PATCHLEVEL!")
        endif()

        set(${_OUT_major} ${${_OUT_major}} PARENT_SCOPE)
        set(${_OUT_minor} ${${_OUT_minor}} PARENT_SCOPE)
        set(${_OUT_micro} ${${_OUT_micro}} PARENT_SCOPE)

    else()
        message(FATAL_ERROR "Include file ${_scotchversion_hdr} does not exist")
    endif()
endfunction()

find_package(PkgConfig)

pkg_check_modules(PC_SCOTCH scotch)

# Look for the header file.
FIND_PATH(SCOTCH_INCLUDE_DIR NAMES scotch.h PATH_SUFFIXES scotch HINTS ${PC_SCOTCH_INCLUDE_DIRS} )
if(SCOTCH_INCLUDE_DIR)
  _SCOTCH_GET_VERSION(SCOTCH_MAJOR_VERSION SCOTCH_MINOR_VERSION SCOTCH_PATCH_VERSION ${SCOTCH_INCLUDE_DIR}/scotch.h)
  set(SCOTCH_VERSION ${SCOTCH_MAJOR_VERSION}.${SCOTCH_MINOR_VERSION}.${SCOTCH_PATCH_VERSION})
else()
  set(SCOTCH_VERSION 0.0.0)
endif()

# Look for the library.
FIND_LIBRARY(SCOTCH_LIBRARY NAMES scotch libscotch HINTS ${PC_SCOTCH_LIBRARY_DIRS} )
find_library(SCOTCHERR_LIBRARY
  NAMES scotcherr
  HINTS ${PC_SCOTCH_LIBRARY_DIRS} )
# handle the QUIETLY and REQUIRED arguments and set SCOTCH_FOUND to TRUE if
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(SCOTCH REQUIRED_VARS SCOTCH_LIBRARY SCOTCH_ERR_LIBRARY SCOTCH_INCLUDE_DIR VERSION_VAR SCOTCH_VERSION)

# Copy the results to the output variables.
SET(SCOTCH_INCLUDE_DIRS ${SCOTCH_INCLUDE_DIR})
SET(SCOTCH_LIBRARIES ${SCOTCH_LIBRARY})
# some versions of scotch do/don't have scotcherr
if ( SCOTCHERR_LIBRARY )
  list( APPEND SCOTCH_LIBRARIES ${SCOTCHERR_LIBRARY} )
endif()

MARK_AS_ADVANCED(SCOTCH_INCLUDE_DIR SCOTCH_LIBRARY SCOTCH_ERR_LIBRARY)
