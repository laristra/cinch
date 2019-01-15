#--------------------------------------------------------------------------#
# Add Boost program options.
#--------------------------------------------------------------------------#

option(ENABLE_BOOST "Enable Boost" OFF)
mark_as_advanced(ENABLE_BOOST)

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

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
