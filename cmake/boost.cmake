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

option(ENABLE_BOOST_PROGRAM_OPTIONS
    "Enable Boost program options for command-line flags" OFF)

if(ENABLE_BOOST_PROGRAM_OPTIONS)
    find_package(Boost COMPONENTS program_options REQUIRED QUIET)
    include_directories(${Boost_INCLUDE_DIRS})
    add_definitions(-DENABLE_BOOST_PROGRAM_OPTIONS)
    list(APPEND CINCH_RUNTIME_LIBRARIES ${Boost_LIBRARIES})
endif()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
