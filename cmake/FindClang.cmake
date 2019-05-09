#------------------------------------------------------------------------------#
# Check for Clang.
#------------------------------------------------------------------------------#

include(FindPackageHandleStandardArgs)


#------------------------------------------------------------------------------#
# Look for LLVM first
#------------------------------------------------------------------------------#

if (NOT LLVM_FOUND)
  find_package(LLVM ${Clang_FIND_VERSION})
endif()

#------------------------------------------------------------------------------#
# Look for executables (clang & clang++).
#------------------------------------------------------------------------------#
set(clang_names clang-7 clang-6 clang-5 clang-4 clang-3 clang)
set(clangpp_names clang++-7 clang++-6 clang++-5 clang++-4 clang++-3 clang++)

find_program(CLANG_EXEC NAMES ${clang_names} PATH_SUFFIXES bin)
find_program(CLANGXX_EXEC NAMES ${clangpp_names} PATH_SUFFIXES bin)

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
string(REGEX REPLACE ".*clang version ([0-9]+\\.[0-9]+\\.[0-9]+).*" "\\1"
    CLANG_VERSION ${CLANG_VERSION})

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
        
list(APPEND CLANG_LIBRARIES ${LLVM_LIBRARIES})
set(CLANG_INCLUDE_DIRS ${CLANG_INCLUDE_DIR} ${LLVM_INCLUDE_DIRS})

mark_as_advanced(CLANG_LIBRARIES)
mark_as_advanced(CLANG_INCLUDE_DIRS)

#------------------------------------------------------------------------------#
# Standard argument handling.
#------------------------------------------------------------------------------#

find_package_handle_standard_args(clang
    REQUIRED_VARS
        CLANG_EXEC
        CLANGXX_EXEC
        CLANG_INCLUDE_DIR
        CLANG_INCLUDE_DIRS
        CLANG_LIBRARIES
    VERSION_VAR
        CLANG_VERSION
)

#------------------------------------------------------------------------------#
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
