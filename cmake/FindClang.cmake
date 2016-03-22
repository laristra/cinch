#------------------------------------------------------------------------------#
# Check for Clang.
#------------------------------------------------------------------------------#

include(FindPackageHandleStandardArgs)

#------------------------------------------------------------------------------#
# Look for executables (clang & clang++).
#------------------------------------------------------------------------------#

find_program(CLANG_EXEC NAMES "clang" PATH_SUFFIXES bin)
find_program(CLANGXX_EXEC NAMES "clang++" PATH_SUFFIXES bin)

mark_as_advanced(CLANG_EXEC CLANGXX_EXEC)

#------------------------------------------------------------------------------#
# Get version information.
#------------------------------------------------------------------------------#

execute_process(COMMAND ${CLANG_EXEC} --version
    OUTPUT_VARIABLE CLANG_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET)

# strip the extra lines from the output
string(REGEX REPLACE "\n.*" "" CLANG_VERSION ${CLANG_VERSION})

mark_as_advanced(CLANG_VERSION)

#------------------------------------------------------------------------------#
# Remove executable name and directory to try to get base directory name.
#------------------------------------------------------------------------------#

get_filename_component(_clang_base_dir "${CLANG_EXEC}" PATH)
get_filename_component(_clang_base_dir "${_clang_base_dir}" PATH)

#------------------------------------------------------------------------------#
# Find clang include directory.
#------------------------------------------------------------------------------#

find_path(CLANG_INCLUDE_DIR clang/Basic/Version.h
    HINTS ${_clang_base_dir}
    PATH_SUFFIXES include
)

mark_as_advanced(CLANG_INCLUDE_DIR)

#------------------------------------------------------------------------------#
# Find clang libraries.
#------------------------------------------------------------------------------#

set(CLANG_LIBRARIES)

foreach(_lib ${Clang_FIND_COMPONENTS})

    find_library(_clang_${_lib} clang${_lib}
        HINTS ${_clang_base_dir}
        PATH_SUFFIXES lib lib64
    )

    if(_clang_${_lib})
        list(APPEND CLANG_LIBRARIES ${_clang_${_lib}})
    endif(_clang_${_lib})

endforeach(_lib ${Clang_FIND_COMPONENTS})

mark_as_advanced(CLANG_LIBRARIES)

#------------------------------------------------------------------------------#
# Standard argument handling.
#------------------------------------------------------------------------------#

find_package_handle_standard_args(clang
    REQUIRED_VARS
        CLANG_EXEC
        CLANGXX_EXEC
        CLANG_INCLUDE_DIR
        CLANG_LIBRARIES
    VERSION_VAR
        CLANG_VERSION
)

#------------------------------------------------------------------------------#
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
