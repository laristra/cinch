#--------------------------------------------------------------------------#
# Add support for Boost preprocessor.
#--------------------------------------------------------------------------#

option(ENABLE_BOOST_PREPROCESSOR "Enable Boost.Preprocessor subset" OFF)

if(ENABLE_BOOST_PREPROCESSOR)
    include_directories(${CINCH_SOURCE_DIR}/boost/preprocessor/include)
    add_definitions(-DENABLE_BOOST_PREPROCESSOR)
endif()

#--------------------------------------------------------------------------#
# Add Boost program options.
#--------------------------------------------------------------------------#

option(ENABLE_BOOST "Enable Boost" OFF)

option(ENABLE_BOOST_PROGRAM_OPTIONS
     "Enable Boost program options for command-line flags" OFF)

if (ENABLE_BOOST_PROGRAM_OPTIONS)
  set(ENABLE_BOOST ON CACHE BOOL "Enable Boost" FORCE)
  message (WARNING "ENABLE_BOOST_PROGRAM_OPTIONS option is deprecated. Please
    replace it with ENABLE_BOOST one" )
endif()

if(ENABLE_BOOST)
#set( Boost_USE_MULTITHREADED OFF )
#set( Boost_USE_STATIC_LIBS ON )
set( Boost_NO_SYSTEM_PATHS on CACHE BOOL "Do not search system for Boost" )
#set (Boost_REALPATH ON)

    find_package(Boost  REQUIRED 
      program_options
      atomic
      filesystem
      regex
      system
      QUIET)

    include_directories(${Boost_INCLUDE_DIRS})
    link_directories(${Boost_LIBRARY_DIRS})
    #FIXME rmove add_definition below after we replace 
    # ENABLE_BOOST_PROGRAM_OPTIONS with ENABLE_BOOST in FleCSI
    add_definitions(-DENABLE_BOOST_PROGRAM_OPTIONS)
    list(APPEND CINCH_RUNTIME_LIBRARIES ${Boost_LIBRARIES})
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -L${Boost_LIBRARY_DIRS}")
#    set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -L${Boost_LIBRARY_DIRS}")
#    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L${Boost_LIBRARY_DIRS}")

endif()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
