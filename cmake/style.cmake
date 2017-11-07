#--------------------------------------------------------------------------#
# Style options 
#--------------------------------------------------------------------------#

find_program(CLANG_FORMAT "clang-format")
find_package_handle_standard_args(CLANG_FORMAT REQUIRED_VARS CLANG_FORMAT)
if (CLANG_FORMAT_FOUND AND NOT TARGET format)
   file(GLOB_RECURSE _SOURCES ${PROJECT_SOURCE_DIR}/*.cc ${PROJECT_SOURCE_DIR}/*.h)
   add_custom_target(format COMMAND ${CLANG_FORMAT} -style=Google -i ${_SOURCES})
endif()
