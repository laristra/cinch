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

endif()

