#--------------------------------------------------------------------------#
# Add support for Boost preprocessor.
#--------------------------------------------------------------------------#

option(ENABLE_BOOST_PREPROCESSOR "Enable Boost.Preprocessor subset" OFF)

if(ENABLE_BOOST_PREPROCESSOR)
    include_directories(${CINCH_SOURCE_DIR}/boost/preprocessor/include)
endif()

#--------------------------------------------------------------------------#
# Add Boost program options.
#--------------------------------------------------------------------------#

option(ENABLE_BOOST_PROGRAM_OPTIONS
    "Enable Boost program options for command-line flags" OFF)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
