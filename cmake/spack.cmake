#~----------------------------------------------------------------------------~#
# Copyright (c) 2018 Los Alamos National Security, LLC
# All rights reserved.
#~----------------------------------------------------------------------------~#

# These are a set of configurations that Spack suggests CMake packages
# be built with.  They mainly ensure that RPATHS are injected into binaries,
# and that transitive dependencies are included.
macro(cinch_spack_config)
  # enable @rpath in the install name for any shared library being built
  set(CMAKE_MACOSX_RPATH 1)

  # use full RPATH for the build tree
  set(CMAKE_SKIP_BUILD_RPATH FALSE)

  # when building, don't use the install PATH; only with installing
  set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

  # add the automatically determined parts of the RPATH, which point
  # to directories outside the build tree to the install RPATH
  set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

  # the RPATH to use when installing, but only if it's not a system directory
  list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES
    "${CMAKE_INSTALL_PREFIX}/lib" isSystemDir)
  if("${isSystemDir}" STREQUAL "-1")
    set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
  endif("${isSystemDir}" STREQUAL "-1")

  # Include all the transitive dependencies determined by Spack.
  # Does nothing if not building with Spack
  include_directories($ENV{SPACK_TRANSITIVE_INCLUDE_PATH})
endmacro(cinch_spack_config)
