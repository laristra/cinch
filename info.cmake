#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

function(make_info target headers sources)

  set(output "${CMAKE_BINARY_DIR}/.${target}.buildinfo")

  file(WRITE "${output}" "#---------------------------------------"
             "---------------------------------------#\n")
  file(APPEND "${output}"
    "# CMake configuration information for target ${target}\n")
  file(APPEND "${output}" "# This information is stored in:\n"
    "# ${output}\n")
  file(APPEND "${output}" "#---------------------------------------"
             "---------------------------------------#\n")

  file(APPEND "${output}" "\n")

  # write C++ header list
  file(APPEND "${output}" "# C++ Headers\n")
  foreach(hdr ${headers})
    file(APPEND "${output}" "${hdr}\n")
  endforeach(hdr)

  file(APPEND "${output}" "\n")

  # write C++ header list
  file(APPEND "${output}" "# C++ Sources\n")
  foreach(src ${sources})
    file(APPEND "${output}" "${src}\n")
  endforeach(src)

  file(APPEND "${output}" "\n")

endfunction(make_info)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=2 shiftwidth=2 expandtab :
#------------------------------------------------------------------------------#
