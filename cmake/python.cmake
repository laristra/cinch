#------------------------------------------------------------------------------#
# Add Boost options.
#------------------------------------------------------------------------------#

option(ENABLE_PYTHON "Enable Python" OFF)

if(ENABLE_PYTHON)

  find_package(Python3 COMPONENTS Interpreter)

endif()
