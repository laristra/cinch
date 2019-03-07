#------------------------------------------------------------------------------#
# Copyright (c) 2019 Triad National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(cinch_add_format)

    if(EXISTS ${PROJECT_SOURCE_DIR}/.clang-format)
      set(CLANG-FORMAT_BASE-VERSION "7.0.0")
      find_package(CLANG_FORMAT ${CLANG-FORMAT_BASE-VERSION})
      if (CLANG_FORMAT_FOUND)
        file(GLOB_RECURSE FORMAT_SOURCES SOURCES ${PROJECT_SOURCE_DIR}/*.cc ${PROJECT_SOURCE_DIR}/*.h)
        add_custom_target(format COMMAND ${CLANG_FORMAT_EXECUTABLE} -style=file -i ${FORMAT_SOURCES})
      else()
        add_custom_target(format COMMAND ${CMAKE_COMMAND} -E echo "No clang-format v${CLANG-FORMAT_BASE-VERSION} or newer found")
      endif()
    else()
      add_custom_target(format COMMAND ${CMAKE_COMMAND} -E echo "No ${PROJECT_SOURCE_DIR}/.clang-format found")
    endif()

endfunction(cinch_add_format)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
