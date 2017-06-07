#--------------------------------------------------------------------------#
# Add support for Boost preprocessor.
#--------------------------------------------------------------------------#

option(ENABLE_BOOST_PREPROCESSOR "Enable Boost.Preprocessor subset" OFF)

if(ENABLE_BOOST_PREPROCESSOR)
    include_directories(${CINCH_SOURCE_DIR}/boost/preprocessor/include)
endif()

#--------------------------------------------------------------------------#
# Add support for Boost program options.
#--------------------------------------------------------------------------#

option(ENABLE_BOOST_PROGRAM_OPTIONS
    "Enable Boost program options for command-line flags" OFF)

if(ENABLE_BOOST_PROGRAM_OPTIONS)
    find_package(Boost 1.58.0 COMPONENTS program_options REQUIRED)

    include_directories(${Boost_INCLUDE_DIRS})
    add_definitions(-DENABLE_BOOST_PROGRAM_OPTIONS)
endif()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
