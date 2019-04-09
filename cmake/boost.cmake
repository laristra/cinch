#--------------------------------------------------------------------------#
# Add Boost program options.
#--------------------------------------------------------------------------#

option(ENABLE_BOOST "Enable Boost" OFF)

if(ENABLE_BOOST)

  find_package(Boost REQUIRED 
    program_options
    atomic
    filesystem
    regex
    system
    QUIET)

  include_directories(${Boost_INCLUDE_DIRS})
  link_directories(${Boost_LIBRARY_DIRS})

  list(APPEND CINCH_RUNTIME_LIBRARIES ${Boost_LIBRARIES})

endif()
