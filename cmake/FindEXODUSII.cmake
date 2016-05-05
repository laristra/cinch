#------------------------------------------------------------------------------#
# Copyright (c) 2016 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# - Find libexoIIv2c
# Find the native EXODUSII headers and libraries.
#
#  EXODUSII_INCLUDE_DIRS - where to find exodusII.h, etc.
#  EXODUSII_LIBRARIES    - List of libraries when using xoIIv2c.
#  EXODUSII_FOUND        - True if exodus found.
#

find_path(EXODUSII_INCLUDE_DIR exodusII.h)

#v6.09 calls it libexodus
#debian calls it libexoIIv2
#other distros libexoIIv2c
find_library(EXODUSII_LIBRARY NAMES exodus exoIIv2 exoIIv2c)

set(EXODUSII_LIBRARIES ${EXODUSII_LIBRARY} )
set(EXODUSII_INCLUDE_DIRS ${EXODUSII_INCLUDE_DIR} )

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set EXODUSII_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(EXODUSII DEFAULT_MSG EXODUSII_LIBRARY EXODUSII_INCLUDE_DIR )

mark_as_advanced(EXODUSII_INCLUDE_DIR EXODUSII_LIBRARY)
