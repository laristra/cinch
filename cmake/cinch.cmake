#--------------------------------------------------------------------------#
# Add cinch include directory
#--------------------------------------------------------------------------#

include_directories(${CINCH_SOURCE_DIR})

#--------------------------------------------------------------------------#
# Configure header
#--------------------------------------------------------------------------#

set(CINCH_ENABLE_BOOST ${ENABLE_BOOST})
set(CINCH_ENABLE_CLOG ${ENABLE_CLOG})

configure_file(${CINCH_SOURCE_DIR}/config/cinch-config.h.in
  ${CMAKE_BINARY_DIR}/cinch-config.h @ONLY)

#--------------------------------------------------------------------------#
# Install cinch source files
#--------------------------------------------------------------------------#

install(FILES ${CMAKE_BINARY_DIR}/cinch-config.h
  DESTINATION include)
install(FILES ${CMAKE_SOURCE_DIR}/cinch/cinch/runtime.h
  DESTINATION include/cinch)
install(FILES ${CMAKE_SOURCE_DIR}/cinch/cinch/runtime.cc
  DESTINATION include/cinch)
